class InnovateProgramTestView extends Backbone.View
  el: '.top-test-page'

  modes:
    javascript: "javascript"
    ruby: "ruby"
    python: "python"
    php: "php"
    java: "text/x-java"
    cplus: "text/x-c++src"
    csharp: "text/x-csharp"

  initialize: (@questions) ->
    @options =
      mode: @modes["javascript"]
      theme: 'monokai'
      lineNumbers: true
      height: 100

    @a1 = CodeMirror.fromTextArea(document.getElementById("a1"), @options)
    @a1.setSize(null, 200)

    @a2 = CodeMirror.fromTextArea(document.getElementById("a2"), @options)
    @a2.setSize(null, 200)

    @a3 = CodeMirror.fromTextArea(document.getElementById("a3"), @options)
    @a3.setSize(null, 200)

  events: ->
    "change #lang": "change_lang"

  change_lang: (e) ->
    value = $(e.currentTarget).val()
    @a1.setOption("mode", @modes[value])
    @a2.setOption("mode", @modes[value])
    @a3.setOption("mode", @modes[value])

    description = @questions[0].description[value] || @questions[0].description.default
    $('#q1 .description').html(description)

    description = @questions[1].description[value] || @questions[1].description.default
    $('#q2 .description').html(description)

    description = @questions[2].description[value] || @questions[1].description.default
    $('#q3 .description').html(description)

    examples = @questions[0].examples[value]
    $('#q1 .examples').html(examples)

    examples = @questions[1].examples[value]
    $('#q2 .examples').html(examples)

    examples = @questions[2].examples[value]
    $('#q3 .examples').html(examples)

window.InnovateProgramTestView = InnovateProgramTestView
