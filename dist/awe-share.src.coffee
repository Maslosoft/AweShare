
if !@Maslosoft
	@Maslosoft = {}
assert = (expr) ->
  if not console then return
  console.assert expr

log = (expr) ->
  if not console then return
  console.log expx


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

# Init adapters ns
@Maslosoft.AweShare.Adapters = {}

class @Maslosoft.AweShare.Adapter

	id: null

	url: ''

	image: ''

	count: (callback) ->
		callback(0)

	decorate: (window) ->
		window.url = '#not implemented'

	setId: (@id) ->

	getId: () ->
		return @id

	setImage: (@image) ->


	setUrl: (url) ->
		url = url.toString()
		# Remove hash if present
		if url.indexOf "#"
			@url = url.split("#")[0]
		else
			@url = url


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

class @Maslosoft.AweShare.Meta

	getName: (value) ->
		return @get 'name', value

	getProperty: (value) ->
		return @get 'property', value
	
	get: (type, value) ->
		for meta in document.getElementsByTagName 'meta'
			attr = null
			if meta
				attr = meta.getAttribute type
			if attr and attr.toLowerCase() is value.toLowerCase()
				return meta.getAttribute 'content'
		return ''

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


class @Maslosoft.AweShare.Adapters.Delicious extends @Maslosoft.AweShare.Adapter

	@label = "Save to Delicious"
	
	count: (callback) ->
		# Try this url:
		# md5 param is md5 sum of full url
		# https://avosapi.delicious.com/api/v1/posts/md5/6ab016b2dad7ba49a992ba0213a91cf8
		$.getJSON "http://feeds.delicious.com/v2/json/urlinfo/data?url=#{@url}&callback=?", (data) =>
			shares = if data[0] then data[0].total_posts else 0
			callback shares
		.fail () ->
			callback 0
	
	decorate: (window) ->
		window.url = "http://delicious.com/save?url=#{@url}&title=#{window.title}&note=#{window.description}"
		window.width = 710
		window.height = 660

class @Maslosoft.AweShare.Adapters.Digg extends @Maslosoft.AweShare.Adapter

	@label = "Submit to Digg"
	
	count: (callback) ->
		$.getJSON "http://services.digg.com/1.0/endpoint?method=story.getAll&link=#{@url}&type=javascript&callback=?", (data) =>
			shares = 0
			if data.stories and data.stories[0] and data.stories[0].diggs
				shares = data.stories[0].diggs
			callback shares
		.fail () ->
			callback 0
	
	decorate: (window) ->
		window.url = "http://digg.com/submit?url=#{@url}"
		window.width = 600
		window.height = 500

class @Maslosoft.AweShare.Adapters.Facebook extends @Maslosoft.AweShare.Adapter

	@label = "Share on Facebook"

	count: (callback) ->
		$.getJSON "http://graph.facebook.com/?callback=?&ids=#{@url}", (data) =>
			if not data[@url]
				data[@url] = {}
			shares = data[@url].shares or 0
			callback shares
		.fail () ->
			callback 0
		
	decorate: (window) ->
		window.url = "http://www.facebook.com/sharer.php?m2w&s=100&p[url]=#{@url}&p[title]=#{window.title}&p[summary]=#{window.description}&p[images][0]=#{@image}"
		window.width = 550
		window.height = 359

class @Maslosoft.AweShare.Adapters.GooglePlus extends @Maslosoft.AweShare.Adapter

	@label = "Share on Google+"

	count: (callback) ->
		if not window.services
			window.services = {}
		if not window.services.gplus
			window.services.gplus = {}

		window.services.gplus.cb = (shares) =>
			callback shares

		$.getScript "http://share.yandex.ru/gpp.xml?url=#{@url}"
		.fail () ->
			callback 0

	#
	#
	#
	# @var window Maslosoft.AweShare.Window
	#
	decorate: (window) ->
		window.url = "https://plus.google.com/share?url=#{@url}"
		window.width = 490
		window.height = 460

class @Maslosoft.AweShare.Adapters.Linkedin extends @Maslosoft.AweShare.Adapter

	@label = "Share on Linkedin"
	
	count: (callback) ->
		$.getJSON "http://www.linkedin.com/countserv/count/share?callback=?&url=#{@url}", (data) =>
			shares = data.count
			callback shares
		.fail () ->
			callback 0
		  
	decorate: (window) ->
		window.url = "http://www.linkedin.com/shareArticle?mini=true&url=#{@url}&title=#{window.title}"
		window.width = 600
		window.height = 600

class @Maslosoft.AweShare.Adapters.Odnoklassniki extends @Maslosoft.AweShare.Adapter

	@label = "Share on Odnoklassniki.ru"
	
	count: (callback) ->
		$.getScript "http://www.odnoklassniki.ru/dk?st.cmd=extLike&ref=#{@url}"
		.fail () ->
			callback 0
		
		if !window.ODKL
			window.ODKL = {}
		
		window.ODKL.updateCount = (id, shares) =>
			callback shares
	
	decorate: (window) ->
		window.url = "http://www.odnoklassniki.ru/dk?st.cmd=addShare&st._surl=#{@url}&title=#{window.title}"
		window.width = 600
		window.height = 500 

class @Maslosoft.AweShare.Adapters.Pinterest extends @Maslosoft.AweShare.Adapter

	@label = "Pin It"
	
	count: (callback) ->
		$.getJSON "http://api.pinterest.com/v1/urls/count.json?callback=?&url=#{@url}", (data) ->
			shares = data.count
			callback shares
		.fail () ->
			callback 0
		
	decorate: (window) ->
		window.url = "http://pinterest.com/pin/create/button/?url=#{@url}&media=#{@image}&description=#{window.title}"
		window.width = 770
		window.height = 760

class @Maslosoft.AweShare.Adapters.Reddit extends @Maslosoft.AweShare.Adapter

	@label = "Share on Reddit"
	
	decorate: (window) ->
		window.url = "http://reddit.com/submit?url=#{@url}&title=#{window.title}"
		window.width = 600
		window.height = 500

class @Maslosoft.AweShare.Adapters.Tumblr extends @Maslosoft.AweShare.Adapter

	@label = "Share on Tumblr"
	
	decorate: (window) ->
		window.url = "http://www.tumblr.com/share?v=3&u=#{@url}&t=#{window.title}&s=#{window.description}"
		window.width = 600
		window.height = 500

class @Maslosoft.AweShare.Adapters.Twitter extends @Maslosoft.AweShare.Adapter

	@label = "Tweet It"
	
	count: (callback) ->
		$.getJSON "http://urls.api.twitter.com/1/urls/count.json?&url=#{@url}&callback=?", (data) ->
			shares = data.count
			callback shares
		.fail () ->
			callback 0
		
	decorate: (window) ->
		title = encodeURIComponent(window.title)
		window.url = "https://twitter.com/intent/tweet?text=#{title}&url=#{@url}"
		window.width = 480
		window.height = 280

class @Maslosoft.AweShare.Adapters.Vk extends @Maslosoft.AweShare.Adapter

	@label = "Share on VK"
	
	count: (callback) ->
		$.getScript "http://vk.com/share.php?act=count&index=&url=#{@url}"
		.fail () ->
			callback 0
		if !window.VK
			window.VK = {}
		window.VK.Share = count: (id, shares) =>
			callback shares
			
	decorate: (window) ->
		window.url = "http://vk.com/share.php?url=#{@url}&title=#{window.title}&image=#{@image}&description=#{window.description}"
		window.width = 655
		window.height = 429


jQuery(document).ready ()->
	Maslosoft.AweShare.init()
