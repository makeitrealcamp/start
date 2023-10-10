class VirtualTutorView extends Backbone.View
  el: '.virtual-tutor'

  initialize: (pusher_key, @challenge_id) ->
    token_tag = document.querySelector("[name='csrf-token']")
    @csrf_token = if token_tag then token_tag.content else ''
    @chat_el = $('.virtual-tutor-chat', $(@el))
    @pusher = new Pusher(pusher_key, { encrypted: true })

  events:
    'click .virtual-tutor-icon': 'toggle_chat'
    'click .virtual-tutor-chat .close': 'close_chat'
    'keypress #chat-input': 'handle_input_keypress'
    'click .virtual-tutor-error .try-again': 'try_again'

  toggle_chat: (e) ->
    if @chat_el.hasClass('open')
      @chat_el.removeClass('open')
    else
      @chat_el.addClass('open')
      $('#chat-input', @chat_el).focus()

  close_chat: (e) ->
    @chat_el.removeClass('open')

  dismiss_error: ->
    $('.virtual-tutor-error').removeClass('show-error')

  try_again: (e) ->
    e.preventDefault()
    @dismiss_error()
    @handle_question(@last_question)

  handle_input_keypress: (e) ->
    if e.keyCode != 13
      return

    @dismiss_error()
    question = $(e.currentTarget).text()
    @last_question = question
    @add_message({ role: "user", content: question })
    @handle_question(question)

    return false

  handle_question: (question) ->
    $('.tutor-typing').show()
    $('#chat-input').removeAttr('contenteditable').blur()

    if !@chat_id
      @create_chat().then => @send_message(question)
    else
      @send_message(question)

  add_message: (message) ->
    role = if message.role == "user" then "You" else "Hashy (Tutor Virtual)"
    id = if message.id then 'id="msg-' + message.id + '"' else ''
    messages_el = $('.messages', $(@el))
    messages_el.append('<div class="message" ' + id + '><header><div class="role">' + role + '</div></header><div class="text">' + message.content + '</div></div>')
    last_message = $('.message:last-child', messages_el)[0]
    messages_el.scrollTop(messages_el[0].scrollHeight - last_message.scrollHeight - 35)
    $('#chat-input', $(@el)).html('')

  create_chat: ->
    data = { challenge_id: @challenge_id }
    return fetch('/chats',
      method: "POST",
      headers:
        "X-CSRF-Token": @csrf_token,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      ,
      body: JSON.stringify(data)
    )
    .then((response) => response.json())
    .then((chat) => @chat_id = chat.id)

  send_message: (question) ->
    fetch('/chats/' + @chat_id + '/chat_messages',
      method: "POST",
      headers: {
        "X-CSRF-Token": @csrf_token,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ request: question })
    )
    .then((response) -> response.json())
    .then((message) =>
      channel = @pusher.subscribe('chat-message-' + message.id)
      channel.bind('chat-message:end', (data) => @handle_response_received(message, data))
      channel.bind('chat-message:error', (error) => @handle_error(message, error))
    )

  handle_response_received: (message, data) =>
    @add_message({ id: message.id, role: "assistant", content: data.text })
    @enable_typing(message.id)

  handle_error: (message, error) =>
    $('.virtual-tutor-error').addClass('show-error')
    @enable_typing()

  enable_typing: (message_id) ->
    $('#chat-input').attr('contenteditable', true)
    $('.tutor-typing').hide()
    @pusher.unsubscribe('chat-message-' + message_id)

  remove: ->
    super()
    @pusher.disconnect()

window.VirtualTutorView = VirtualTutorView