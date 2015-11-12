
class @Maslosoft.AweShare.Adapters.Twitter extends @Maslosoft.AweShare.Adapter

	@label = "Tweet It"
	
	count: (callback) ->
		$.getJSON "http://urls.api.twitter.com/1/urls/count.json?&url=#{@url}&callback=?", (data) ->
			shares = data.count
			callback shares
		.fail () ->
			callback 0
		
	decorate: (window) ->
		window.url = "https://twitter.com/intent/tweet?text=#{window.title}&url=#{@url}"
		window.width = 480
		window.height = 280