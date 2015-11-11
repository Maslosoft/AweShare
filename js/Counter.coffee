
counterCache = {}
callbackCache = {}
#
# Cached counter class
#
#
#
class @Maslosoft.AweShare.Counter

	#
	# Adapter
	#
	# @var Maslosoft.AweShare.Adapter
	#
	adapter: {}
	
	#
	# Service name
	#
	# @var string
	#
	name: ''
	
	#
	# Callback to perform after count
	#
	# @var Function
	#
	callback: {}

	#
	#
	# @param Maslosoft.AweShare.Adapter
	# @param string Service name
	# @param Function Callback to call after count
	#
	constructor: (@name, adapter, callback) ->
		# Ensure proper instances	
		@adapter = {}
		@callback = {}
		
		@adapter = adapter
		@callback = callback
		
		
	count: () =>
		if counterCache[@name] && typeof(counterCache[@name][@adapter.url]) is 'number'
			@callback @name, counterCache[@name][@adapter.url]
		else
			if not counterCache[@name]
				counterCache[@name] = {}
			if not callbackCache[@name]
				callbackCache[@name] = {}
			if not callbackCache[@name][@adapter.url]
			
				# Run adapter defined count and call counter callback
				@adapter.count @setCount
				callbackCache[@name][@adapter.url] = []
			else
				callbackCache[@name][@adapter.url].push @callback
		
	setCount: (number) =>
		# "Cache store for: ", @name, @adapter.url, counterCache[@name][@adapter.url]
		counterCache[@name][@adapter.url] = parseInt(number)
		@callback @name, parseInt(number)
		# Call cached callbacks
		if callbackCache[@name] and callbackCache[@name][@adapter.url]
			for callback in callbackCache[@name][@adapter.url]
				# Cached callback for: ", @name, @adapter.url
				callback @name, parseInt(number)