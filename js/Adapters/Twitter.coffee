
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
		if @data.tags.length
			window.url = "#{window.url}&hashtags=#{@data.tags.join(',')}"

		via = ''
		if @data.twitterBy
			via = @data.twitterBy

		if @data.twitterVia
			via = @data.twitterVia

		if via
			window.url = "#{window.url}&via=#{via}"

		window.width = 480
		window.height = 280