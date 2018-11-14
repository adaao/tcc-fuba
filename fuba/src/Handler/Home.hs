{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Home where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
import Text.Julius (RawJS (..))

getHomeR :: Handler Html
getHomeR = defaultLayout $(whamletFile "templates/homepage.hamlet")

postLogautR :: Handler Html
postLogautR = do
    deleteSession "_NAME"
    redirect HomeR
