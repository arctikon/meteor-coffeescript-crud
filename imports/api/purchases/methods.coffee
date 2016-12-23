Meteor = require('meteor/meteor').Meteor
Mongo = require('meteor/mongo').Mongo
ValidatedMethod = require('meteor/mdg:validated-method').ValidatedMethod
SimpleSchema = require('meteor/aldeed:simple-schema').SimpleSchema
DDPRateLimiter = require('meteor/ddp-rate-limiter').DDPRateLimiter
_ =  require('meteor/underscore')._
Purchases = require('./purchases.coffee').Purchases


insert = new ValidatedMethod(
  name: 'purchases.insert'
  validate: new SimpleSchema(
    name: type: String
    price: type: Number
    buyerId: type: String
    userId: type: String).validator()
  run: (args) ->
    Purchases.insert
      name: args.name
      price: args.price
      buyerId: args.buyerId
      userId: args.userId
)


update = new ValidatedMethod(
  name: 'purchases.update'
  validate: new SimpleSchema(
    id: Purchases.simpleSchema().schema('_id')
    name: Purchases.simpleSchema().schema('name')
    price: Purchases.simpleSchema().schema('price')
    buyerId: Purchases.simpleSchema().schema('buyerId')).validator(
    clean: true
    filter: false)
  run: (args) ->
    Purchases.update args.id, $set:
      name: args.name
      price: args.price
      buyerId: args.buyerId
)


remove = new ValidatedMethod(
  name: 'purchases.remove'
  validate: null
  run: (args) ->
    Purchases.remove args.id
)

module.exports = { insert, update, remove}