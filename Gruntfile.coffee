
module.exports = (grunt) ->

    coffeeify = require "coffeeify"
    stringify = require "stringify"

    grunt.initConfig
        clean:
            bin:
                src: ["static/css", "static/js"]
            dist: ["dist"]

        watch:
            compile:
                options:
                    livereload: true
                files: ["src/**/*.coffee", "src/**/*.less", "template/**/*.html"]
                tasks: ["browserify", "less"]

        browserify:
            dev:
                options:
                  preBundleCB: (b)->
                    b.transform(coffeeify)
                    b.transform(stringify({extensions: [".hbs", ".html", ".tpl", ".txt"]}))
                expand: true
                flatten: true
                src: ["src/coffee/*.coffee"]
                dest: "static/js"
                ext: ".js"

        less:
            compile:
                files: [{
                    expand: true,
                    cwd: "src/less",
                    src: ["*.less", "!_*.less"],
                    dest: "static/css",
                    ext: ".css"
                }]


        uglify:
            build:
                files: [{
                    expand: true
                    cwd: "static/js"
                    src: ["*.js"]
                    dest: "dist/js"
                    ext: ".min.js"
                }]

        cssmin:
            build:
                files: [{
                    expand: true
                    cwd: "static/css"
                    src: ["*.css"]
                    dest: "dist/css"
                    ext: ".min.css"
                }]

        copy:
            assets:
                src: "static/images"
                dest: "dist/images"
            # css:
            #     options:
            #         process: (content, srcpath)->
            #             return content.replace /\/assets/g, "../assets"
            #     files:
            #         "dist/css/style.css": ["bin/css/style.css"]
            # html:
            #     options:
            #         process: (content, srcpath)->
            #             return content.replace(/\/assets/g, "./assets") \
            #                     .replace(/\/bin/g, ".").replace(/main.js/g, "main.min.js")
            #     files:
            #         "dist/index.html": ["src/index.html"]

        imagemin:
            dev:
                files: [
                    expand: true
                    cwd: 'notminimgs'
                    src: ['*.{png, jpg, gif}']
                    dest: 'static/images/'
                ]

    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks "grunt-contrib-less"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-cssmin"
    grunt.loadNpmTasks "grunt-contrib-imagemin"

    grunt.registerTask "default",  ->
        grunt.task.run [
            # "clean:bin"
            "browserify"
            "less"
            "watch"
        ]

    grunt.registerTask "build", ->
        grunt.task.run [
            "clean:bin"
            "clean:dist"
            "browserify"
            "less"
            "uglify"
            "cssmin"
            "copy"
        ]

    grunt.registerTask "min", ["imagemin"]