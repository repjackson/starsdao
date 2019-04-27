if Meteor.isClient
    Template.comments.onCreated ->
        @autorun => Meteor.subscribe 'children', 'comment', Router.current().params.doc_id


    Template.role_editor.onCreated ->
        @autorun => Meteor.subscribe 'model', 'role'

    Template.comments.helpers
        doc_comments: ->
            Docs.find
                parent_id:Router.current().params.doc_id
                model:'comment'

    Template.comments.events
        'keyup .add_comment': (e,t)->
            if e.which is 13
                # parent = Docs.findOne Router.current().params.doc_id
                comment = t.$('.add_comment').val()
                console.log comment
                Docs.insert
                    parent_id: Router.current().params.doc_id
                    model:'comment'
                    body:comment
                t.$('.add_comment').val('')

        'click .remove_comment': ->
            if confirm 'Confirm remove comment'
                Docs.remove @_id

    Template.user_card.onCreated ->
        @autorun => Meteor.subscribe 'user_from_username', @data
    Template.user_card.helpers
        user: -> Meteor.users.findOne username:@data



    Template.big_user_card.onCreated ->
        @autorun => Meteor.subscribe 'user_from_username', @data
    Template.big_user_card.helpers
        user: -> Meteor.users.findOne username:@valueOf()








    Template.user_info.onCreated ->
        # console.log @data
        @autorun => Meteor.subscribe 'user_from_id', @data

    Template.user_info.helpers
        user: ->
            # console.log @
            Meteor.users.findOne @valueOf()


    Template.toggle_edit.events
        'click .toggle_edit': ->
            console.log @
            console.log Template.currentData()
            console.log Template.parentData()
            console.log Template.parentData(1)
            console.log Template.parentData(2)
            console.log Template.parentData(3)
            console.log Template.parentData(4)





    Template.user_list_info.onCreated ->
        @autorun => Meteor.subscribe 'user', @data

    Template.user_list_info.helpers
        user: ->
            console.log @
            Meteor.users.findOne @valueOf()



    Template.follow.helpers
        followers: ->
            Meteor.users.find
                _id: $in: @follower_ids

        following: -> @follower_ids and Meteor.userId() in @follower_ids


    Template.follow.events
        'click .follow': ->
            Docs.update @_id,
                $addToSet:follower_ids:Meteor.userId()

        'click .unfollow': ->
            Docs.update @_id,
                $pull:follower_ids:Meteor.userId()




    Template.user_field.helpers
        key_value: ->
            user = Meteor.users.findOne Router.current().params.doc_id
            user["#{@key}"]

    Template.user_field.events
        'blur .user_field': (e,t)->
            value = t.$('.user_field').val()
            Meteor.users.update Router.current().params.doc_id,
                $set:"#{@key}":value





    Template.user_list_toggle.onCreated ->
        @autorun => Meteor.subscribe 'user_list', Template.parentData(),@key

    Template.user_list_toggle.events
        'click .toggle': (e,t)->
            parent = Template.parentData()
            if parent["#{@key}"] and Meteor.userId() in parent["#{@key}"]
                Docs.update parent._id,
                    $pull:"#{@key}":Meteor.userId()
            else
                Docs.update parent._id,
                    $addToSet:"#{@key}":Meteor.userId()


    Template.user_list_toggle.helpers
        user_list_toggle_class: ->
            if Meteor.user()
                parent = Template.parentData()
                'basic'
            else
                'disabled'

        in_list: ->
            parent = Template.parentData()
            if parent["#{@key}"] and Meteor.userId() in parent["#{@key}"] then true else false

        list_users: ->
            parent = Template.parentData()
            Meteor.users.find _id:$in:parent["#{@key}"]




    Template.voting.helpers
        upvote_class: -> if @upvoter_ids and Meteor.userId() in @upvoter_ids then 'green' else 'outline'
        downvote_class: -> if @downvoter_ids and Meteor.userId() in @downvoter_ids then 'red' else 'outline'




    Template.voting.events
        'click .upvote': ->
            if @downvoter_ids and Meteor.userId() in @downvoter_ids
                Docs.update @_id,
                    $pull: downvoter_ids:Meteor.userId()
                    $addToSet: upvoter_ids:Meteor.userId()
                    $inc:points:2
            else if @upvoter_ids and Meteor.userId() in @upvoter_ids
                Docs.update @_id,
                    $pull: upvoter_ids:Meteor.userId()
                    $inc:points:-1
            else
                Docs.update @_id,
                    $addToSet: upvoter_ids:Meteor.userId()
                    $inc:points:1
            # Meteor.users.update @_author_id,
            #     $inc:karma:1

        'click .downvote': ->
            if @upvoter_ids and Meteor.userId() in @upvoter_ids
                Docs.update @_id,
                    $pull: upvoter_ids:Meteor.userId()
                    $addToSet: downvoter_ids:Meteor.userId()
                    $inc:points:-2
            else if @downvoter_ids and Meteor.userId() in @downvoter_ids
                Docs.update @_id,
                    $pull: downvoter_ids:Meteor.userId()
                    $inc:points:1
            else
                Docs.update @_id,
                    $addToSet: downvoter_ids:Meteor.userId()
                    $inc:points:-1
            # Meteor.users.update @_author_id,
            #     $inc:karma:-1





    Template.add_button.events
        'click .add': ->
            Docs.insert
                model: @model


    Template.remove_button.events
        'click .remove': (e,t)->
            if confirm "Remove #{@model}?"
                $(e.currentTarget).closest('.segment').transition('fly right')
                Meteor.setTimeout =>
                    Docs.remove @_id
                , 1000


    Template.add_model_button.events
        'click .add': ->
            new_id = Docs.insert model: @model
            Router.go "/edit/#{new_id}"

    Template.view_user_button.events
        'click .view_user': ->
            Router.go "/user/#{username}"


if Meteor.isServer
    Meteor.publish 'children', (model, parent_id)->
        console.log model
        console.log parent_id
        Docs.find {
            model:model
            # parent_id:parent_id
        }, limit:10
