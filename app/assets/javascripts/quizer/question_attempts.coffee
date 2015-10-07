class MultiAnswerQuestionAttempt extends Backbone.View

  events:
    "click input" : "save"

  save: ->
    @.$el.trigger "submit"

class OpenQuestionAttempt extends Backbone.View

  events:
    "input textarea" : "save"

  save: ->
    @.$el.trigger "submit"

window.MultiAnswerQuestionAttempt = MultiAnswerQuestionAttempt
window.OpenQuestionAttempt = OpenQuestionAttempt
