{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LAVGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.UserType where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postInsertUserTypeR :: Handler Value
postInsertUserTypeR = do
   newUserType <- requireJsonBody :: Handler UserType
   newUserTypeId <- runDB $ insert newUserType
   sendStatusJSON created201 (object ["resp" .= (fromSqlKey newUserTypeId)])

getReadUserTypeR :: UserTypeId -> Handler Value
getReadUserTypeR userTypeId = do
   userType <- runDB $ get404 userTypeId
   sendStatusJSON ok200 (object ["resp" .= (toJSON userType)])

putUpdateUserTypeR :: UserTypeId -> Handler Value
putUpdateUserTypeR userTypeToBeUpdatedId = do
   _ <- runDB $ get404 userTypeToBeUpdatedId
   updatedUserType <- requireJsonBody :: Handler UserType
   runDB $ replace userTypeToBeUpdatedId updatedUserType
   sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey userTypeToBeUpdatedId)])