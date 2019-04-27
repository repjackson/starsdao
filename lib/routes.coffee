Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'
    loadingTemplate: 'splash'
    trackPageView: true

force_loggedin =  ()->
    if !Meteor.userId()
        @render 'login'
    else
        @next()

Router.onBeforeAction(force_loggedin, {
  # only: ['admin']
  except: ['register', 'forgot_password','reset_password']
});

Router.route '/reset_password/:token', -> @render 'reset_password'

Router.route '/verify-email/:token', ->
    # onBeforeAction: ->
    console.log @
    # Session.set('_resetPasswordToken', this.params.token)
    # @subscribe('enrolledUser', this.params.token).wait()
    console.log @params
    Accounts.verifyEmail(@params.token, (err) =>
        if err
            console.log err
            alert err
        else
            Router.go '/dashboard'
    )


Router.route '/chat', -> @render 'view_chats'
Router.route '/inbox', -> @render 'inbox'
Router.route '/register', -> @render 'register'
Router.route '/admin', -> @render 'admin'

Router.route('enroll', {
    path: '/enroll-account/:token'
    template: 'reset_password'
    onBeforeAction: ()=>
        Meteor.logout()
        Session.set('_resetPasswordToken', this.params.token)
        @subscribe('enrolledUser', this.params.token).wait()
})
Router.route '/m/:model_slug', -> @render 'delta'
Router.route '/m/:model_slug/:doc_id/edit', -> @render 'model_doc_edit'
Router.route '/m/:model_slug/:doc_id/view', -> @render 'model_doc_view'
Router.route '/model/edit/:doc_id', -> @render 'model_edit'

# Router.route '/user/:username', -> @render 'user'
Router.route '/edit/:doc_id', -> @render 'edit'
Router.route '/view/:doc_id', -> @render 'view'
Router.route '*', -> @render 'not_found'

# Router.route '/user/:username/m/:type', -> @render 'profile_layout', 'user_section'
Router.route '/add_resident', (->
    @layout 'layout'
    @render 'add_resident'
    ), name:'add_resident'
Router.route '/user/:username', -> @render 'profile'
Router.route '/forgot_password', -> @render 'forgot_password'

Router.route '/checkin', -> @render 'goldrun'
Router.route '/user/:username/edit', -> @render 'user_edit'
Router.route '/p/:slug', -> @render 'page'
Router.route '/settings', -> @render 'settings'
# Router.route '/users', -> @render 'people'
Router.route '/sign_waiver/:receipt_id', -> @render 'sign_waiver'

Router.route '/login', -> @render 'login'

Router.route '/', -> @redirect '/m/model'
    #
    # @layout 'layout'
    # @render 'home'
    # ), name:'home'
