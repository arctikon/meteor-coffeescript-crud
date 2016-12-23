FlowRouter = require('meteor/kadira:flow-router').FlowRouter
BlazeLayout = require('meteor/kadira:blaze-layout').BlazeLayout

require('../../ui/layouts/app-body.coffee')
require('../../ui/pages/app-buyers.coffee')
require('../../ui/pages/app-purchases.coffee')


FlowRouter.route '/',
  name: 'App.home'
  action: ->
    BlazeLayout.render 'App_body', main: 'App_mainpage'
    return

FlowRouter.route '/buyers',
  name: 'App.buyers'
  action: ->
    BlazeLayout.render 'App_body', main: 'App_buyers'
    return

FlowRouter.route '/purchases',
  name: 'App.purchases'
  action: ->
    BlazeLayout.render 'App_body', main: 'App_purchases'
    return

