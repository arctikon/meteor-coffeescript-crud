Meteor = require('meteor/meteor').Meteor
Template = require('meteor/templating').Template
$ = require('meteor/jquery').$

require('./app-body.html')
require('../pages/login.html')


Accounts.onLogin ->
  $('#signin_modal').modal 'hide'
  return



Template.App_body.events
  'click .__signin': ->
    $('#signin_modal').modal 'show'
    return
  'click .__logout': ->
    Meteor.logout (err) ->
      $('#signin_modal').modal 'hide'
      return
    return
  'click .js-logout': ->
    Meteor.logout()
    return
