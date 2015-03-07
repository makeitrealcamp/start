# a timer to save files periodically
class Timer
  constructor: (@event, @timeout) ->

  start: =>
    @timer = setTimeout (=>
      Dispatcher.trigger(@event)), @timeout
    @

  cancel: =>
    clearTimeout(@timer) if @timer?
    @

# a view to handle the instructions configuration and events
class InstructionsView extends Backbone.View
  el: '.instructions'

  initialize: ->
    @.$('a').filter( ->
      return this.hostname != window.location.hostname;
    ).attr('target', '_blank')

  events:
    'click img': 'display_images'

  display_images: ->
    img = $(@).clone()
    $('.modal-body').empty()
    $('.modal-dialog').width(@.naturalWidth)
    $('.modal-body').append(img)
    $('#zoom-modal').modal({show:true})

# a view to handle solution configuration and events
class SolutionView extends Backbone.View
  el: '.solution'

  initialize: ->
    @files_changed = false;

    Dispatcher.on("timer:save-files", @save_files_handler)
    Dispatcher.on("editors:change", =>
      $('.btn-preview').addClass('disabled');
      @files_changed = true;
    )

    # start the timeout
    save_files_timer.start()

    # persist documents on this events
    $(document).on("page:before-change", @save_files_handler)

  events: ->
    'click .btn-preview': 'preview'

  preview: (e) =>
    file = @find_html_file()
    if !file
      alert("No se puede ver la solución, no existe un archivo HTML")
      return false

    solution_id = @.$('.editors').data("solution-id")
    $(e.currentTarget).attr("href", '/solutions/' + solution_id + '/preview/' + file.html())

  find_html_file: =>
    index = @.$(".nav-tabs a[data-toggle='tab'] .name:contains('index.html')")
    file_active = @.$('.nav-tabs .active .name:contains(".html")')
    file_html = @.$(".nav-tabs a[data-toggle='tab'] .name:contains('.html')")

    return @.$('.nav-tabs .active .name') if file_active.length > 0
    return index if index.length > 0
    return file_html.first() if file_html.length > 0

    return false

  save_files_handler: =>
    if @files_changed and not @saving_files and @.$('.editors').length and @.$('.editor-content').length
      @save_files()
    else
      save_files_timer.start()

  save_files: =>
    console.log("saving " + $('.editor-content').length + " files ... ")
    @saving_files = true
    
    data = @get_editors_data()
    @files_changed = false
    solution_id = $('.editors').data("solution-id")
    $.ajax(
      type: "PUT"
      url: "/solutions/" + solution_id + "/update_documents"
      contentType: "application/json"
      data: JSON.stringify(data)
    ).done( =>
      $('.btn-preview').removeClass("disabled");
    ).fail( ->
      console.log("No se pudo guardar los archivos ...")
    ).always( =>
      @saving_files = false
      save_files_timer.start()
    )

  get_editors_data: ->
    data = {};
    $('.editor-content').each (index) ->
      document_id = $(@).data("id")
      editor = editors.get(document_id)
      data['content-' + document_id] = editor.getValue()
    data

  remove: =>
    super()
    $(document).off("page:before-change")

# a view to handle challenge form (create and update)
class ChallengeFormView extends Backbone.View
  el: 'body'

  initialize: (options) ->
    @editor_index = 0
    @editor_modes = options.editor_modes

    @tab_template = _.template($('#file-tab-template').html())
    @editor_template = _.template($('#editor-template').html())
    @destroy_template = _.template($('#destroy-template').html())

    # configure evaluation editor
    editors.configure  el: 'challenge_evaluation', opts: mode: 'ruby'

  events:
    'click .remove-file-btn': 'remove_file'
    'click #new-file-modal .add-btn': 'add_file'

  add_editor: (id, name, content) ->
    mode = @editor_mode(name)

    # replace the button with the editors panel if this is the first file
    $('.new-file-btn').remove()
    $('.files-wrapper').append($('#files-template').html()) if !$('.files').length

    # remove class active from current editor (if any)
    $('.files .nav-tabs li').removeClass("active")
    $('#editors-panel .tab-pane').removeClass("active")

    # append the editor to the editors panel
    name_prefix = 'challenge[documents_attributes][' + @editor_index + ']'
    data = id: id, index: @editor_index, name: name
    $('.files .nav-tabs .new-file').before(@tab_template(data))
    $('#editors-panel').append(@editor_template(data))

    # configure editor
    editor = editors.configure(el: 'editor-content-' + @editor_index, opts: mode: mode)
    editor.setValue(content)
    @editor_index++

  editor_mode: (name) ->
    ext = /(?:\.([^.]+))?$/.exec(name)[1];
    @editor_modes[ext];

  add_file: ->
    file_name = $('#new-file-modal #file-name').val()
    mode = @editor_mode(file_name)

    # validate input
    if (!mode)
      $('.form-group').addClass("has-error")
      $('#file-name').focus()
      return

    @add_editor(null, file_name, '')

    $('#new-file-modal').modal('hide')

  remove_file: (e) ->
    return if not confirm("¿Estás seguro de eliminar este archivo?")

    # remove the tab and the editor
    li = $(e.currentTarget).closest("li").remove()
    editor_index = li.data("editor-id")
    editor_div = $("#editor-" + editor_index).remove()
    document_id = editor_div.find(".has-id").val()
    editors.remove(editor_index);

    # check if we have to change the active editor, or show the add file button
    if not $('.files li.file-tab').length
      $('.files').replaceWith($('#new-file-btn-template').html())
    else
      if li.hasClass("active")
        first_li = $('.files li.file-tab').first()
        first_li.addClass("active")

        new_editor_index = first_li.data("editor-id")
        $('#editor-' + new_editor_index).addClass("active")

    # add the markup to destroy the file on the server
    if editor_div.find(".has-id").length
      name_prefix = 'challenge[documents_attributes][' + editor_index + ']'
      $('.destroyed').append(@destroy_template(editor_index: editor_index, document_id: document_id))

window.InstructionsView = InstructionsView
window.SolutionView = SolutionView
window.save_files_timer = new Timer("timer:save-files", 1000)

window.ChallengeFormView = ChallengeFormView