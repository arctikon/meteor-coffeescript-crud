Meteor = require('meteor/meteor').Meteor
Template = require('meteor/templating').Template
$ = require('meteor/jquery').$
FlowRouter =  require('meteor/kadira:flow-router').FlowRouter
Session = require('meteor/session').Session
Purchases = require('../../api/purchases/purchases.coffee').Purchases
Buyers = require('../../api/buyers/buyers.coffee').Buyers

require('./app-purchases.html')
require('../modals/purchases/purchaseModal.coffee')
require('../modals/purchases/purchaseEditModal.coffee')
require('../modals/purchases/purchaseDeleteModal.coffee')


Template.App_purchases.onCreated ->
  if !Meteor.userId()
    FlowRouter.go '/'
  @subscribe 'purchases.list', {userId: Meteor.userId()}
  @subscribe 'buyers.list', {userId: Meteor.userId()}
  Session.set 'appPurchases',
    showDeleteButton: false
  return


Template.App_purchases.helpers 
  purchases: ->
    elems =  Purchases.find({userId: Meteor.userId()}).fetch()
    #console.log elems
    elems.forEach((item)->
      item.buyerObj = Buyers.findOne({_id: item.buyerId})
    );
    elems
  showDeleteButton: ->
    Session.get('appPurchases').showDeleteButton
  

Template.App_purchases.events
  'click ._purchaseModalShow': (e) ->
    purchaseModalStorage = isDisabled: false
    Session.set 'purchaseModalStorage', purchaseModalStorage
    $('#purchaseModal').modal 'show'
    return
  'click ._purchaseDelete': (e) ->
    $('#purchaseDeleteModal').modal 'show'
    purchaseDeleteModalStorage = _id: e.currentTarget.attributes['data-id'].value
    Session.set 'purchaseDeleteModalStorage', purchaseDeleteModalStorage
    return
  'click ._purchaseDeleteAll': (e) ->
    checkedPurch = $('#purchContainer input:checked').toArray()
    checkedPurch.forEach((item)->
      Meteor.call 'purchases.remove', id: item.attributes['data-id'].value
    );
    Session.set('appPurchases', {showDeleteButton: false})
    return
  'click .deletePurchases': (e) ->
    checkedPurch = $('#purchContainer input:checked').toArray()
    if checkedPurch.length > 0 then Session.set('appPurchases', {showDeleteButton: true}) else Session.set('appPurchases', {showDeleteButton: false})
    return
  'click ._purchaseEdit': (e) ->
    purchaseEditModalStorage = 
      _id: e.currentTarget.attributes['data-id'].value
      name: e.currentTarget.attributes['data-name'].value
      price: if e.currentTarget.attributes['data-price'] then e.currentTarget.attributes['data-price'].value else ''
      buyerId: e.currentTarget.attributes['data-buyer-id'].value
    Session.set 'purchaseEditModalStorage', purchaseEditModalStorage
    $('#purchaseEditModal').modal 'show'
    return


