Mongo = require('meteor/mongo').Mongo
SimpleSchema = require('meteor/aldeed:simple-schema').SimpleSchema


Purchases = new Mongo.Collection 'Purchases'

Purchases.schema = new SimpleSchema(
  _id:
    type: String
    regEx: SimpleSchema.RegEx.Id
  name: type: String
  price: type: Number
  userId:
    type: String
    regEx: SimpleSchema.RegEx.Id
    optional: true
  buyerId:
    type: String
    regEx: SimpleSchema.RegEx.Id
    optional: true)


Purchases.attachSchema Purchases.schema

Purchases.publicFields = 
  _id: 1,
  name: 1,
  userId: 1,
  price: 1,
  buyerId: 1


Purchases.helpers editableBy: (userId) ->
  if !@userId
    return true
  @userId == userId


module.exports = { Purchases }
