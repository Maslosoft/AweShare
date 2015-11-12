
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