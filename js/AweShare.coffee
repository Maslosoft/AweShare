
class @Maslosoft.AweShare

	@idCounter: 0

	#
	# Share container
	# @var jQuery
	#
	element: ''
	
	#
	# Adapters array
	#
	# @var Maslosoft.AweShare.Adapter[]
	#
	adapters: {}
	
	#
	# Windows array
	#
	# @var Maslosoft.AweShare.Window[]
	#
	windows: {}

	#
	#
	#
	# @param element HtmlElement
	#
	constructor: (element) ->
		
		# Ensure we have new instances here
		@adapters = {}
		@windows = {}
		@element = {}
		
		# Increment id counter, this is used to fill missing element id
		AweShare.idCounter++
		
		# Grab wrapping element
		@element = jQuery element
		
		if not @element.attr('id')
			@element.attr('id', "maslosoft-awe-share-#{AweShare.idCounter}")
		
		data = @element.data()
		
		meta = new Maslosoft.AweShare.Meta

		# Get services from element
		if typeof(data.services) is 'string'
			data.services = data.services.replace(/\s*/g, '').split ','
		if typeof(data.services) is 'undefined'
			data.services = []
			
		# Set url if empty
		if not data.url
			data.url = document.location
			
		# Set title and description if empty
		if not data.title
			data.title = document.title
			
		if not data.description
			data.description = meta.getName 'description'
			
		if not data.image
			data.image = meta.getProperty 'og:image'
			
		# Setup counter
		if data.counter is undefined
			data.counter = true
			
		if data.counterEmpty is undefined
			data.counterEmpty = ''
			
		# Use all services if not defined on element
		if not data.services.length
			for name, adapter of Maslosoft.AweShare.Adapters
				data.services.push @decamelize(name)

		# Check if has adapter and instantiate if possible
		@adapters = {}
		for index, name of data.services
			adapterName = @camelize name

			# Check if adapter is method
			if typeof(Maslosoft.AweShare.Adapters[adapterName]) is 'function'
			
				# Setup adapter
				adapter = new Maslosoft.AweShare.Adapters[adapterName]
				adapter.setUrl data.url
				
				# Setup window
				window = new Maslosoft.AweShare.Window(data)
				
				# Decorate window by adapter
				adapter.decorate window
				
				# Assign to local properties
				@adapters[name] = adapter
				@windows[name] = window
			else
				console.warn "No adapter for #{name} in ", element, (new Error).stack
				data.services.splice(index, 1)
				
		if @adapters.length is 0
			console.warn "No adapters selected for ", element, (new Error).stack

		# Attach events
		@element.on 'click', 'a', @share
			
		new Maslosoft.AweShare.Renderer @, data, @adapters
		

	# Event handlers
	
	#
	# Share click handler
	#
	# @param e Event
	#
	share: (e) =>
		data = jQuery(e.currentTarget).data()
		service = data.service
		adapter = @adapters[service]
		window = @windows[service]
		
		window.open()
		
		e.preventDefault()
		

	# Utility methods

	#
	# Transform camel case into dashed string
	#
	#
	decamelize: (text, sep = '-') ->
		text.replace /([a-z\d])([A-Z])/g, '$1' + sep + '$2'
		.replace new RegExp('(' + sep + '[A-Z])([A-Z])', 'g'), '$1' + sep + '$2'
		.toLowerCase()
		
	#
	# Transform dashed string into camel case
	#
	#
	camelize: (text) ->
		return text.replace /(?:^|[-_])(\w)/g, (_, c) ->
			if c then c.toUpperCase() else ''

	# Static methods

	#
	# Auto init all sharers
	# @static
	#
	#
	@init = () ->
		jQuery('.awe-share').each (id, element) ->
			new window.Maslosoft.AweShare element