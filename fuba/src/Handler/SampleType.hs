{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LAVGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.SampleType where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postInsertSampleTypeR :: Handler Value
postInsertSampleTypeR = do
   newSampleType <- requireJsonBody :: Handler SampleTypes
   newSampleTypeId <- runDB $ insert newSampleType
   sendStatusJSON created201 (object ["resp" .= (fromSqlKey newSampleTypeId)])
   
getReadSampleType :: SampleTypeId -> Handler Value
getReadSampleType sampleTypeId = do
   sampleType <- runDB $ get404 sampleTypeId
   sendStatusJSON ok200 (object ["resp" .= (toJSON sampleType)])

getListSampleTypes :: Handler Value
getListSampleTypes = do
   sampleTypeList <- runDB $ selectList [] [Asc SampleTypesSampleType]
   sendStatusJSON ok200 (object ["resp" .= (toJSON sampleTypeList)])
   
