
if !@Maslosoft
	@Maslosoft = {}

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

# Init adapters ns
@Maslosoft.AweShare.Adapters = {}

class @Maslosoft.AweShare.Adapter

	url: ''

	setUrl: (@url) ->


class @Maslosoft.AweShare.Renderer

	constructor: (@sharer, @data, @adapters) ->

		for name, adapter of @adapters
			@render name, adapter

	render: (name, adapter) ->
		@sharer.element.append """
		<a href="" class="awe-share-brand-#{name}">
			<i class='fa fa-2x fa-#{name}'></i>
		</a>
		"""


class @Maslosoft.AweShare.Adapters.Delicious extends @Maslosoft.AweShare.Adapter

	@label = "Save to Delicious"

class @Maslosoft.AweShare.Adapters.Digg extends @Maslosoft.AweShare.Adapter

	@label = "Submit to Digg"

class @Maslosoft.AweShare.Adapters.Facebook extends @Maslosoft.AweShare.Adapter

	@label = "Share on Facebook"

	count: () ->
		shares = undefined
		$.getJSON 'http://graph.facebook.com/?callback=?&ids=' + url, (data) ->
			shares = data[url].shares or 0
			if shares > 0 or z == 1
				el.find('a[data-count="fb"]').after '<span class="share42-counter">' + shares + '</span>'
			return
		return

class @Maslosoft.AweShare.Adapters.GooglePlus extends @Maslosoft.AweShare.Adapter

	@label = "Share on Google+"

	count: () ->
		if !window.services
			window.services = {}
			window.services.gplus = {}

		window.services.gplus.cb = (number) ->
			window.gplusShares = number
			return

		$.getScript 'http://share.yandex.ru/gpp.xml?url=' + @url, ->
			shares = window.gplusShares
			if shares > 0 or z == 1
				el.find('a[data-count="gplus"]').after '<span class="share42-counter">' + shares + '</span>'
			return
		return

	#
	#
	#
	# @var window Maslosoft.AweShare.Window
	#
	decorate: (window) ->

class @Maslosoft.AweShare.Adapters.Linkedin extends @Maslosoft.AweShare.Adapter

	@label = "Share on Linkedin"

class @Maslosoft.AweShare.Adapters.Pinterest extends @Maslosoft.AweShare.Adapter

	@label = "Pin It"

class @Maslosoft.AweShare.Adapters.Reddit extends @Maslosoft.AweShare.Adapter

	@label = "Share on Reddit"

class @Maslosoft.AweShare.Adapters.Tumblr extends @Maslosoft.AweShare.Adapter

	@label = "Share on Tumblr"

class @Maslosoft.AweShare.Adapters.Twitter extends @Maslosoft.AweShare.Adapter

	@label = "Tweet It"

class @Maslosoft.AweShare.Adapters.Vk extends @Maslosoft.AweShare.Adapter


	@label = "Share on VK"


jQuery(document).ready ()->
	Maslosoft.AweShare.init()
