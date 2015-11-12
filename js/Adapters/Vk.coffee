
class @Maslosoft.AweShare.Adapters.Vk extends @Maslosoft.AweShare.Adapter

	@label = "Share on VK"
	
	count: (callback) ->
		$.getScript "http://vk.com/share.php?act=count&index=&url=#{@url}"
		.fail () ->
			callback 0
		if !window.VK
			window.VK = {}
		window.VK.Share = count: (id, shares) =>
			callback shares
			
	decorate: (window) ->
		window.url = "http://vk.com/share.php?url=#{@url}&title=#{window.title}&image=#{@image}&description=#{window.description}"
		window.width = 655
		window.height = 429