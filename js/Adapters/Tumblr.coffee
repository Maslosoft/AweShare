
class @Maslosoft.AweShare.Adapters.Tumblr extends @Maslosoft.AweShare.Adapter

	@label = "Share on Tumblr"
	
	decorate: (window) ->
		window.url = "http://www.tumblr.com/share?v=3&u=#{@url}&t=#{window.title}&s=#{window.description}"