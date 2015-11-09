
class @Maslosoft.AweShare

	#
	# Share container
	# @var jQuery
	#
	element: ''

	constructor: (element) ->

		@element = jQuery element
		
		data = @element.data()

		# Get services from element
		if data.services
			data.services = data.services.replace(/\s*/g, '').split ','
		else
			data.services = []

		# Use all services if not defined on element
		if not data.services.length
			for name, adapter of Maslosoft.AweShare.Adapters
				data.services.push @decamelize(name)

		# Check if has adapter and instantiate if possible
		adapters = {}
		for index, name of data.services
			adapterName = @camelize name

			# Check if adapter is method
			if typeof(Maslosoft.AweShare.Adapters[adapterName]) is 'function'
				adapters[name] = Maslosoft.AweShare.Adapters[adapterName]
			else
				console.warn "No adapter for #{name} in", element, (new Error).stack
				data.services.splice(index, 1)

		new Maslosoft.AweShare.Renderer @, data, adapters

		console.log data.services

	#
	#
	#
	#
	decamelize: (text, sep = '-') ->
		text.replace /([a-z\d])([A-Z])/g, '$1' + sep + '$2'
		.replace new RegExp('(' + sep + '[A-Z])([A-Z])', 'g'), '$1' + sep + '$2'
		.toLowerCase()
		

	camelize: (text) ->
		return text.replace /(?:^|[-_])(\w)/g, (_, c) ->
			if c then c.toUpperCase() else ''

	#
	# Auto init all sharers
	# @static
	#
	#
	@init = () ->
		jQuery('.awe-share').each (id, element) ->
			new window.Maslosoft.AweShare element