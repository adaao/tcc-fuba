{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LAVGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.User where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postInsertUserR :: Handler Value
postInsertUserR = do
   newUser <- requireJsonBody :: Handler User
   newUserId <- runDB $ insert newUser
   sendStautsJSON created201 (object ["resp" .= (fromSqlKey newUserId)])

getReadUserR :: UserId -> Handler Value
gettReadUserR userId = do
   user <- runDB $ get404 userId
   sendStatusJSON ok200 (object ["resp" .= (toJSON user)])

putUpdateUserR :: UserId -> Handler Value
putUpdateUserR userToBeUpdatedId = do
   _ <- runDB $ get404 userToBeUpdatedId
   updatedUser <- requireJsonBody :: Handler User
   runDB $ replace userToBeUpdatedId updatedUser
   sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey userToBeUpdatedId)])