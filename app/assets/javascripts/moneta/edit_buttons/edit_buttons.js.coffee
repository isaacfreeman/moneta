jQuery ($) ->
  # Add some tips
  $('.with-tip').powerTip
    smartPlacement: true
    fadeInTime: 50
    fadeOutTime: 50
  $('body').on('powerTipPreRender', '.with-tip', ->
    $('#powerTip').addClass $(this).data('action')
    $('#powerTip').addClass $(this).data('tip-color')
    return
  ).on 'powerTipClose', '.with-tip', ->
    $('#powerTip').removeClass $(this).data('action')
    return
  return
