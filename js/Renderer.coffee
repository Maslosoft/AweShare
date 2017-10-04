
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

	empty: ''

	#
	#
	#
	# @var object
	#
	window: null

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
		@empty = @data.counterEmpty

		@window = jQuery window
		
		# Remove everything inside element
		@sharer.element.html('')

		# Shortcut for pin top
		if typeof(@data.pin) is 'number'
			@data.pinTop = @data.pin

		# By default is pinned statically
		if typeof(@data.pinScroll) is 'undefined'
			@data.pinScroll = @data.pinTop

		# Pin option
		if @data.pinTop

			# Setup classes according to pin options
			@sharer.element.addClass 'awe-share-pin'
			if not @data.pinPosition or @data.pinPosition is 'left'
				@sharer.element.addClass 'awe-share-pin-left'
			if @data.pinPosition is 'right'
				@sharer.element.addClass 'awe-share-pin-right'

			# Recalculate position
			@onScroll()

			# Attach scroll event if is scroll position dependent
			if @data.pinScroll != @data.pinTop
				jQuery(window).scroll @onScroll

		# Tooltip option (bootstrap only)
		if @data.tip and typeof(jQuery.fn.tooltip) is 'function'

			placement = 'top'

			# Reconfigure placement
			if @sharer.element.hasClass 'awe-share-pin-left'
				placement = 'right'

			if @sharer.element.hasClass 'awe-share-pin-right'
				placement = 'left'

			# Ovverride if custom
			if typeof(@data.tip) is 'string'
				placement = @data.tip

			# Apply only to selected sharers
			id = @sharer.element.attr('id')
			selector = " a"
			console.log selector
			jQuery("##{id}").tooltip({
				selector: 'a'
				placement: placement
			});

		for name, adapter of @adapters
			@render name, adapter

	#
	# Scroll handler for pinned sharerers
	#
	#
	#
	onScroll: () =>
		top = @window.scrollTop()
		if top + @data.pinScroll < @data.pinTop
			@sharer.element.css top: @data.pinTop - top
		else
			@sharer.element.css top: @data.pinScroll
		return

	#
	#
	# @param string
	# @param Maslosoft.AweShare.Adapter
	#
	render: (name, adapter) ->
		window = @sharer.windows[name]
		adapterName = @sharer.camelize name
		label = Maslosoft.AweShare.Adapters[adapterName].label
		link = jQuery """
		<a href="#{window.url}" data-service="#{name}" class="awe-share-brand-#{name}" title="#{label}">
			<i class='fa fa-2x fa-#{name}'></i>
		</a>
		"""
		
		@sharer.element.append link
		
		if @data.counter
			link.append """<span class="awe-share-counter">#{@empty}</span>"""
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
		if value is 0
			value = @empty
		@sharer.element.find("a[data-service=#{name}]").find('.awe-share-counter').html(value)