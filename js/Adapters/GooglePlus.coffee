
class @Maslosoft.AweShare.Adapters.GooglePlus extends @Maslosoft.AweShare.Adapter

	@label = "Share on Google+"

	count: (callback) ->
		if not window.services
			window.services = {}
		if not window.services.gplus
			window.services.gplus = {}

		window.services.gplus.cb = (shares) =>
			callback shares

		$.getScript "http://share.yandex.ru/gpp.xml?url=#{@url}"
		.fail () ->
			callback 0

	#
	#
	#
	# @var window Maslosoft.AweShare.Window
	#
	decorate: (window) ->
		window.url = "https://plus.google.com/share?url=#{@url}"
		window.width = 490
		window.height = 460