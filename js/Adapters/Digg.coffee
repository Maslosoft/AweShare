
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