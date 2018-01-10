
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
	# @param object Configuration to init sharer. This has precedence over data attributes
	#
	constructor: (element, data = null) ->
		
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

		# If no config passed, init from data-* attributes
		if data is null
			data = @element.data()

		# Create head's meta data helper for further use
		meta = new Maslosoft.AweShare.Meta

		# Get services from element
		if typeof(data.services) is 'string'
			data.services = data.services.replace(/\s*/g, '').split ','
		if typeof(data.services) is 'undefined'
			data.services = []
			
		# Set url if empty string, as toString method might be called in adapters
		# Do not set it to document.location now, as it will be set just-in-time
		# for more dynamic behavior, see https://github.com/Maslosoft/AweShare/issues/4
		if not data.url
			data.url = ''
			
		# Set title and description if empty
		if not data.title
			data.title = document.title
			
		if not data.description
			data.description = meta.getName 'description'

		if not data.tags
			data.tags = meta.getName 'keywords'

		console.log meta.getName 'keywords'

		if data.tags
			data.tags = data.tags.split ','
			for tag, index in data.tags
				data.tags[index] = tag.replace '#', ''

		console.log data.tags

		if not data.image
			data.image = meta.getProperty 'og:image'
			
		# Setup counter
		if data.counter is undefined
			data.counter = true
			
		if data.counterEmpty is undefined
			data.counterEmpty = ''

		# Setup tip
		if data.tip is undefined
			data.tip = false

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

				if adapter.setData
					adapter.setData data
				
				# Setup window
				window = new Maslosoft.AweShare.Window(data)
				
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

		clearUrl = false
		# Set url if empty
		if not adapter.url
			adapter.url = document.location
			clearUrl = true

		# Decorate window by adapter
		adapter.decorate window
		
		window.open()

		if clearUrl
			adapter.url = ''

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