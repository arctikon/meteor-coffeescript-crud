Template = require('meteor/templating').Template
$ = require('meteor/jquery').$
Session = require('meteor/session').Session

require('./buyerModal.html')

Template.buyerModal.onCreated ->
  Session.set 'buyerModalStorage',
    category: ''
    warnMessage: ''
    isDisabled: false
  return

Template.buyerModal.helpers
  categoryName: ->
    Session.get('buyerModalStorage').category
  warnMessage: ->
    Session.get('buyerModalStorage').warnMessage

Template.buyerModal.events
  'change ._addCategory': (event, context) ->
    storage = Session.get('buyerModalStorage')
    storage.category = event.target.value
    Session.set 'buyerModalStorage', storage
    return
  'click ._chooseCategory': (event, context) ->
    storage = Session.get('buyerModalStorage')
    storage.category = event.currentTarget.textContent
    Session.set 'buyerModalStorage', storage
    return
  'click .closeMemoryModal': (event) ->
    $('.buyer-form').trigger 'reset'
    Session.set 'buyerModalStorage',
      category: ''
    return
  'submit .buyer-form': (event) ->
    event.preventDefault()
    storage = Session.get('buyerModalStorage')
    target = event.target
    name = target.name.value
    phone = target.phone.value
    email = target.email.value
    if !name
      storage.warnMessage = 'You must fill the name'
      Session.set 'buyerModalStorage', storage
      return

    if phone
      if !/^\d+$/.test phone
        storage.warnMessage = 'You must fill phone number correctly (only digits)'
        Session.set 'buyerModalStorage', storage
        return
    
    if email
      if !/[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/.test email
        storage.warnMessage = 'You must fill email correctly'
        Session.set 'buyerModalStorage', storage
        return

    Meteor.call 'buyers.insert',
      name: name
      phone: phone
      email: email
      userId: Meteor.userId()
    $('.buyer-form').trigger 'reset'
    Session.set 'buyerModalStorage',
      category: ''
      isDisabled: false
    $('#buyerModal').modal 'hide'
    return
