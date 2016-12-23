Meteor = require('meteor/meteor').Meteor
DDPRateLimiter = require('meteor/ddp-rate-limiter').DDPRateLimiter
_ =  require('meteor/underscore')._


Meteor.users.deny({
  update: () -> true,
})

AUTH_METHODS = [
  'login',
  'logout',
  'logoutOtherClients',
  'getNewToken',
  'removeOtherTokens',
  'configureLoginService',
  'changePassword',
  'forgotPassword',
  'resetPassword',
  'verifyEmail',
  'createUser',
  'ATRemoveService',
  'ATCreateUserServer',
  'ATResendVerificationEmail',
]

ruleObj =
  name: (name) -> _.contains(AUTH_METHODS, name)
  connectionId: () -> true


DDPRateLimiter.addRule(ruleObj, 2, 5000)

