

class @Maslosoft.AweShare.Window

	# Name
	name: 'maslosoft-awe-share'
	
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
		w = screen.width or window.outerWidth
		h = screen.height or window.outerHeight
		
		# Calculate width if not available preffered width
		if @width is ''
			@width = Math.ceil(w / 2)
		# Restrict width to not overflow device
		@width = Math.min(@width, w)
		
		# Calculate height if not available preffered height
		if @height is ''
			@height = Math.ceil(h / 2)
		
		# Restrict height to not overflow device height
		@height = Math.min(@height, h)
		
		# Center window
		if @top is ''
			@top = Math.ceil(h / 2) - Math.ceil(@height / 2)
		if @left is ''
			@left = Math.ceil(w / 2) - Math.ceil(@width / 2)
		
		# Assign window specs
		specs = []
		for name in ['menubar', 'resizable', 'scrollbars', 'status', 'toolbar', 'top', 'left', 'width', 'height']
			value = @[name]
			if value isnt ''
				specs.push "#{name}=#{value}"
		window.open(@url, @name, specs.join(','));
