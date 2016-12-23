Meteor = require('meteor/meteor').Meteor
Purchases = require('../purchases.coffee').Purchases
Mongo = require('meteor/mongo').Mongo
Buyers = require('../../buyers/buyers.coffee').Buyers



Meteor.publish 'purchases.list', (args)  ->
  check(args, Object)
  purchasesCollection = Purchases.find {userId: args.userId}, fields: Purchases.publicFields
  return purchasesCollection
  


