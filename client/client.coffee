@selected_tags = new ReactiveArray []

$.cloudinary.config
    cloud_name:"facet"
# Router.notFound =
    # action: 'not_found'


Session.setDefault 'invert', false
Template.registerHelper 'dark_side', () -> Session.equals('invert',true)
Template.registerHelper 'invert_class', () -> if Session.equals('invert',true) then 'invert' else ''
Template.registerHelper 'is_loading', () -> Session.get 'loading'
Template.registerHelper 'dev', () -> Meteor.isDevelopment
Template.registerHelper 'is_author', () -> @_author_id is Meteor.userId()
Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()
Template.registerHelper 'long_date', (input) -> moment(input).format("dddd, MMMM Do h:mm:ss a")
Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()
Template.registerHelper 'from_now', (input) -> moment(input).fromNow()
Template.registerHelper 'logging_out', () -> Session.get 'logging_out'



Template.registerHelper 'is_text', () ->
    console.log @field_type
    @field_type is 'text'

Template.registerHelper 'fields', () ->
    model = Docs.findOne
        model:'model'
        slug:Router.current().params.model_slug
    if model
        Docs.find {
            model:'field'
            parent_id:model._id
            # view_roles:$in:Meteor.user().roles
        }, sort:rank:1

Template.registerHelper 'current_user', (input) ->
    Meteor.user() and Meteor.user().username is Router.current().params.username


Template.registerHelper 'user_is_client', (input) ->
    user = Meteor.users.findOne username:Router.current().params.username
    if user and user.roles and 'client' in user.roles then true else false

Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)


Template.registerHelper 'loading_class', () ->
    if Session.get 'loading' then 'disabled' else ''

Template.registerHelper 'current_model', (input) ->
    Docs.findOne
        model:'model'
        slug: Router.current().params.model_slug

Template.registerHelper 'in_list', (key) ->
    if Meteor.userId()
        if Meteor.userId() in @["#{key}"] then true else false


Template.registerHelper 'is_admin', () ->
    if Meteor.user() and Meteor.user().roles
        # if _.intersection(['dev','admin'], Meteor.user().roles) then true else false
        if 'admin' in Meteor.user().roles then true else false

Template.registerHelper 'is_dev', () ->
    if Meteor.user() and Meteor.user().roles
        if 'dev' in Meteor.user().roles then true else false


Template.registerHelper 'view_template', ->
    # console.log @
    "#{@field_type}_view"

Template.registerHelper 'edit_template', ->
    "#{@field_type}_edit"

Template.registerHelper 'is_model', -> @model is 'model'




# Template.body.events
#     'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')

Template.registerHelper 'is_editing', () ->
    # console.log 'this', @
    Session.equals 'editing_id', @_id


Template.registerHelper 'can_edit', () ->
    Meteor.userId() is @_author_id or 'admin' in Meteor.user().roles

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()

Template.registerHelper 'current_doc', ->
    doc = Docs.findOne Router.current().params.doc_id
    user = Meteor.users.findOne Router.current().params.doc_id
    # console.log doc
    # console.log user
    if doc then doc else if user then user


Template.registerHelper 'user_from_username_param', () ->
    found = Meteor.users.findOne username:Router.current().params.username
    # console.log found
    found
Template.registerHelper 'field_value', () ->
    # console.log @
    parent = Template.parentData()
    parent2 = Template.parentData(2)
    parent3 = Template.parentData(3)
    parent4 = Template.parentData(4)
    parent5 = Template.parentData(5)
    parent6 = Template.parentData(6)

    # console.log parent
    # console.log parent2
    # console.log parent3
    # console.log parent4
    # console.log parent5
    # console.log parent6

    if @direct
        parent = Template.parentData()
    else
        parent = Template.parentData(5)
    if parent
        parent["#{@key}"]


Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()
Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()
Template.registerHelper 'in_dev', () -> Meteor.isDevelopment

Template.registerHelper 'calculated_size', (metric) ->
    # console.log metric
    # console.log typeof parseFloat(@relevance)
    # console.log typeof (@relevance*100).toFixed()
    whole = parseInt(@["#{metric}"]*10)
    # console.log whole

    if whole is 2 then 'f2'
    else if whole is 3 then 'f3'
    else if whole is 4 then 'f4'
    else if whole is 5 then 'f5'
    else if whole is 6 then 'f6'
    else if whole is 7 then 'f7'
    else if whole is 8 then 'f8'
    else if whole is 9 then 'f9'
    else if whole is 10 then 'f10'


Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()

Template.registerHelper 'in_dev', () -> Meteor.isDevelopment
