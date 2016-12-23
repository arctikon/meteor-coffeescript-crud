Mongo = require('meteor/mongo').Mongo
SimpleSchema = require('meteor/aldeed:simple-schema').SimpleSchema


Buyers = new Mongo.Collection 'Buyers'

Buyers.schema = new SimpleSchema(
  _id:
    type: String
    regEx: SimpleSchema.RegEx.Id
  name: type: String
  email: type: String, optional: true
  phone: type: String, optional: true
  userId:
    type: String
    regEx: SimpleSchema.RegEx.Id
    optional: true)



Buyers.attachSchema Buyers.schema

Buyers.publicFields = 
  _id: 1,
  name: 1,
  userId: 1,
  email: 1,
  phone: 1


Buyers.helpers editableBy: (userId) ->
  if !@userId
    return true
  @userId == userId


module.exports = { Buyers }
