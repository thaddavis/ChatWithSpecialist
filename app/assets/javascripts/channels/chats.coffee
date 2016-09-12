jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')

  $('#new_message').submit (e) ->
      $this = $(this)
      textarea = $this.find('#message_body')
      if $.trim(textarea.val()).length > 1
        App.global_chat.send_message textarea.val(), messages.data('chat-id')
        textarea.val('')
      e.preventDefault()
      return false

  if $('#messages').length > 0

    messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

    messages_to_bottom()
    # $('html,body').animate({
    #     scrollTop: $('#chat-text-area').offset().top - 60 },
    #     'slow');

    App.global_chat = App.cable.subscriptions.create {
        channel: "ChatsChannel"
        chat_id: messages.data('chat-id')
      },

      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        messages.append data['message']
        messages_to_bottom()

      send_message: (message, chat_id) ->
        @perform 'send_message', message: message, chat_id: chat_id
