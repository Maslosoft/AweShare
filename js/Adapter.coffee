
# Init adapters ns
@Maslosoft.AweShare.Adapters = {}

class @Maslosoft.AweShare.Adapter

	id: null

	url: ''

	image: ''

	data: null

	count: (callback) ->
		callback(0)

	decorate: (window) ->
		window.url = '#not implemented'

	setId: (@id) ->

	getId: () ->
		return @id

	setImage: (@image) ->

	setData: (@data) ->

	setUrl: (url) ->
		url = url.toString()
		# Remove hash if present
		if url.indexOf "#"
			@url = url.split("#")[0]
		else
			@url = url
