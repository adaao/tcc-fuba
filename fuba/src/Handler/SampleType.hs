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
   newSampleType <- requireJsonBody :: Handler SampleType
   newSampleTypeId <- runDB $ insert newSampleType
   sendStatusJSON created201 (object ["resp" .= (fromSqlKey newSampleTypeId)])
   
getReadSampleTypeR :: SampleTypeId -> Handler Value
getReadSampleTypeR sampleTypeId = do
   sampleType <- runDB $ get404 sampleTypeId
   sendStatusJSON ok200 (object ["resp" .= (toJSON sampleType)])
{-
putUpdateSampleTypeR :: SampleTypeId -> Handler SampleType
putUpdateSampleTypeR sampleTypeToBeUpdatedId = do
   _ <- runDB $ get404 sampleTypeToBeUpdatedId
   updatedSampleType <- requireJsonBody :: Handler SampleType
   runDB $ replace sampleTypeToBeUpdatedId updatedSampleType
   sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey sampleTypeToBeUpdatedId)])
-}

getListSampleTypes :: Handler Value
getListSampleTypes = do
   sampleTypeList <- runDB $ selectList [] [Asc SampleTypeDescription]
   sendStatusJSON ok200 (object ["resp" .= (toJSON sampleTypeList)])
   
