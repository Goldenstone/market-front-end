jquery = require("jquery")

$loginBtn = jquery(".login-btn")
$logoutBtn = jquery(".logout-btn")
$entryCartBtn = jquery(".entry-cart-btn")

common = 
    url: "#{location.protocol}//#{location.host}"
    init: ->
        initHeader()
        initFooter()

initHeader = ->
    $loginBtn.click ->

initFooter = ->

module.exports = common