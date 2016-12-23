Meteor = require('meteor/meteor').Meteor
Template = require('meteor/templating').Template
$ = require('meteor/jquery').$
FlowRouter =  require('meteor/kadira:flow-router').FlowRouter
Session = require('meteor/session').Session
Buyers = require('../../api/buyers/buyers.coffee').Buyers

require('./app-buyers.html')
require('../modals/buyers/buyerModal.coffee')
require('../modals/buyers/buyerEditModal.coffee')
require('../modals/buyers/buyerDeleteModal.coffee')


Template.App_buyers.onCreated ->
  if !Meteor.userId()
    FlowRouter.go '/'

  @subscribe 'buyers.list', {userId: Meteor.userId()}
  Session.set 'appBuyers',
    showDeleteButton: false
  return


Template.App_buyers.helpers 
  buyers: ->
    Buyers.find({userId: Meteor.userId()})
  showDeleteButton: ->
    Session.get('appBuyers').showDeleteButton


Template.App_buyers.events
  'click ._buyerModalShow': (e) ->
    buyerModalStorage = isDisabled: false
    Session.set 'buyerModalStorage', buyerModalStorage
    $('#buyerModal').modal 'show'
    return
  'click ._buyerDelete': (e) ->
    $('#buyerDeleteModal').modal 'show'
    buyerDeleteModalStorage = _id: e.currentTarget.attributes['data-id'].value
    Session.set 'buyerDeleteModalStorage', buyerDeleteModalStorage
    return
  'click ._buyerDeleteAll': (e) ->
    checkedBuyers = $('#buyerContainer input:checked').toArray()
    checkedBuyers.forEach((item)->
      Meteor.call 'buyers.remove', id: item.attributes['data-id'].value
    );
    Session.set('appBuyers', {showDeleteButton: false})
    return
  'click .deleteBuyers': (e) ->
    checkedBuyers = $('#buyerContainer input:checked').toArray()
    if checkedBuyers.length > 0 then Session.set('appBuyers', {showDeleteButton: true}) else Session.set('appBuyers', {showDeleteButton: false})
    return
  'click ._buyerEdit': (e) ->
    buyerEditModalStorage = 
      _id: e.currentTarget.attributes['data-id'].value
      name: e.currentTarget.attributes['data-name'].value
      phone: if e.currentTarget.attributes['data-phone'] then e.currentTarget.attributes['data-phone'].value else ''
      email: if e.currentTarget.attributes['data-email'] then e.currentTarget.attributes['data-email'].value else ''
    Session.set 'buyerEditModalStorage', buyerEditModalStorage
    $('#buyerEditModal').modal 'show'
    return


