jquery = require("jquery")
ko = require("knockout")
common = require("./common.coffee")

$locationWord = jquery(".location-word")
$chooseLocationBtn = jquery(".choose-location-btn")
$schoolsBox = jquery(".schools-box")
$buildingsBox = jquery(".buildings-box")
$hotGoodsList = jquery(".hot-goods-list")
$goodCounts = jquery(".good-count")

vm =
    buildings: ko.observableArray([])
    location: ko.observable('')
    overflow: ko.observable

window.onload = ->
    intRegex = /^\d+$/
    vm.location($locationWord.text())
    common.init()
    initChooseLocationBtn()
    initLocations()
    initAddGoodsToCartBtn(intRegex)
    initGoodOperation(intRegex)
    initGoodCountListener()
    ko.applyBindings vm
    unless common.token
        $chooseLocationBtn.click()

initChooseLocationBtn = ->
    $chooseLocationBtn.click ->
        common.showMask()
        $schoolsBox.show()

initLocations = ->
    $schoolsBox.click (e)->
        unless e.target.classList.contains('school') then return
        school_name = e.target.innerText # get name
        school_id = e.target.dataset.sid # get building_id
        common.getBuildings school_id, (res)->
            $schoolsBox.hide()
            $buildingsBox.show()
            # vm.buildings(res.data)
            bindBuildings(school_name, res.data)

bindBuildings = (school_name, buildings) ->
    strategy =
        "0": "定位成功"
        "1": "error: 无效的参数"
        "-1": "error: 建筑物不存在"
    for building in buildings
        building.chooseBuilding = ->
            common.changeLocation @id, (res) =>
                common.hideMask()
                $buildingsBox.hide()
                vm.location(school_name + @name)
                localStorage.token = res.data._csrf_token
                common.notify(strategy[res.code])
    vm.buildings(buildings)

initAddGoodsToCartBtn = (intRegex) ->
    $hotGoodsList.click (e)->
        unless e.target.classList.contains('add-goods-to-cart-btn') then return
        good_id = e.target.dataset.id
        amount = jquery(e.target).prev().children(":first").val()
        unless intRegex.test(amount) or amount == 0
            common.notify("请输入正整数")
            return
        amount = Number(amount)
        common.addToCart good_id, amount, ->
            common.initHeader()
            return

initGoodOperation = (intRegex)   ->
    $hotGoodsList.click (e) ->
        unless e.target.classList.contains('good-operation') then return
        console.log 'plus'
        counter = jquery(e.target).parent().prev()
        amount = counter.val()
        unless intRegex.test(amount)
            common.notify("请输入正整数")
            return
        amount = Number(amount)
        if e.target.classList.contains('good-plus') then amount += 1 else amount -= 1
        if amount >= 0
            counter.val(amount)

initGoodCountListener = ->
    jquery.each $goodCounts, (index, goodCount) ->
        quantity = goodCount.dataset.quantity
        counter = jquery(goodCount)
        inventory = counter.parent().prev()
        counter.keyup ->
            amount = Number(counter.val())
            if isNaN(amount) then return
            if amount > quantity
                inventory.text("超出库存")
            else
                inventory.text("\xa0") # xa0 equal to &nbsp;


