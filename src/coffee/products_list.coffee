jquery = require("jquery")
ko = require("knockout")
common = require("./common.coffee")

$cart1 = jquery(".kind")
$cart2 = jquery(".cat2")
$locationWord = jquery(".location-word")
$chooseLocationBtn = jquery(".choose-location-btn")
$schoolsBox = jquery(".schools-box")
$buildingsBox = jquery(".buildings-box")

applied = false

vm =
    schools: ko.observableArray([])
    buildings: ko.observableArray([])
    location: ko.observable('')
    currentCart1Id: ko.observable(0)

window.onload = ->
    common.init()
    cat1_id = getUrlParameter 'cat1'
    cat2_id = getUrlParameter 'cat2'
    getProducts getData(cat1_id, cat2_id)
    initCart1Btn()
    initCart2Btn()
    vm.location($locationWord.text())
    initChooseLocationBtn()
    initLocations()
    vm.location($locationWord.text())
    unless common.token
        $chooseLocationBtn.click()

initChooseLocationBtn = ->
    $chooseLocationBtn.click ->
        common.showMask()
        $schoolsBox.show()

initLocations = ->
    common.getSchools (res) ->
        bindSchools res.data

bindSchools = (schools) ->
    for school in schools
        school.choose = ->
            console.log @id
            console.log @name
            common.getBuildings @id, (res) =>
                $schoolsBox.hide()
                bindBuildings @name, res.data
                # vm.buildings(res.data)
                $buildingsBox.show()
    vm.schools schools

bindBuildings = (school_name, buildings) ->
    for building in buildings
        building.choose = ->
            console.log @id
            console.log @name
            common.changeLocation @id, (res) =>
                common.hideMask()
                $buildingsBox.hide()
                console.log school_name
                console.log @name
                vm.location school_name + @name
                localStorage.token = res.data._csrf_token
    vm.buildings buildings

getData = (cat1_id, cat2_id) ->
    if cat1_id
        if cat2_id
            data =
                cat1_id: cat1_id
                cat2_id: cat2_id
        else
            data =
                cat1_id: cat1_id
    else
        data =
            cat2_id: cat2_id

getProducts = (data) ->
    jquery.ajax
        url: common.url + "/product/list"
        type: 'POST'
        data: data
        success: (res) ->
            res = JSON.parse res
            if res.code is 0
                bindProducts res.data.products
                vm.currentCart1Id res.data['current_cat1'].id

bindProducts = (products) ->
    for product in products
        product.formattedPrice = "￥ " + product.price
        product.amount = ko.observable 1
        product.amountIsNumber = ko.observable true
        product.isOverflow = ko.pureComputed ->
            return @amount() > @quantity
        , product
        product.add = -> @amount @amount() + 1
        product.reduce = -> @amount @amount() - 1
        product.addToCart = ->
            common.addToCart @id, @amount(), ->
                common.initHeader()
                return

    unless applied
        vm.products = ko.observableArray products
        ko.applyBindings vm
        applied = true
    else
        vm.products products

getUrlParameter = (sParam) ->
    sPageURL = window.location.search.substring 1
    sURLVariables = sPageURL.split '&'
    for sURLVariable in sURLVariables
        sParameterName = sURLVariable.split '='
        if sParameterName[0] == sParam
            return sParameterName[1]

initCart1Btn = ->
    $cart1.click (e) ->
        cat1 = e.target
        data =
            cat1_id: cat1.dataset.cat1
        getProducts data

initCart2Btn = ->
    $cart2.click (e) ->
        cat2 = e.target
        data =
            cat2_id: cat2.dataset.cat2
        getProducts data
