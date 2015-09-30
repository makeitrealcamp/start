class MultiAnswerQuestionAttempt extends Backbone.View

  events:
    "click input" : "save"

  save: ->
    console.log "Hola"
    @.$el.trigger "submit"

window.MultiAnswerQuestionAttempt = MultiAnswerQuestionAttempt
