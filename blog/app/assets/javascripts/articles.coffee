# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $('input[type=file]').change ->
    filename = $('input[type=file]').val().split('\\').pop()
    $('#fileName').html filename
    return

  $('#login_register_btn').click ->
    $('#login-form').addClass 'hidden'
    $('#register-form').removeClass 'hidden'
    return

  $('#register_login_btn').click ->
    $('#login-form').removeClass 'hidden'
    $('#register-form').addClass 'hidden'
    return  

  return
