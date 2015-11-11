
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