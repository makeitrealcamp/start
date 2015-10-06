class MultiAnswerQuestionAttempt extends Backbone.View

  events:
    "click input" : "save"

  save: ->
    @.$el.trigger "submit"

window.MultiAnswerQuestionAttempt = MultiAnswerQuestionAttempt
