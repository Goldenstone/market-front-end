jquery = require 'jquery'
moment = require 'moment'
_ = require 'lodash'
humanize = require 'humanize-duration'
require 'moment/locale/zh-cn'

$counter = jquery('.timer-uncompleted .counter')

window.onload = ->
    _.each $counter, (counter) ->
        interval = 1000
        counter.interval = setInterval ->
            countdown(counter)
        , interval * 60
        countdown(counter)

countdown = (counter) ->
    releasedTime = counter.dataset.release
    timeDelta = counter.dataset.timedelta
    currentTime = Date.now()
    passedTime = currentTime - releasedTime
    counterTime = timeDelta - passedTime
    if counterTime < 0
        jquery(counter).prev().text('已超时').css(color: "red", fontSize: '20px')
        clearTimeout(counter.interval)
    else
        jquery(counter).text humanize(counterTime,
            language: "zh-CN"
            delimiter: ""
            spacer: ""
            round: true
            halfUnit: false
            units: ["days", "hours", "minutes"])

