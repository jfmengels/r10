module R10.Form.Internal.Validation exposing
    ( commonValidation
    , validate
    )

import Dict
import R10.Form.Internal.Dict
import R10.Form.Internal.FieldConf
import R10.Form.Internal.FieldState
import R10.Form.Internal.Key
import R10.Form.Internal.State
import R10.Form.Internal.Translator
import Regex


type ValidationOutcome
    = Valid
    | NotValid


runRegex : String -> String -> ValidationOutcome
runRegex pattern value =
    case Regex.fromString pattern of
        Just regex ->
            if Regex.contains regex value then
                Valid

            else
                NotValid

        Nothing ->
            -- Regex Not Valid
            NotValid


isValid : R10.Form.Internal.FieldState.ValidationOutcome -> Bool
isValid outcome =
    case outcome of
        R10.Form.Internal.FieldState.MessageOk _ _ ->
            True

        R10.Form.Internal.FieldState.MessageErr _ _ ->
            False


toMessageOk : R10.Form.Internal.FieldState.ValidationOutcome -> R10.Form.Internal.FieldState.ValidationOutcome
toMessageOk outcome =
    case outcome of
        R10.Form.Internal.FieldState.MessageOk _ _ ->
            outcome

        R10.Form.Internal.FieldState.MessageErr msg payload ->
            R10.Form.Internal.FieldState.MessageOk msg payload


toMessageErr : R10.Form.Internal.FieldState.ValidationOutcome -> R10.Form.Internal.FieldState.ValidationOutcome
toMessageErr outcome =
    case outcome of
        R10.Form.Internal.FieldState.MessageOk msg payload ->
            R10.Form.Internal.FieldState.MessageErr msg payload

        R10.Form.Internal.FieldState.MessageErr _ _ ->
            outcome


validateDependant :
    R10.Form.Internal.Key.Key
    -> R10.Form.Internal.Key.KeyAsString
    -> R10.Form.Internal.State.State
    -> R10.Form.Internal.FieldConf.Validation
    -> Maybe R10.Form.Internal.FieldState.ValidationOutcome
validateDependant key dependantKey formState validation =
    let
        newLeafKey : R10.Form.Internal.Key.Key
        newLeafKey =
            R10.Form.Internal.Key.replaceLeaf dependantKey key

        newFullKey : R10.Form.Internal.Key.Key
        newFullKey =
            dependantKey |> R10.Form.Internal.Key.fromString

        -- newContextValue : String
        -- newContextValue =
        --     Dict.get dependantKey formState.fieldsState
        --         |> Maybe.map .value
        --         |> Maybe.withDefault ""
        newLeafContextValue : Maybe ( String, R10.Form.Internal.Key.Key )
        newLeafContextValue =
            formState.fieldsState
                |> Dict.get (newLeafKey |> R10.Form.Internal.Key.toString)
                |> Maybe.map (\rec -> ( rec.value, newLeafKey ))

        newFullContextValue : Maybe ( String, R10.Form.Internal.Key.Key )
        newFullContextValue =
            formState.fieldsState
                |> Dict.get (newFullKey |> R10.Form.Internal.Key.toString)
                |> Maybe.map (\rec -> ( rec.value, newFullKey ))

        defaultContextValue : ( String, R10.Form.Internal.Key.Key )
        defaultContextValue =
            ( "", newFullKey )

        result =
            newLeafContextValue
                |> Maybe.withDefault
                    (newFullContextValue
                        |> Maybe.withDefault defaultContextValue
                    )
    in
    result
        |> (\( newContextValue, newKey ) ->
                validateValidationSpecs newKey newContextValue formState validation
           )


validateEqual : String -> R10.Form.Internal.Key.KeyAsString -> R10.Form.Internal.State.State -> R10.Form.Internal.FieldState.ValidationOutcome
validateEqual value dependantKey formState =
    let
        dependantValue : String
        dependantValue =
            Dict.get dependantKey formState.fieldsState
                |> Maybe.map .value
                |> Maybe.withDefault ""
    in
    if value == dependantValue then
        R10.Form.Internal.FieldState.MessageOk R10.Form.Internal.Translator.validationCodes.equalInvalid []

    else
        R10.Form.Internal.FieldState.MessageErr R10.Form.Internal.Translator.validationCodes.equalInvalid []


validateNot : R10.Form.Internal.Key.Key -> String -> R10.Form.Internal.State.State -> R10.Form.Internal.FieldConf.Validation -> Maybe R10.Form.Internal.FieldState.ValidationOutcome
validateNot key value formState validation =
    let
        outcome : Maybe R10.Form.Internal.FieldState.ValidationOutcome
        outcome =
            validateValidationSpecs key value formState validation
    in
    case outcome of
        Just (R10.Form.Internal.FieldState.MessageOk a b) ->
            Just <| R10.Form.Internal.FieldState.MessageErr a b

        Just (R10.Form.Internal.FieldState.MessageErr a b) ->
            Just <| R10.Form.Internal.FieldState.MessageOk a b

        Nothing ->
            Nothing


