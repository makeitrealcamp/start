class ChallengeView
  constructor: ->
    @files_changed = false;

    Events.removeAllListeners("timer:save-files").on("timer:save-files", @save_files_handler)
    Events.removeAllListeners("editors:change").on("editors:change", =>
      $('.btn-preview').addClass('disabled');
      @files_changed = true;
    )

    # start the timeout
    save_files_timer.start()

    # open images in modal
    $('#instructions img').off("click").on("click", @display_images)

    # open links in new tab
    $("#instructions a").filter( ->
      return this.hostname != window.location.hostname;
    ).attr('target', '_blank')

    # persist documents
    $(document).off("page:before-change").on("page:before-change", @save_files_handler)
    $('#new-file').off("ajax:before").on("ajax:before", @save_files_handler)
    $('.remove-document').off("ajax:before").on("ajax:before", @save_files_handler)

    # preview solution
    $('.btn-preview').off('click').on('click', @preview)

  display_images: ->
    img = $(@).clone()
    $('.modal-body').empty()
    $('.modal-dialog').width(@.naturalWidth)
    $('.modal-body').append(img)
    $('#zoom-modal').modal({show:true})

  preview: (e) =>
    file = @find_html_file()
    if !file
      alert("No se puede ver la solución, no existe un archivo HTML")
      return false

    solution_id = $('.editors').data("solution-id")
    $(e.currentTarget).attr("href", '/solutions/' + solution_id + '/preview/' + file.html())

  find_html_file: ->
    index = $(".solution .nav-tabs").find("a[data-toggle='tab']").find('.name:contains("index.html")')
    file_active = $('.solution .nav-tabs .active .name:contains(".html")')
    file_html = $(".solution .nav-tabs").find("a[data-toggle='tab']").find('.name:contains(".html")')

    return $('.solution .nav-tabs .active .name') if file_active.length > 0
    return index if index.length > 0
    return file_html.first() if file_html.length > 0

    return false

  save_files_handler: =>
    if @files_changed and not @saving_files and $('.editors').length and $('.editor-content').length
      @save_files()
    else
      save_files_timer.start()

  save_files: =>
    console.log("saving " + $('.editor-content').length + " files ... ")
    @saving_files = true
    
    data = @fill_editors_data()
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

  fill_editors_data: ->
    data = {};
    $('.editor-content').each (index) ->
      document_id = $(this).data("id")
      editor = editors.get(document_id)
      data['editor-' + document_id] = editor.getValue()
    data

class Timer
  constructor: (@event, @timeout) ->

  start: =>
    @timer = setTimeout (=>
      Events.emit(@event)), @timeout
    @

  cancel: =>
    clearTimeout(@timer) if @timer?
    @

window.ChallengeView = ChallengeView
window.save_files_timer = new Timer("timer:save-files", 1000).start()