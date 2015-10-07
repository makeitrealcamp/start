class MultiAnswerQuestionForm extends Backbone.View

  events:
    "click .add-correct-answer" : "add_correct_answer"
    "click .add-wrong-answer" : "add_wrong_answer"
    "click .remove-answer" : "remove_answer"

  add_correct_answer: ->
    @add_answer("correct_answers")

  add_wrong_answer: ->
    @add_answer("wrong_answers")

  add_answer: (type)->
    type_class = type.replace(/_/g,'-')
    template = _.template($("#multi-answer-question-answer-template").html())
    @$el.find(".#{type_class}").append(template({type: type,answer:""}))

  remove_answer: (event)->
    $remove_btn = $(event.currentTarget)
    $remove_btn.parents(".answer").remove()

window.MultiAnswerQuestionForm = MultiAnswerQuestionForm
