coffees = [
	'_ns'
	'AweShare'
	'Adapter'
	'Renderer'
	'Adapters/*'
	'_init'
]

less = [
	'css/awe-share.less'
]

module.exports = (grunt) ->
	c = new Array
	for name in coffees
		c.push "js/#{name}.coffee"

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
