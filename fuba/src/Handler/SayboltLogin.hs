{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
-- | Common handler functions.
module Handler.SayboltLogin where

import Import
import Database.Persist.Postgresql


formLogin :: Form (Text,Text)
formLogin = renderBootstrap2 $ (,)
    <$> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing

getSayboltLoginR :: Handler Html
getSayboltLoginR = do
   (formLog, enctype) <- generateFormPost formLogin
   defaultLayout
      [whamlet|
         <form method="post" action=@{SayboltLoginR} enctype=#{enctype}>
            ^{formLog}
            <input type="submit" value="Logar">
      |]

autentica :: Text -> Text -> HandlerT App IO (Maybe (Entity SayboltUser))
autentica email password = runDB $ selectFirst [SayboltUserEmail ==. email
                                               ,SayboltUserPassword ==. password] []

postSayboltLoginR :: Handler Html
postSayboltLoginR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess (email,password) -> do
            maybeUser <- autentica email password
            case maybeUser of
                Nothing -> do
                    setMessage [shamlet|
                        <div>
                            Usuario nao encontrado/Senha invalida!
                    |]
                    redirect SayboltLoginR
                Just (Entity _ usr) -> do
                    setSession (sayboltUserName usr) "_NAME"
                    redirect $ SayboltHomeR
        _ -> redirect HomeR


-- backup of postLoginnR
{-
postLoginnR :: Handler Html
postLoginnR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess ("root@root.com","root") -> do
            setSession "_NOME" "admin"
            redirect
        FormSuccess (email,senha) -> do
            maybeUser <- autentica email password
            case maybeUser of
                Nothing -> do
                    setMessage [shamlet|
                        <div>
                            Usuario nao encontrado/Senha invalida!
                    |]
                    redirect LoginnR
                Just (Entity _ usr) -> do
                    setSession "_NOME" (userName usr)
                    redirect HomeR
            redirect
        _ -> redirect HomeR

-}


-- getMessage :: Text
-- getMessage = "Usuário não encontrado ou senha inválida!"
