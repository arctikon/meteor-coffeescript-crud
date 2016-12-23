Template = require('meteor/templating').Template
$ = require('meteor/jquery').$
Session = require('meteor/session').Session
Buyers = require('../../../api/buyers/buyers.coffee').Buyers
Meteor = require('meteor/meteor').Meteor

require('./purchaseModal.html')

Template.purchaseModal.onCreated ->
  @subscribe 'buyers.list', {userId: Meteor.userId()}
  Session.set 'purchaseModalStorage',
    buyerId: ''
    choosedBuyer: ''
    warnMessage: ''
    isDisabled: false
  return

Template.purchaseModal.helpers
  isDisabledButton: ->
    if Session.get('purchaseModalStorage').isDisabled then disabled: 'disabled' else {}
  isDisabled: ->
    Session.get('purchaseModalStorage').isDisabled
  choosedBuyer: ->
    if Session.get('purchaseModalStorage').choosedBuyer then Session.get('purchaseModalStorage').choosedBuyer else 'Choose Buyer'
  buyers: ->
    Buyers.find({userId: Meteor.userId()})
  warnMessage: ->
    Session.get('purchaseModalStorage').warnMessage

Template.purchaseModal.events
  'click ._chooseBuyer': (e, context) ->
    storage = Session.get('purchaseModalStorage')
    storage.buyerId = e.currentTarget.attributes['data-id'].value
    storage.choosedBuyer = e.currentTarget.attributes['data-name'].value
    Session.set 'purchaseModalStorage', storage
    return
  'click .closePurchaseModal': (event) ->
    $('.purchase-form').trigger 'reset'
    Session.set 'purchaseModalStorage',
      buyerId: ''
      isDisabled: false
    return
  'submit .purchase-form': (event) ->
    event.preventDefault()
    target = event.target
    name = target.name.value
    price = target.price.value
    storage = Session.get('purchaseModalStorage')
    buyerId = storage.buyerId
    
    if !name
      storage.warnMessage = 'You must fill the name'
      Session.set 'purchaseModalStorage', storage
      return

    if price
      if !/^\d+$/.test price
        storage.warnMessage = 'You must fill price number correctly (only digits)'
        Session.set 'purchaseModalStorage', storage
        return

    if !buyerId
      storage.warnMessage = 'You must attach buyer'
      Session.set 'purchaseModalStorage', storage
      return

    Meteor.call 'purchases.insert',
      name: name
      price: parseInt(price)
      userId: Meteor.userId()
      buyerId: buyerId
    $('.purchase-form').trigger 'reset'
    Session.set 'purchaseModalStorage',
      buyerId: ''
      choosedBuyer: ''
      isDisabled: false
    $('#purchaseModal').modal 'hide'
    return
