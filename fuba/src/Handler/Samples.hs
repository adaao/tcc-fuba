{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Samples where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postCreateSampleR :: Handler Value
postCreateSampleR = do
   newSample <- requireJsonBody :: Handler Samples
   newSampleId <- runDB $ insert newSample
   sendStatusJSON created201 (object ["resp" .= (fromSqlKey newSampleId)])

{-
getUserNameByUsersId :: UsersId -> Widget
getUserNameByUsersId uid = do
    user <- handlerToWidget $ runDB $ get404 uid
    [whamlet|<span>#{usersNickName user}|]
-}

getReadSampleR :: Text -> Handler Value
getReadSampleR vessel = do
   

putUpdateSampleR :: Text -> Handler Value
putUpdateSampleR = undefined
