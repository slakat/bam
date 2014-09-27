####
#  Esto hace que la navegación por AJAX funcione muy bien
####
#
#mainContainer = '#main-container'
#
#$(document).ready ->
#
#  window.wiselinks = new Wiselinks($(mainContainer), target_missing: 'exception')
#  DO_BACK_BUTTON = false
#
#  modal = $('#main-modal')
#  modalBody = $('#main-modal-body')
#
#  modal.on 'hidden.bs.modal', ->
#    if DO_BACK_BUTTON
#      History.back()
#      DO_BACK_BUTTON = false
#      console.log 'click close'
#    clearModal()
#
#  showModal = ->
#    DO_BACK_BUTTON = true
#    modal.modal 'show'
#
#  hideModal = ->
#    DO_BACK_BUTTON = false
#    modal.modal 'hide'
#
#  clearModal = ->
#    modalBody.html('')
#
#  pageDone = (event, $target, status, url, data) ->
#
#    $(document).trigger('page:load')
#
#    console.log('pageDone')
#
#    if $target.attr('id') is 'main-modal-body'
#      showModal()
#    else
#      hideModal()
#
#    ###
#      Google Analytics and Wiselinks
#    ###
#    if _gaq?
#      _gaq.push(['_trackPageview', url])
#      _metrika.hit(url)
#
#  $(document).off('page:done').on 'page:done', pageDone