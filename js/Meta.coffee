
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