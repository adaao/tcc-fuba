{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LAVGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Dao where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postInsertData :: String -> Handler Value
postInsertData table = do
   dataToBeInserted <- requireJsonBody :: Handler table
   dataIsertedId <- runDB $ insert dataToBeInserted
   sendStatusJSON created201 (object ["resp" .= (fromSqlKey dataInsertedId)])

getReadData :: String -> Handler Value
getReadData dataId = do
   dataRecovered <- runDB $ get404 dataId
   sendStatusJSON ok200 (object ["resp" .= (toJSON dataRecovered)])
   


