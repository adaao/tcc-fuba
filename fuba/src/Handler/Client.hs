{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LAVGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Client where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postInsertClientR :: Handler Value
postInsertClientR = do
   client <- requireJsonBody :: Handler Client
   clientId <- runDB $ insert client
   sendStatusJSON created201 (object ["resp" .= (fromSqlKey clientId)])

getReadClientR :: ClientId -> Handler Value
getReadClientR clientId = do
   client <- runDB $ get404 clientId
   sendStatusJSON ok200 (object ["resp" .= (toJSON client)])

putUpdateClientR :: ClientId -> Handler Value
putUpdateClientR clientId = do
   _ <- runDB $ get404 clientId
   clientUpdated <- requireJsonBody :: Handler Client
   runDB $ replace clientId clientUpdated
   sendStatusJson noContent204 (object ["resp" .= (formSqlKey clientId)])

deleteDeleteClientR :: ClientId -> Handler Value
deleteDeleteClientR clientId = do 
   _ <- runDB $ get404 clientId
   runDB $ delete clientId
   sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey clientId)])