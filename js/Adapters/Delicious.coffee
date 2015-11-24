
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