if Meteor.isClient
    Router.route '/frontdesk', -> @render 'frontdesk'
    Router.route '/frontdesk/edit/:doc_id', -> @render 'edit_frontdesk'

    Template.frontdesk.onCreated ->
        @autorun -> Meteor.subscribe 'type', 'frontdesk'

    Template.frontdesk.helpers
        frontdesk: ->
            Docs.find
                model: 'frontdesk'



    Template.frontdesk.events
        'click #add_impounded_frontdesk': ->
            id = Docs.insert
                model: 'frontdesk'
            Router.go "/frontdesk/edit/#{id}"
