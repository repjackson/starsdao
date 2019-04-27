if Meteor.isClient
    Template.profile.onCreated ->
        @autorun -> Meteor.subscribe 'user_from_username', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_models', Router.current().params.username

    Template.user_section.helpers
        user_section_template: ->
            "user_#{Router.current().params.group}"

    Template.profile.helpers
        user: ->
            Meteor.users.findOne username:Router.current().params.username

        user_models: ->
            user = Meteor.users.findOne username:Router.current().params.username
            Docs.find
                model:'model'
                _id:$in:user.model_ids

        banner_style: ->
            console.log @
            # {
            #     background: url(/image/signup-bg.png) center no-repeat;
            #     /*height: 100%;*/
            #     width: 100%;
            #     height: 100vh;
            #     background-repeat: no-repeat;
            #     background-position: center center;
            #     background-size: cover;
            #     background-attachment: fixed;
            #     position: relative;
            # }




    Template.profile.events
        'click .set_delta_model': ->
            console.log @
            Meteor.call 'set_delta_facets', @slug, null, true

        'click .logout': ->
            Meteor.logout()
            Router.go '/login'


    Template.user_array_element_toggle.helpers
        user_array_element_toggle_class: ->
            # user = Meteor.users.findOne Router.current().params.username
            if @user["#{@key}"] and @value in @user["#{@key}"] then 'blue' else 'basic'


    Template.user_array_element_toggle.events
        'click .toggle_element': (e,t)->
            # console.log @
            # user = Meteor.users.findOne Router.current().params.username
            if @user["#{@key}"]
                if @value in @user["#{@key}"]
                    Meteor.users.update @user._id,
                        $pull: "#{@key}":@value
                else
                    Meteor.users.update @user._id,
                        $addToSet: "#{@key}":@value
            else
                Meteor.users.update @user._id,
                    $addToSet: "#{@key}":@value


    Template.user_array_list.helpers
        users: ->
            users = []
            if @user["#{@array}"]
                for user_id in @user["#{@array}"]
                    user = Meteor.users.findOne user_id
                    users.push user
                users



    Template.user_array_list.onCreated ->
        @autorun => Meteor.subscribe 'user_array_list', @data.user, @data.array

    Template.user_array_list.helpers
        users: ->
            users = []
            if @user["#{@array}"]
                for user_id in @user["#{@array}"]
                    user = Meteor.users.findOne user_id
                    users.push user
                users




    # Template.user_connections.onCreated ->
    #     @autorun => Meteor.subscribe 'all_users', Router.current().params.username
    #
    # Template.user_connections.helpers
    #     connections: ->
    #         Meteor.users.find {}
    #
    # Template.user_connections.events
    #     'keyup .assign_task': (e,t)->
    #         if e.which is 13
    #             post = t.$('.assign_task').val().trim()
    #             console.log post
    #             current_user = Meteor.users.findOne username:Router.current().params.username
    #             Docs.insert
    #                 body:post
    #                 model:'task'
    #                 assigned_user_id:current_user._id
    #                 assigned_username:current_user.username
    #
    #             t.$('.assign_task').val('')



    Template.user_wall.onCreated ->
        @autorun => Meteor.subscribe 'wall_posts', Router.current().params.username
    Template.user_wall.helpers
        wall_posts: ->
            Docs.find
                model:'wall_post'

    Template.user_wall.events
        'keyup .new_post': (e,t)->
            if e.which is 13
                post = t.$('.new_post').val().trim()
                Docs.insert
                    body:post
                    model:'wall_post'
                t.$('.new_post').val('')


        'click .remove_comment': ->
            if confirm 'Remove Comment?'
                Docs.remove @_id

        'click .vote_up_comment': ->
            if @upvoters and Meteor.userId() in @upvoters
                Docs.update @_id,
                    $inc:points:1
                    $addToSet:upvoters:Meteor.userId()
                Meteor.users.update @author_id,
                    $inc:points:-1
            else
                Meteor.users.update @author_id,
                    $pull:upvoters:Meteor.userId()
                    $inc:points:1
                Meteor.users.update @author_id,
                    $inc:points:1

        'click .mark_comment_read': ->
            Docs.update @_id,
                $addToSet:readers:Meteor.userId()



    Template.violations.onCreated ->
        @autorun => Meteor.subscribe 'violations', Router.current().params.username

    Template.violations.helpers
        violations: ->
            Docs.find
                model:'violation'



if Meteor.isServer
    Meteor.publish 'wall_posts', (username)->
        console.log username
        Docs.find
            model:'wall_post'
            # parent_username:username

    Meteor.publish 'violations', (username)->
        # console.log 'violation', username
        Docs.find
            model:'violation'
            # parent_username:username
