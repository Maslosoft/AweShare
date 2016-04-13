coffees = [
	'_ns'
	'_functions'
	'AweShare'
	'Adapter'
	'Counter'
	'Meta'
	'Renderer'
	'Window'
	'Adapters/*'
	'_init'
]
langs = [
	'pl'
]
less = [
	'css/awe-share.less'
]

module.exports = (grunt) ->
	c = new Array
	for name in coffees
		c.push "js/#{name}.coffee"

	i18n = {}
	for name in langs
		i18n["dist/lang/#{name}.js"] = "js/lang/#{name}.coffee"

	# Project configuration.
	grunt.initConfig
		coffee:
			compile:
				options:
					sourceMap: true
					join: true
					expand: true
				files: [
					'dist/awe-share.js': c
				]
			langs:
				files: i18n
		uglify:
			compile:
				files:
					'dist/awe-share.min.js' : ['dist/awe-share.js']
		watch:
			compile:
				files: c
				tasks: ['coffee:compile']
			less:
				files: less
				tasks: ['less:compile']
		less:
			compile:
				files:
					'dist/awe-share.css' : less
				options:
					sourceMap: true
		cssmin:
			target:
				files:
					'dist/awe-share.min.css' : ['dist/awe-share.css']

	# These plugins provide necessary tasks.
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-less'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'

	# Default task.
	grunt.registerTask 'default', ['coffee', 'less', 'uglify', 'cssmin']
