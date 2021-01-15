module R10.Translations exposing (language, signIn, signInHeader, signOut)

{-| Text translations.

This is an examples of translation:

    signInHeader : R10.Language.Translations
    signInHeader =
        { key = "signInHeader"
        , en_us = "Sign in to your Rakuten account"
        , ja_jp = "楽天会員 ログイン"
        , zh_tw = "登錄您的Rakuten帳戶"
        , de_de = "Loggen Sie sich in Ihr Rakuten-Konto ein"
        , fr_fr = "Connectez-vous à votre compte Rakuten"
        }

@docs language, signIn, signInHeader, signOut

-}

import R10.Language


{-| -}
signInHeader : R10.Language.Translations
signInHeader =
    { key = "signInHeader"
    , en_us = "Sign in to your Rakuten account"
    , ja_jp = "楽天会員 ログイン"
    , zh_tw = "登錄您的Rakuten帳戶"
    , de_de = "Loggen Sie sich in Ihr Rakuten-Konto ein[[R]]"
    , fr_fr = "Connectez-vous à votre compte Rakuten"
    , es_es = "Inicie sesión en su cuenta de Rakuten"
    }


{-| -}
language : R10.Language.Translations
language =
    { key = "language"
    , en_us = "Language"
    , ja_jp = "言語"
    , zh_tw = "語言"
    , de_de = "Sprache"
    , fr_fr = "Langue"
    , es_es = "Idioma"
    }


{-| -}
signOut : R10.Language.Translations
signOut =
    { key = "signOut"
    , en_us = "Sign Out"
    , ja_jp = "ログアウト"
    , zh_tw = "登出"
    , de_de = "Ausloggen"
    , fr_fr = "Déconnexion"
    , es_es = "Desconectar"
    }


{-| -}
signIn : R10.Language.Translations
signIn =
    { key = "signIn"
    , en_us = "Sign in"
    , ja_jp = "ログイン"
    , zh_tw = "登入"
    , de_de = "Anmelden"
    , fr_fr = "Se connecter"
    , es_es = "Registrarse"
    }
