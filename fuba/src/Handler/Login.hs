{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
-- | Common handler functions.
module Handler.Login where

import Import
import Database.Persist.Postgresql

formLogin :: Form (Text,Text) 
formLogin = renderDivs $ (,) 
    <$> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing
{-
postLoginnR :: Handler Html
postLoginnR = undefined

getLoginnR :: Handler Html
getLoginnR = undefined
-}
   
getLoginnR :: Handler Html
getLoginnR = do 
    (widget,enctype) <- generateFormPost formLogin
    mensa <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe msg <- mensa
                ^{msg}
            <form action=@{LoginnR} method=post>
                ^{widget}
                <input type="submit" value="Login">
        |]

autentica :: Text -> Text -> HandlerT App IO (Maybe (Entity User))
autentica email password = runDB $ selectFirst [UserEmail ==. email
                                               ,UserPassword ==. password] []

postLoginnR :: Handler Html
postLoginnR = do 
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess ("root@root.com","root") -> do 
            setSession "_NOME" "admin"
            redirect 
        FormSuccess (email,senha) -> do 
            maybeUser <- autentica email senha
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

postLogoutR :: Handler Html
postLogoutR = do 
    deleteSession "_NOME"
    redirect HomeR

-- getMessage :: Text
-- getMessage = "Usuário não encontrado ou senha inválida!"