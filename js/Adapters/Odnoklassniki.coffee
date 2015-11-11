
class @Maslosoft.AweShare.Adapters.Odnoklassniki extends @Maslosoft.AweShare.Adapter

	@label = "Share on Odnoklassniki.ru"
	
	count: (callback) ->
		$.getScript "http://www.odnoklassniki.ru/dk?st.cmd=extLike&ref=#{@url}"
		.fail () ->
			callback 0
		
		if !window.ODKL
			window.ODKL = {}
		
		window.ODKL.updateCount = (id, shares) =>
			callback shares
	
	decorate: (window) ->
		window.url = "http://www.odnoklassniki.ru/dk?st.cmd=addShare&st._surl=#{@url}&title=#{window.title}" 