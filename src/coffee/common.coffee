jquery = require("jquery")

# $loginBtn = jquery(".login-btn")
# $logoutBtn = jquery(".logout-btn")
# $entryCartBtn = jquery(".entry-cart-btn")
$mask = jquery(".mask")

common = 
    url: "#{location.protocol}//#{location.host}"
    init: ->
        initHeader()
        initFooter()
    showMask: ->
        $mask.show()
    hideMask: ->
        $mask.hide()

initHeader = ->

initFooter = ->

module.exports = common