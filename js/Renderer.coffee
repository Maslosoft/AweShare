
class @Maslosoft.AweShare.Renderer

	constructor: (@sharer, @data, @adapters) ->

		for name, adapter of @adapters
			@render name, adapter

	render: (name, adapter) ->
		@sharer.element.append """
		<a href="" class="awe-share-brand-#{name}">
			<i class='fa fa-2x fa-#{name}'></i>
		</a>
		"""
