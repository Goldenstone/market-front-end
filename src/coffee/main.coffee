jquery = require("jquery")
knockout = require("knockout")
common = require("./common.coffee")

$locationWord = jquery(".location-word")
$chooseLocationBtn = jquery(".choose-location-btn")
$locationsBox = jquery(".locations-box")
$hotGoodsList = jquery(".hot-goods-list")

window.onload = ->
    common.init()
    initChooseLocationBtn()
    initLocations()
    initAddGoodsToCartBtn()
    if not common.token
        $chooseLocationBtn.click()

initChooseLocationBtn = ->
    $chooseLocationBtn.click ->
        # common.showMask()
        $locationsBox.show()

initLocations = ->
    strategy = 
        "0": "定位成功"
        "1": "error: 无效的参数"
        "-1": "error: 建筑物不存在"
    $locationsBox.click (e)->
        if e.target.className isnt 'location' then return
        building_name = null # get name
        building_id = 0 # get building_id
        jquery.ajax
            url: common.url + "/choose_location"
            type: 'POST'
            data:
                building_id: building_id
            success: (data)->
                $locationWord.text(building_name)
                # common.hideMask()
                $locationsBox.hide()
                common.notify(strategy[data.status])


initAddGoodsToCartBtn = ->
    strategy = 
        "0": "添加成功"
        "1": "error: 无效的参数"
        "2": "error: invalid token"
        "3": "亲，请先选择学校楼栋喔"
        "-1": "亲，请先清除购物车中的冲突商品喔"
        "-2": "Oops!商品不存在"
    $hotGoodsList.click (e)->
        if e.target.className isnt 'add-goods-to-cart-btn' then return
        good_id = 0
        amount = 1
        if amount < 1
            common.notify("数量要大于0喔！")
            return 
        jquery.ajax
            url: common.url + "/cart/insert"
            type: "POST"
            data:
                csrf_token: common.token
                product_id: good_id
                quantity: amount
            success: (res)->
                common.notify(strategy[res.status])
