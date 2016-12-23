Template = require('meteor/templating').Template
Session = require('meteor/session').Session
require('./purchaseDeleteModal.html')

Template.purchaseDeleteModal.events 'click .removeBuyer': (event) ->
  id = Session.get('purchaseDeleteModalStorage')._id
  Meteor.call 'purchases.remove', id: id
  Session.clear 'purchaseDeleteModalStorage'
  $('#purchaseDeleteModal').modal 'hide'
  return
