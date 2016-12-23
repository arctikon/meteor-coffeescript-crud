Meteor = require('meteor/meteor').Meteor
ValidatedMethod = require('meteor/mdg:validated-method').ValidatedMethod
SimpleSchema = require('meteor/aldeed:simple-schema').SimpleSchema
DDPRateLimiter = require('meteor/ddp-rate-limiter').DDPRateLimiter
_ =  require('meteor/underscore')._
Buyers = require('./buyers.coffee').Buyers


buyersInsert = new ValidatedMethod(
  name: 'buyers.insert'
  validate: new SimpleSchema(
    name: type: String
    phone: type: String
    email: type: String
    userId: type: String).validator()
  run: (args) ->
    Buyers.insert
      name: args.name
      phone: args.phone
      email: args.email
      userId: args.userId
)


buyersUpdate = new ValidatedMethod(
  name: 'buyers.update'
  validate: new SimpleSchema(
    id: Buyers.simpleSchema().schema('_id')
    name: Buyers.simpleSchema().schema('name')
    phone: Buyers.simpleSchema().schema('phone')
    email: Buyers.simpleSchema().schema('email')).validator(
    clean: true
    filter: false)
  run: (args) ->
    Buyers.update args.id, $set:
      name: args.name
      phone: args.phone
      email: args.email
)


buyersRemove = new ValidatedMethod(
  name: 'buyers.remove'
  validate: null
  run: (args) ->
    Buyers.remove args.id
)

module.exports = { buyersInsert, buyersUpdate, buyersRemove}