class Editors
  constructor: ->
    @_editors = {}

  configure: (options) =>
    defaults =
      mode: 'html'
      theme: 'monokai'
      lineNumbers: true
      styleActiveLine: false
      matchBrackets: false
      readOnly: false
      extraKeys:
        Tab: (cm) ->
          cm.replaceSelection("  " , "end")

    editor = CodeMirror.fromTextArea(document.getElementById(options.el), $.extend(defaults, options.opts))
    return editor
    

  add: (id, editor) ->
    @_editors[id] = editor;

  get: (id) ->
    @_editors[id]

  remove: (id) ->
    delete @_editors[id]

  refresh: =>
    editor.refresh() for own _, editor of @_editors

window.editors = new Editors()