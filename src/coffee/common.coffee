jquery = require("jquery")
utils = require("./utils.coffee")

$ = utils.$
# $logoutBtn = jquery(".logout-btn")
# $entryCartBtn = jquery(".entry-cart-btn")
$$state = jquery(".state")
$$mask = jquery(".mask")

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