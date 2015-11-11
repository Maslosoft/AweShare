
class @Maslosoft.AweShare.Adapters.Delicious extends @Maslosoft.AweShare.Adapter

	@label = "Save to Delicious"
	
	count: (callback) ->
		$.getJSON "http://feeds.delicious.com/v2/json/urlinfo/data?url=#{@url}&callback=?", (data) =>
			shares = if data[0] then data[0].total_posts else 0
			callback shares
		.fail () ->
			callback 0
	
	decorate: (window) ->
		window.url = "http://delicious.com/save?url=#{@url}&title=#{window.title}&note=#{window.description}"