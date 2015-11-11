
class @Maslosoft.AweShare.Adapters.Reddit extends @Maslosoft.AweShare.Adapter

	@label = "Share on Reddit"
	
	decorate: (window) ->
		window.url = "http://reddit.com/submit?url=#{@url}&title=#{window.title}"