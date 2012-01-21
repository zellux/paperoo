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

  like_button = $(".article_social .like_button")
  like_button.bind "ajax:success", (event, data, status, xhr) =>
    if data['status'] == 'unliked'
      like_button.text('Like')
    else if data['status'] == 'liked'
      like_button.text('Unlike')
    end