validateAllOf : R10.Form.Internal.Key.Key -> String -> R10.Form.Internal.State.State -> List R10.Form.Internal.FieldConf.Validation -> R10.Form.Internal.FieldState.ValidationOutcome
validateAllOf key value formState validations =
    let
        messages : List R10.Form.Internal.FieldState.ValidationOutcome
        messages =
            List.map (validateValidationSpecs key value formState) validations
                |> List.filterMap identity
    in
    if List.isEmpty messages then
        R10.Form.Internal.FieldState.MessageOk R10.Form.Internal.Translator.validationCodes.allOf []

    else if List.all isValid messages then
        R10.Form.Internal.FieldState.MessageOk R10.Form.Internal.Translator.validationCodes.allOf []

    else
        R10.Form.Internal.FieldState.MessageErr R10.Form.Internal.Translator.validationCodes.allOf []


validateOneOf : R10.Form.Internal.Key.Key -> String -> R10.Form.Internal.State.State -> List R10.Form.Internal.FieldConf.Validation -> R10.Form.Internal.FieldState.ValidationOutcome
validateOneOf key value formState validations =
    let
        messages : List R10.Form.Internal.FieldState.ValidationOutcome
        messages =
            List.map (validateValidationSpecs key value formState) validations
                |> List.filterMap identity
    in
    if List.isEmpty messages then
        R10.Form.Internal.FieldState.MessageOk R10.Form.Internal.Translator.validationCodes.oneOf []

    else if List.any isValid messages then
        R10.Form.Internal.FieldState.MessageOk R10.Form.Internal.Translator.validationCodes.oneOf []

    else
        R10.Form.Internal.FieldState.MessageErr R10.Form.Internal.Translator.validationCodes.oneOf []


validateWithMsg : R10.Form.Internal.Key.Key -> String -> R10.Form.Internal.FieldConf.ValidationMessage -> R10.Form.Internal.State.State -> R10.Form.Internal.FieldConf.Validation -> Maybe R10.Form.Internal.FieldState.ValidationOutcome
validateWithMsg key value msg formState validation =
    let
        maybeMessage : Maybe R10.Form.Internal.FieldState.ValidationOutcome
        maybeMessage =
            validateValidationSpecs key value formState validation
    in
    case maybeMessage of
        Nothing ->
            Nothing

        Just message ->
            if isValid message then
                Just <| R10.Form.Internal.FieldState.MessageOk msg.ok []

            else
                Just <| R10.Form.Internal.FieldState.MessageErr msg.err []


validateRequired : String -> R10.Form.Internal.FieldState.ValidationOutcome
validateRequired value =
    if String.isEmpty value then
        R10.Form.Internal.FieldState.MessageErr R10.Form.Internal.Translator.validationCodes.required []

    else
        R10.Form.Internal.FieldState.MessageOk R10.Form.Internal.Translator.validationCodes.required []


validateEmpty : String -> R10.Form.Internal.FieldState.ValidationOutcome
validateEmpty value =
    if String.isEmpty value then
        R10.Form.Internal.FieldState.MessageOk R10.Form.Internal.Translator.validationCodes.empty []

    else
        R10.Form.Internal.FieldState.MessageErr R10.Form.Internal.Translator.validationCodes.empty []


validateMinLength : String -> Int -> R10.Form.Internal.FieldState.ValidationOutcome
validateMinLength value length =
    if String.length value < length then
        R10.Form.Internal.FieldState.MessageErr R10.Form.Internal.Translator.validationCodes.lengthTooSmallInvalid [ String.fromInt length ]

    else
        R10.Form.Internal.FieldState.MessageOk R10.Form.Internal.Translator.validationCodes.lengthTooSmallInvalid [ String.fromInt length ]


validateMaxLength : String -> Int -> R10.Form.Internal.FieldState.ValidationOutcome
validateMaxLength value length =
    if String.length value > length then
        R10.Form.Internal.FieldState.MessageErr R10.Form.Internal.Translator.validationCodes.lengthTooLargeInvalid [ String.fromInt length ]

    else
        R10.Form.Internal.FieldState.MessageOk R10.Form.Internal.Translator.validationCodes.lengthTooLargeInvalid [ String.fromInt length ]


validateRegex : String -> String -> R10.Form.Internal.FieldState.ValidationOutcome
validateRegex value regex =
    case runRegex regex value of
        Valid ->
            R10.Form.Internal.FieldState.MessageOk R10.Form.Internal.Translator.validationCodes.formatInvalid []

        NotValid ->
            R10.Form.Internal.FieldState.MessageErr R10.Form.Internal.Translator.validationCodes.formatInvalid []


