Meteor = require('meteor/meteor').Meteor
Buyers = require('../buyers.coffee').Buyers


Meteor.publish 'buyers.list', (args) ->
  check(args, Object)
  Buyers.find {userId: args.userId}, fields: Buyers.publicFields
  
