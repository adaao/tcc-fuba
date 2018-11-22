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


EXEMPLO DROPDOWN ANO
    <*> areq (jqueryDayField def
    { jdsChangeYear = True -- give a year drop-down
    , jdsYearRange = "1900:-5" -- 1900 to five years ago
    }) "Birthday" Nothing


--getReadSampleR :: Text -> Handler Value
--getReadSampleR samplesVessel = undefined

getReadSampleR :: Text -> Handler Value
getReadSampleR vessel = do
   sample <- runDB $ getBy404 $ SamplesVessel vessel
   sendStatusJSON ok200 (object ["resp" .= (toJSON sample)])
-}

getReadSamplesR :: Text -> Handler Value
getReadSamplesR vessel = do
   samplesList <- runDB $ selectList [SamplesVessel ==. vessel] [Desc SamplesQuantity]
   sendStatusJSON ok200 (object ["resp" .= (toJSON samplesList)])

getSamplesR :: Handler Html
getSamplesR = do
   defaultLayout $(whamletFile "templates/samples.hamlet")
   samples <- runDB $ selectList [] [Asc SamplesVessel]
   -- We'll need the two "objects": articleWidget and enctype
   -- to construct the form (see temlates/articles.hamlet)
   defaultLayout $ do
      $(widgetFile "samples")

putUpdateSampleR :: Text -> Handler Value
putUpdateSampleR = undefined
