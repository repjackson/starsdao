if Meteor.isClient
    Template.facet_staff_select.onCreated ->
        @autorun => Meteor.subscribe 'facet_doc', @data.tags
        
    Template.facet_staff_select.helpers
        doc: ->
            tags = Template.currentData().tags
            split_array = tags.split ','

            Docs.findOne
                tags: split_array
    
        template_tags: -> Template.currentData().tags
    
        doc_classes: -> Template.parentData().classes

    Template.facet_staff_select.events
        'click .create_doc': (e,t)->
            tags = t.data.tags
            split_array = tags.split ','
            new_id = Docs.insert
                tags: split_array
            Session.set 'editing_id', new_id

        'blur #staff': ->
            staff = $('#staff').val()
            Docs.update @_id,
                $set: staff: staff