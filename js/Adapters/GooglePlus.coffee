
class @Maslosoft.AweShare.Adapters.GooglePlus extends @Maslosoft.AweShare.Adapter

	@label = "Share on Google+"

	count: () ->
		if !window.services
			window.services = {}
			window.services.gplus = {}

		window.services.gplus.cb = (number) ->
			window.gplusShares = number
			return

		$.getScript 'http://share.yandex.ru/gpp.xml?url=' + @url, ->
			shares = window.gplusShares
			if shares > 0 or z == 1
				el.find('a[data-count="gplus"]').after '<span class="share42-counter">' + shares + '</span>'
			return
		return

	#
	#
	#
	# @var window Maslosoft.AweShare.Window
	#
	decorate: (window) ->