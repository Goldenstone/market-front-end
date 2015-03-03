jquery = require("jquery")
common = require("./common.coffee")

$locationWord = jquery(".location-word")
$chooseLocationBtn = jquery(".choose-location-btn")
$locationsBox = jquery(".locations-box")
$locations = jquery(".location")

window.onload = ->
    common.init()
    initChooseLocationBtn()
    initLocations()

initChooseLocationBtn = ->
    $chooseLocationBtn.click ->
        $locationsBox.show()

initLocations = ->
    $locations.click (e)->
        building_name = # get building_name
        building_id = # get building_id
        jquery.ajax
            url: common.url + "/choose_location"
            data:
                building_id: building_id
            success: (data)->
                $locationWord.text(building_name)
                $locations.hide()