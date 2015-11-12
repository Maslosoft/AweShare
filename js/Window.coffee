

class @Maslosoft.AweShare.Window

	# Name
	name: '_blank'
	
	# Options
	menubar: 0
	resizable: 1
	scrollbars: 0
	status: 0
	toolbar: 0
	
	# position
	top: ''
	left: ''

	# Dimensions
	width: ''
	height: ''

	# Meta data
	
	# Sharing url
	url: ''
	
	# Page title
	title: ''
	
	# Page description
	description: ''
	
	constructor: (data) ->
		@title = data.title
		@description = data.description
	
	open: () =>
		if @width is ''
			@width = Math.ceil(window.innerWidth / 2)
		@width = Math.min(@width, window.innerWidth)
		if @height is ''
			@height = Math.ceil(window.innerHeight / 2)
		@height = Math.min(@height, window.innerHeight)
		if @top is ''
			@top = Math.ceil(window.innerHeight / 2) - Math.ceil(@height / 2)
		if @left is ''
			@left = Math.ceil(window.innerWidth / 2) - Math.ceil(@width / 2)
		
		specs = []
		for name in ['menubar', 'resizable', 'scrollbars', 'status', 'toolbar', 'top', 'left', 'width', 'height']
			value = @[name]
			if value isnt ''
				specs.push "#{name}=#{value}"
		window.open(@url, @name, specs.join(','));