skipValidationIfEmpty : String -> R10.Form.Internal.FieldState.ValidationOutcome -> Maybe R10.Form.Internal.FieldState.ValidationOutcome
skipValidationIfEmpty value validationOutcome =
    if String.isEmpty value then
        Nothing

    else
        Just validationOutcome


validateValidationSpecs : R10.Form.Internal.Key.Key -> String -> R10.Form.Internal.State.State -> R10.Form.Internal.FieldConf.Validation -> Maybe R10.Form.Internal.FieldState.ValidationOutcome
validateValidationSpecs key value formState validation =
    case validation of
        R10.Form.Internal.FieldConf.WithMsg msg validation_ ->
            validateWithMsg key value msg formState validation_

        R10.Form.Internal.FieldConf.Dependant dependantKey validation_ ->
            validateDependant key dependantKey formState validation_

        R10.Form.Internal.FieldConf.OneOf validations ->
            Just <| validateOneOf key value formState validations

        R10.Form.Internal.FieldConf.AllOf validations ->
            Just <| validateAllOf key value formState validations

        R10.Form.Internal.FieldConf.Required ->
            Just <| validateRequired value

        R10.Form.Internal.FieldConf.Empty ->
            Just <| validateEmpty value

        R10.Form.Internal.FieldConf.Regex regex ->
            skipValidationIfEmpty value <|
                validateRegex value regex

        R10.Form.Internal.FieldConf.MinLength length ->
            skipValidationIfEmpty value <|
                validateMinLength value length

        R10.Form.Internal.FieldConf.MaxLength length ->
            skipValidationIfEmpty value <|
                validateMaxLength value length

        R10.Form.Internal.FieldConf.Equal dependantKey ->
            skipValidationIfEmpty value <|
                validateEqual value dependantKey formState

        R10.Form.Internal.FieldConf.Not validation_ ->
            validateNot key value formState validation_

        R10.Form.Internal.FieldConf.NoValidation ->
            Nothing


validate : R10.Form.Internal.Key.Key -> Maybe R10.Form.Internal.FieldConf.ValidationSpecs -> R10.Form.Internal.State.State -> R10.Form.Internal.FieldState.FieldState -> R10.Form.Internal.FieldState.FieldState
validate key maybeValidationSpec formState state =
    let
        isDisabled : Bool
        isDisabled =
            R10.Form.Internal.Dict.get key formState.fieldsState
                |> Maybe.map .disabled
                |> Maybe.withDefault False

        validationSpec : List R10.Form.Internal.FieldConf.Validation
        validationSpec =
            if isDisabled then
                [ R10.Form.Internal.FieldConf.NoValidation ]

            else
                maybeValidationSpec
                    |> Maybe.map .validation
                    |> Maybe.withDefault [ R10.Form.Internal.FieldConf.NoValidation ]
    in
    { state
        | validation =
            validationSpec
                |> List.map (validateValidationSpecs key state.value formState)
                |> List.filterMap identity
                |> R10.Form.Internal.FieldState.Validated
    }



--
-- validateOld : Maybe R10.Form.Internal.FieldConf.ValidationSpecs -> R10.Form.Internal.State.State -> R10.Form.Internal.FieldState.FieldState -> R10.Form.Internal.FieldState.FieldState
-- validateOld maybeValidationSpec formState state =
--     { state
--         | validation =
--             Form.FieldState.Validated <|
--                 validateValidationSpecs state.value
--                     formState
--                     (maybeValidationSpec |> Maybe.map .validation |> Maybe.withDefault NoValidation)
--
--     }
-- ██████  ██    ██ ██      ███████ ███████
-- ██   ██ ██    ██ ██      ██      ██
-- ██████  ██    ██ ██      █████   ███████
-- ██   ██ ██    ██ ██      ██           ██
-- ██   ██  ██████  ███████ ███████ ███████


commonRegularExpression :
    { alpha : String
    , alphaNumeric : String
    , alphaNumericDash : String
    , alphaNumericDashSpace : String
    , phoneNumber : String
    , email : String
    , numeric : String
    , integer : String
    , decimal : String
    , url : String
    , hexColor : String
    }
