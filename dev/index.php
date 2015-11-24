<?php
require '_header.php'
?>
<div class="row">
	<div class="col-md-12">
		<h1>
			Awe Share Demo
		</h1>
	</div>
</div>
<!--Pinned-->
<div class="awe-share awe-share-vertical" data-pin="220" data-tip="true" data-counter="false"></div>
<div class="awe-share awe-share-vertical" data-pin="220" data-pin-scroll="10" data-pin-position="right" data-tip="true" data-counter="false"></div>
<!--Pad a bit to not overlapse pinned sharer over others-->
<div style="padding: 0px 36px;">
	<div class="row">
		<div class="col-xs-1">
		</div>
		<div class="col-md-11">
			<h4>Horizontal (http://stackoverflow.com/) and empty counter placeholder and tooltips</h4>
			<div class="awe-share" data-url="http://stackoverflow.com/" data-counter-empty="&#9787;" data-tip="true"></div>
			<h4>Selected services and no counter and tip on bottom</h4>
			<div class="awe-share" data-counter="false" data-tip="bottom" data-services=" facebook,  twitter, google-plus ,github  "></div>
			<h4>Brand background (http://google.com/) and collapse empty</h4>
			<div class="awe-share awe-share-brand-bg awe-share-collapse-empty" data-url="http://google.com/"></div>
			<h4>Brand background on hover</h4>
			<div class="awe-share awe-share-brand-bg-hover"></div>
			<h4>Brand background with hover foreground (http://deviantart.com/)</h4>
			<div class="awe-share awe-share-brand-bg awe-share-brand-fg-hover" data-url="http://deviantart.com/"></div>

			<h4>Brand foreground</h4>
			<div class="awe-share awe-share-brand-fg"></div>
			<h4>Brand foreground on hover</h4>
			<div class="awe-share awe-share-brand-fg-hover"></div>
			<h4>Brand foreground with hover background (http://facebook.com/)</h4>
			<div class="awe-share awe-share-brand-fg awe-share-brand-bg-hover" data-url="http://facebook.com/"></div>
			<h4>Brand foreground with hover background (http://facebook.com/) smaller</h4>
			<div class="awe-share awe-share-brand-fg awe-share-brand-bg-hover" style="font-size: .8em;" data-url="http://facebook.com/"></div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-2">
			<h4>Vertical and no counter</h4>
		</div>
		<div class="col-sm-2">
			<h4>Vertical brand background and no counter</h4>
		</div>
		<div class="col-sm-2">
			<h4>Vertical brand background (http://facebook.com/)</h4>
		</div>
		<div class="col-sm-2">
			<h4>Vertical brand background (http://facebook.com/) and collapse empty</h4>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-2">
			<div class="awe-share awe-share-vertical" data-counter="false"></div>
		</div>
		<div class="col-sm-2">
			<div class="awe-share awe-share-vertical awe-share-brand-bg" data-counter="false"></div>
		</div>
		<div class="col-sm-2">
			<div class="awe-share awe-share-vertical awe-share-brand-bg" data-url="http://facebook.com/"></div>
		</div>
		<div class="col-sm-2">
			<div class="awe-share awe-share-vertical awe-share-brand-bg awe-share-collapse-empty" data-url="http://facebook.com/"></div>
		</div>
	</div>
</div>
</p>

<div id="log">

</div>

<?php
require '_footer.php'
?>
