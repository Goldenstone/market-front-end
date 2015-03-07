jquery = require("jquery")

$state = jquery(".state")
$cartQuantity = jquery(".state .amount")
$mask = jquery(".mask")
$notification = jquery(".notification")

common = 
    url: "#{location.protocol}//#{location.host}"
    token: null
    init: ->
        if localStorage.token
            @token = localStorage.token
            initHeader()
        initFooter()
    showMask: ->
        $mask.fadeIn()
    hideMask: ->
        $mask.fadeOut()
    notify: (msg)->
        @showMask()
        $notification.text(msg)
        $notification.fadeIn 400, =>
            $notification.fadeOut()
            @hideMask()

initHeader = ->
    jquery.ajax
        url: common.url + "/cart/cnt"
        type: "POST"
        data: 
            csrf_token: token
        success: (res)->
            if res.code is 0
                $cartQuantity.text(res.data)

initFooter = ->

module.exports = common