commonRegularExpression =
    { alpha = "^[a-zA-Z]*$"
    , alphaNumeric = "^[a-zA-Z0-9]*$"
    , alphaNumericDash = "^[A-Za-z0-9_.-]*$"
    , alphaNumericDashSpace = "^[A-Za-z0-9_.-\\s]*$"
    , phoneNumber = "^\\+?[1-9]\\d+$"
    , email = "^[\\u0021\\u0023-\\u0027\\u002B\\u002D-\\u0039\\u003D\\u003F\\u0041-\\u005A\\u005E-\\u007E]+@[\\u002D\\u0030-\\u0039\\u0041-\\u005A\\u0061-\\u007A]+(\\.[\\u002D\\u0030-\\u0039\\u0041-\\u005A\\u0061-\\u007A]+)+$"
    , numeric = "^([0-9]+)$"
    , integer = "^\\d+$"
    , decimal = "^-?\\d*(\\.\\d+)?$"
    , url = "^[\\.\\-\\+\\w]*?:\\/\\/\\w+(\\.\\w+)*(:[0-9]+)?[\\w\\-\\._~:\\/?#[\\]@!\\$&'\\(\\)\\*\\+,;=.]+$"
    , hexColor = "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$"
    }


commonValidation :
    { alphaNumericDash : R10.Form.Internal.FieldConf.Validation
    , alphaNumericDashSpace : R10.Form.Internal.FieldConf.Validation
    , email : R10.Form.Internal.FieldConf.Validation
    , hexColor : R10.Form.Internal.FieldConf.Validation
    , password : R10.Form.Internal.FieldConf.Validation
    , phoneNumber : R10.Form.Internal.FieldConf.Validation
    , url : R10.Form.Internal.FieldConf.Validation
    , numeric : R10.Form.Internal.FieldConf.Validation
    }
commonValidation =
    { phoneNumber =
        R10.Form.Internal.FieldConf.WithMsg { ok = R10.Form.Internal.Translator.validationCodes.formatValid, err = R10.Form.Internal.Translator.validationCodes.formatInvalid } <|
            R10.Form.Internal.FieldConf.Regex commonRegularExpression.phoneNumber
    , email =
        R10.Form.Internal.FieldConf.WithMsg { ok = R10.Form.Internal.Translator.validationCodes.emailFormatInvalid, err = R10.Form.Internal.Translator.validationCodes.emailFormatInvalid } <|
            R10.Form.Internal.FieldConf.Regex commonRegularExpression.email
    , password =
        R10.Form.Internal.FieldConf.AllOf
            [ R10.Form.Internal.FieldConf.WithMsg { ok = R10.Form.Internal.Translator.validationCodes.formatNoUppercaseInvalid, err = R10.Form.Internal.Translator.validationCodes.formatNoUppercaseInvalid } <|
                R10.Form.Internal.FieldConf.Regex "[A-Z]"
            , R10.Form.Internal.FieldConf.WithMsg { ok = R10.Form.Internal.Translator.validationCodes.formatNoNumberInvalid, err = R10.Form.Internal.Translator.validationCodes.formatNoNumberInvalid } <|
                R10.Form.Internal.FieldConf.Regex "[0-9]"
            , R10.Form.Internal.FieldConf.WithMsg { ok = R10.Form.Internal.Translator.validationCodes.formatNoSpecialCharactersInvalid, err = R10.Form.Internal.Translator.validationCodes.formatNoSpecialCharactersInvalid } <|
                R10.Form.Internal.FieldConf.Regex "[~!@#$%^&*()_+|}{\\[\\]|\\><?:\\\";',./=-]"
            ]
    , alphaNumericDash =
        R10.Form.Internal.FieldConf.WithMsg { ok = R10.Form.Internal.Translator.validationCodes.formatValid, err = R10.Form.Internal.Translator.validationCodes.formatInvalid } <|
            R10.Form.Internal.FieldConf.Regex commonRegularExpression.alphaNumericDash
    , alphaNumericDashSpace =
        R10.Form.Internal.FieldConf.WithMsg { ok = R10.Form.Internal.Translator.validationCodes.formatValid, err = R10.Form.Internal.Translator.validationCodes.formatInvalid } <|
            R10.Form.Internal.FieldConf.Regex commonRegularExpression.alphaNumericDashSpace
    , url =
        R10.Form.Internal.FieldConf.WithMsg { ok = R10.Form.Internal.Translator.validationCodes.formatValid, err = R10.Form.Internal.Translator.validationCodes.formatInvalid } <|
            R10.Form.Internal.FieldConf.Regex commonRegularExpression.url
    , hexColor =
        R10.Form.Internal.FieldConf.WithMsg { ok = R10.Form.Internal.Translator.validationCodes.hexColorFormatInvalid, err = R10.Form.Internal.Translator.validationCodes.hexColorFormatInvalid } <|
            R10.Form.Internal.FieldConf.Regex commonRegularExpression.hexColor
    , numeric =
        R10.Form.Internal.FieldConf.WithMsg { ok = R10.Form.Internal.Translator.validationCodes.formatValid, err = R10.Form.Internal.Translator.validationCodes.formatInvalid } <|
            R10.Form.Internal.FieldConf.Regex commonRegularExpression.numeric
    }
