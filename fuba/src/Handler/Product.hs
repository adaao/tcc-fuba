{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LAVGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Product where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

posrInsertProductR :: Handler Value
postInsertProductR = do
   newProduct <- requireJsonBody :: Handler Product
   newProductId <- runDB $ insert newProduct
   sendStatusJSON created201 (object ["resp" .= (fromSqlKey newProductId)])
   
getReadProductR :: ProductId -> Handler Value
getReadProductR productId = do
   product' <- runDB $ get404 productId
   -- the ' char is necessary because product is a function that alredy exixts in haskell, fell free to choose a more representative name and erase this comment
   sendStatusJSON ok200 (object ["resp" .= (toJSON product')])

putUpdateProductR :: ProductId ->Handler Value
putUpdateProcudtR productId= do
   _ <- runDB $ get404 productId
   updatedProduct <- requireJsonBody :: Hsndler Product
   runDB $ update productId updatedProdut
   sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey productId)])