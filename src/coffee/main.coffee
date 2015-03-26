jquery = require("jquery")
ko = require("knockout")
common = require("./common.coffee")
$locationWord = jquery(".location-word")
$chooseLocationBtn = jquery(".choose-location-btn")
$schoolsBox = jquery(".schools-box")
$buildingsBox = jquery(".buildings-box")
$hotProductsList = jquery(".hot-products-list")
$productCounts = jquery(".product-count")

vm =
    schools: ko.observableArray([])
    buildings: ko.observableArray([])
    location: ko.observable('')

window.onload = ->
    intRegex = /^\d+$/
    vm.location($locationWord.text())
    common.init()
    getProducts()
    initChooseLocationBtn()
    initLocation()
    unless common.token
        $chooseLocationBtn.click()

initChooseLocationBtn = ->
    $chooseLocationBtn.click ->
        common.showMask()
        console.log $schoolsBox
        $schoolsBox.show()

initLocation = ->
    common.getSchools (res) ->
        bindSchools res.data

bindSchools = (schools) ->
    for school in schools
        school.choose = ->
            common.getBuildings @id, (res) =>
                $schoolsBox.hide()
                bindBuildings @name, res.data
                $buildingsBox.show()
    vm.schools schools

bindBuildings = (school_name, buildings) ->
    strategy =
        "0": "定位成功"
        "1": "error: 无效的参数"
        "-1": "error: 建筑物不存在"
    for building in buildings
        building.choose = ->
            common.changeLocation @id, (res) =>
                common.hideMask()
                $buildingsBox.hide()
                vm.location(school_name + @name)
                localStorage.token = res.data.csrf_token
                common.notify(strategy[res.code])
    vm.buildings(buildings)

getProducts = ->
    jquery.ajax
        url: common.url + "/product/list"
        type: 'POST'
        success: (res) ->
            res = JSON.parse res
            if res.code is 0
                bindProducts res.data.products

bindProducts = (products) ->
    for product in products
        product.setAmount = ->
            amount = parseInt(@amount())
            if amount and amount > 0
                @amount(amount)
            else
                @amount(1)
                common.notify("请输入正整数");

        product.formattedPrice = "￥ " + product.price
        product.amount = ko.observable 1
        product.amountIsNumber = ko.observable true
        product.isOverflow = ko.pureComputed ->
            return @amount() > @quantity
        , product
        product.add = -> @amount @amount() + 1
        product.reduce = ->
            if @amount() > 1
                @amount @amount() - 1
        product.addToCart = ->
            common.addToCart @id, @amount(), ->
                common.initHeader()
                return

    vm.products = ko.observableArray products
    ko.applyBindings vm

