
class @Maslosoft.AweShare.Adapters.Linkedin extends @Maslosoft.AweShare.Adapter

	@label = "Share on Linkedin"
	
	count: (callback) ->
		$.getJSON "http://www.linkedin.com/countserv/count/share?callback=?&url=#{@url}", (data) =>
			shares = data.count
			callback shares
		.fail () ->
			callback 0
		  
	decorate: (window) ->
		window.url = "http://www.linkedin.com/shareArticle?mini=true&url=#{@url}&title=#{window.title}"