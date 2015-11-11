
class @Maslosoft.AweShare.Renderer

	#
	#
	#
	# @var Maslosoft.AweShare
	#
	sharer: {}
	
	#
	# Data from sharer
	#
	# @var object
	#
	data: {}

	#
	# Adapters array
	#
	# @var Maslosoft.AweShare.Adapter[]
	#
	adapters: {}

	#
	#
	# @param Maslosoft.AweShare
	# @param object
	# @param Maslosoft.AweShare.Adapter[]
	#
	constructor: (sharer, data, adapters) ->
		
		# Ensure proper instances
		@sharer = {}	
		@adapters = {}
		@data = {}
		
		@sharer = sharer
		@data = data
		@adapters = adapters

		for name, adapter of @adapters
			@render name, adapter

	#
	#
	# @param string
	# @param Maslosoft.AweShare.Adapter
	#
	render: (name, adapter) ->
		window = @sharer.windows[name]
		link = jQuery """
		<a href="#{window.url}" data-service="#{name}" class="awe-share-brand-#{name}" title="#{adapter.label}">
			<i class='fa fa-2x fa-#{name}'></i>
		</a>
		"""
		
		@sharer.element.append link
		
		if @data.counter
			link.append '<span class="awe-share-counter">0</span>'
			counter = new Maslosoft.AweShare.Counter(name, adapter, @setCounter)
			counter.count()
			
	humanize: (count) ->
		count = parseInt(count)
		thresh = 1000
		if Math.abs(count) < thresh
			return count
		units = [
			'k'
			'm'
			'g'
		]
		u = -1
		loop
			count /= thresh
			++u
			unless Math.abs(count) >= thresh and u < units.length - 1
				break
		count.toFixed() + units[u]
		
	setCounter: (name, value) =>
		value = @humanize value
		@sharer.element.find("a[data-service=#{name}]").find('.awe-share-counter').html(value)