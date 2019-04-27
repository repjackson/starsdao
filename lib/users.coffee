if Meteor.isClient
    Router.route '/users', -> @render 'users'


    Template.users.onCreated ->
        @autorun -> Meteor.subscribe('users')


    Template.users.helpers
        users: -> Meteor.users.find()

    Template.users.events
        # 'click #add_user': ->
        #     id = Docs.insert model:'person'
        #     Router.go "/person/edit/#{id}"


if Meteor.isServer
    Meteor.publish 'users', ->
        Meteor.users.find()
