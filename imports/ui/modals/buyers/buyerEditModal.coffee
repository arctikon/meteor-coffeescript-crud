Template = require('meteor/templating').Template
$ = require('meteor/jquery').$
Session = require('meteor/session').Session

require('./buyerEditModal.html')


Template.buyerEditModal.onCreated ->
  Session.set 'buyerEditModalStorage',
    name: ''
    phone: ''
    email: ''
    warnMessage: ''
  return


Template.buyerEditModal.helpers
  name: ->
    Session.get('buyerEditModalStorage').name
  phone: ->
    Session.get('buyerEditModalStorage').phone
  email: ->
    Session.get('buyerEditModalStorage').email
  warnMessage: ->
    Session.get('buyerEditModalStorage').warnMessage


Template.buyerEditModal.events
  'submit .buyer-edit-form': (event) ->
    event.preventDefault()
    target = event.target
    storage = Session.get('buyerEditModalStorage')
    name = target.name.value
    phone = target.phone.value
    email = target.email.value
  
    if !name
      storage.warnMessage = 'You must fill the name'
      Session.set 'buyerEditModalStorage', storage
      return

    if phone
      if !/^\d+$/.test phone
        storage.warnMessage = 'You must fill phone number correctly (only digits)'
        Session.set 'buyerEditModalStorage', storage
        return
    
    if email
      if !/[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/.test email
        storage.warnMessage = 'You must fill email correctly'
        Session.set 'buyerEditModalStorage', storage
        return

    Meteor.call 'buyers.update',
      id: Session.get('buyerEditModalStorage')._id
      name: name
      phone: phone
      email: email
    $('#buyerEditModal').modal 'hide'
    return

