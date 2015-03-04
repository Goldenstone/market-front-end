$ = (selector)->
    doms = document.querySelectorAll(selector)
    if doms.length is 1 return doms[0]
    doms

module.exports = 
    $: $