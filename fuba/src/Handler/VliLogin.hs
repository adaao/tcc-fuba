{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
-- | Common handler functions.
module Handler.VliLogin where

import Import
import Database.Persist.Postgresql

formLogin :: Form (Text,Text) 
formLogin = renderDivs $ (,) 
    <$> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing
 
getVliLoginR :: Handler Html
getVliLoginR = do 
    (widget,enctype) <- generateFormPost formLogin
    mensa <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe msg <- mensa
                ^{msg}
            <form action=@{VliLoginR} method=post>
                ^{widget}
                <input type="submit" value="Login">
        |]

autentica :: Text -> Text -> HandlerT App IO (Maybe (Entity VliUser))
autentica email password = runDB $ selectFirst [VliUserEmail ==. email
                                               ,VliUserPassword ==. password] []
                                               
postVliLoginR :: Handler Html
postVliLoginR = do 
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
                    setSession (vliUserName usr)  "_NAME"
                    redirect $ VliHomeR
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

postLogoutR :: Handler Html
postLogoutR = do 
    deleteSession "_NAME"
    redirect HomeR

-- getMessage :: Text
-- getMessage = "Usuário não encontrado ou senha inválida!"