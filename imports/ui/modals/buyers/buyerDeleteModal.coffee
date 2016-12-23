Template = require('meteor/templating').Template
Session = require('meteor/session').Session
require('./buyerDeleteModal.html')

Template.buyerDeleteModal.events 'click .removeBuyer': (event) ->
  id = Session.get('buyerDeleteModalStorage')._id
  Meteor.call 'buyers.remove', id: id
  Session.clear 'buyerDeleteModalStorage'
  $('#buyerDeleteModal').modal 'hide'
  return
