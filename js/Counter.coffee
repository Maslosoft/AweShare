
counterCache = {}

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
			# Pre set cache value to 0 in case of api errors
			if not counterCache[@name]
				counterCache[@name] = {}
			counterCache[@name][@adapter.url] = 0
			
			# Run adapter defined count and call counter callback
			@adapter.count @setCount
		
	setCount: (number) =>
		counterCache[@name][@adapter.url] = parseInt(number)
		@callback @name, parseInt(number)