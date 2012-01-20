# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
        $('#author_search_field').bind 'railsAutocomplete.select', (event, data) =>
                window.location = "/authors/#{data.item.id}"
