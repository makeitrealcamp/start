# a timer to save files periodically
class Timer
  constructor: (@event, @timeout) ->

  start: =>
    @timer = setTimeout (=>
      Dispatcher.trigger(@event)
    ), @timeout
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

  display_images: (e) ->
    $img = $(e.currentTarget).clone()
    modal_padding = 30
    modal_width = Math.min(e.currentTarget.naturalWidth+modal_padding,800)
    $('.modal-dialog').width("#{modal_width}px")
    $('.modal-body').empty()
    $('.modal-body').append($img)
    $('#zoom-modal').modal({show:true})

# a view to handle solution configuration and events
class SolutionView extends Backbone.View
  el: '.solution'

  initialize: ->
    @files_changed = false;
    @timer_active = true;

    Dispatcher.on("timer:save-files", @save_files_handler)
    Dispatcher.on("editors:change", =>
      $('.btn-preview').addClass('disabled');
      @files_changed = true;
    )

    # start the timeout
    save_files_timer.start()

    # persist documents on this events
    $(document).on("page:before-change", @save_files_handler)

    $('#submit-solution').on("ajax:beforeSend", @evaluate);

  events: ->
    'click .btn-preview': 'preview'

  preview: (e) =>
    file = @find_html_file()
    if !file
      alert("No se puede ver la solución, no existe un archivo HTML")
      return false

    solution_id = $(@el).data("solution-id")
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
      save_files_timer.start() if @timer_active

  save_files: =>
    console.log("saving " + $('.editor-content').length + " files ... ")
    @saving_files = true

    data = @get_editors_data()
    @files_changed = false
    solution_id = $(@el).data("solution-id")
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

  evaluate: =>
    template = _.template($('#solution-eval-template').html());
    $('.overlay').html(template()).show()
    @check_evaluation_interval = setTimeout(@check_evaluation_status, 1000)

  check_evaluation_status: =>
    solution_id = $(@el).data("solution-id")
    $.ajax(
      type: "GET",
      url: "/solutions/" + solution_id
      dataType: "json"
    ).done( (solution) =>
      if (solution.status != "evaluating")
        @display_alert(solution)
      else
        @check_evaluation_interval = setTimeout(@check_evaluation_status, 1000)
    ).fail( =>
      console.log("Hubo un error obteniendo el estado de la evaluación")
    )

  display_alert: (solution) =>
    template = _.template($('#notification-template').html());
    if solution.status == "completed"
      data =
        status: "completed"
        title: "Reto Superado"
        message: "<strong>¡Felicitaciones!</strong> Lo lograste."
        color: "#4DFF62"
        icon: "ok-sign"
        user: solution.user_hash
    else if solution.status == "failed"
      data =
        status: "failed"
        title: "Intenta Nuevamente",
        message: @html_escape(solution.error_message),
        color: "#FF4242",
        icon: "exclamation-sign"
    $template = $(template(data))
    $('.overlay').html($template);

  html_escape: (str) ->
    return String(str)
            .replace(/&/g, '&amp;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/(?:\r\n|\r|\n)/g, '<br />')

  remove: =>
    super()
    @timer_active = false
    Dispatcher.off("timer:save-files")
    Dispatcher.off("editors:change")
    $('#submit-solution').off("ajax:beforeSend")


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
    es = @.$('#challenge_evaluation_strategy').val()
    mode = if es == "ruby_embedded" or es == "ruby_git" or es == "rails_git" or es == "ruby_git_pr" then "ruby" else "javascript"
    @evaluation_editor = editors.configure  el: 'challenge_evaluation', opts: mode: mode

  events:
    'click .remove-file-btn': 'remove_file'
    'click #new-file-modal .add-btn': 'add_file'
    'change #challenge_evaluation_strategy': 'change_evaluation_strategy'

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

  change_evaluation_strategy: =>
    evaluation_strategy = @.$('#challenge_evaluation_strategy').val()
    @.$('#challenge_timeout').val( {"ruby_embedded":15,"phantomjs_embedded":30,"ruby_git":15,"rails_git":90,"sinatra_git":90,"ruby_git_pr":15,"async_phantomjs_embedded":30}[evaluation_strategy] )
    if evaluation_strategy == "ruby_embedded"
      @evaluation_editor.setOption("mode", "ruby")
      @evaluation_editor.setValue("def evaluate(files)\n\nend")
    else if evaluation_strategy == "phantomjs_embedded"
      @evaluation_editor.setOption("mode", "javascript")
      @evaluation_editor.setValue("open('index.html', function(status) {\n\n});")
    else if evaluation_strategy == "async_phantomjs_embedded"
      @evaluation_editor.setOption("mode", "javascript")
      @evaluation_editor.setValue("open('index.html', function(page, chain) {\n\n});")
    else if evaluation_strategy == "ruby_git"
      @evaluation_editor.setOption("mode", "ruby")
      @evaluation_editor.setValue("def evaluate(repo)\n\nend")
    else if evaluation_strategy == "rails_git"
      @evaluation_editor.setOption("mode", "ruby")
      @evaluation_editor.setValue("require 'rails_helper'")
    else if evaluation_strategy == "sinatra_git"
      @evaluation_editor.setOption("mode", "ruby")
      @evaluation_editor.setValue("require_relative 'spec_helper'\n\ndescribe \"...\" do\nend")
    else if evaluation_strategy == "ruby_git_pr"
      @evaluation_editor.setOption("mode", "ruby")
      @evaluation_editor.setValue("def evaluate(client, repo, pr_number)\n\nend")

window.InstructionsView = InstructionsView
window.SolutionView = SolutionView
window.save_files_timer = new Timer("timer:save-files", 1000)

window.ChallengeFormView = ChallengeFormView
