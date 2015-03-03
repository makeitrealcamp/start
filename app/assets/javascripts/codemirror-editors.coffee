class Editors
  constructor: ->
    @_editors = []

  configure: (id, opts) =>
    defaults =
      mode: 'html'
      theme: 'solarized dark'
      lineNumbers: true
      styleActiveLine: false
      matchBrackets: false
      readOnly: false
      extraKeys:
        Tab: (cm) ->
          cm.replaceSelection("  " , "end")

    editor = CodeMirror.fromTextArea(document.getElementById('content-' + id), $.extend(defaults, opts))
    editor.setValue($('#content-' + id).val())
    editor.on("change", ->
      $('.btn-preview').addClass('disabled')
    )

    # add the editor to the collection of editors
    @_editors[id] = editor;

window.editors = new Editors()