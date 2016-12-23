Template = require('meteor/templating').Template
$ = require('meteor/jquery').$
Session = require('meteor/session').Session
Buyers = require('../../../api/buyers/buyers.coffee').Buyers
Meteor = require('meteor/meteor').Meteor

require('./purchaseEditModal.html')


Template.purchaseEditModal.onCreated ->
  @subscribe 'purchases.list', {userId: Meteor.userId()}

  Session.set 'purchaseEditModalStorage',
    name: ''
    price: ''
    warnMessage: ''
    buyerId: ''
  return


Template.purchaseEditModal.helpers
  name: ->
    Session.get('purchaseEditModalStorage').name
  price: ->
    Session.get('purchaseEditModalStorage').price
  choosedBuyer: ->
    if Session.get('purchaseEditModalStorage').buyerId then Buyers.findOne({_id: Session.get('purchaseEditModalStorage').buyerId}).name else ''
  buyers: ->
    Buyers.find({userId: Meteor.userId()})
  warnMessage: ->
    Session.get('purchaseEditModalStorage').warnMessage


Template.purchaseEditModal.events
  'click ._chooseBuyer': (e, context) ->
    storage = Session.get('purchaseEditModalStorage')
    storage.buyerId = e.currentTarget.attributes['data-id'].value
    storage.choosedBuyer = e.currentTarget.attributes['data-name'].value
    Session.set 'purchaseEditModalStorage', storage
  'submit .purchase-edit-form': (event) ->
    event.preventDefault()
    target = event.target
    name = target.name.value
    price = target.price.value
    storage = Session.get('purchaseEditModalStorage')
    buyerId = storage.buyerId

    if !name
      storage.warnMessage = 'You must fill the name'
      Session.set 'purchaseEditModalStorage', storage
      return

    if price
      if !/^\d+$/.test price
        storage.warnMessage = 'You must fill price number correctly (only digits)'
        Session.set 'purchaseEditModalStorage', storage
        return

    if !buyerId
      storage.warnMessage = 'You must attach buyer'
      Session.set 'purchaseEditModalStorage', storage
      return

    Meteor.call 'purchases.update',
      id: Session.get('purchaseEditModalStorage')._id
      name: name
      price: parseInt(price)
      buyerId: buyerId
    $('#purchaseEditModal').modal 'hide'
    return

