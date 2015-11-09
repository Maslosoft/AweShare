
class @Maslosoft.AweShare.Adapters.Facebook extends @Maslosoft.AweShare.Adapter

	count: () ->
		shares = undefined
		$.getJSON 'http://graph.facebook.com/?callback=?&ids=' + url, (data) ->
			shares = data[url].shares or 0
			if shares > 0 or z == 1
				el.find('a[data-count="fb"]').after '<span class="share42-counter">' + shares + '</span>'
			return
		return