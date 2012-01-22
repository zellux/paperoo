# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if (typeof(qq) != 'undefined')
    uploader = new qq.FileUploader({
      element: document.getElementById('bibtex-uploader'),
      action: '/articles/upload.json',
      template: '<div class="qq-uploader">' +
                '<div class="qq-upload-drop-area"><span>Drop bibtex here to upload</span></div>' +
                '<div class="qq-upload-button">Upload bibtex</div>' +
                '<ul class="qq-upload-list"></ul>' +
              '</div>',
      params: {"type": "bibtex"},
      onComplete: (id, fileName, responseJSON) ->
        update_form(responseJSON)
      debug: true
    });

    uploader = new qq.FileUploader({
      element: document.getElementById('endnote-uploader'),
      action: '/articles/upload.json',
      template: '<div class="qq-uploader">' +
                '<div class="qq-upload-drop-area"><span>Drop endnote here to upload</span></div>' +
                '<div class="qq-upload-button">Upload endnote</div>' +
                '<ul class="qq-upload-list"></ul>' +
              '</div>',
      params: {"type": "endnote"},
      onComplete: (id, fileName, responseJSON) ->
        update_form(responseJSON)
      debug: true
    });

  update_form = (json) ->
    items = ['title', 'year', 'author_list', 'page_start', 'page_end']
    for i in items
      value = json[i]
      if value
        $("#article_#{i}").val(value)



  like_button = $(".article-social .like_button")
  like_button.bind "ajax:success", (event, data, status, xhr) =>
    if data['status'] == 'unliked'
      like_button.text('Like')
    else if data['status'] == 'liked'
      like_button.text('Unlike')
    likelist = ''
    if data['current'].length > 0
      console.log(data)
      likelist = 'Liked by ' + [u['username'] for u in data['current']].join(', ')
      console.log likelist
    $('.like-list').html(likelist)

  this.modify_comment = modify_comment = (i) ->
    comment = $("#comment#{i}")
    comment_message = $("#comment#{i} .comment-message")
    text = $("#comment#{i} .comment-message .comment-text").text()
    csrf_token = $('meta[name=csrf-token]')[0].content
    div_outer = $('<div class="comment-reply"></div>')
    html = '<form action="/comments/' + i + '" method="POST">
     <input name="_method" type="hidden" value="put" />
     <input name="authenticity_token" type="hidden" value="' + csrf_token + '"/>
     <textarea name="text" class="span7">' + text + '</textarea>
     <input type="submit" value="Update" class="btn primary" />
     </form>'
    form = $(html)
    form.wrap(div_outer)
    comment_message.replaceWith(form.outerHTML())

  $('#article_search_field').bind 'railsAutocomplete.select', (event, data) =>
    window.location = "/articles/#{data.item.id}"
