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
<div class="row">
	<div class="col-md-12">
		<h4>Horizontal (http://stackoverflow.com/) empty counter placeholder</h4>
		<div class="awe-share" data-url="http://stackoverflow.com/" data-counter-empty="&#9787;"></div>
		<h4>Selected services and no counter</h4>
		<div class="awe-share" data-counter="false" data-services=" facebook,  twitter, google-plus ,github  "></div>
		<h4>Brand background (http://google.com/)</h4>
		<div class="awe-share awe-share-brand-bg" data-url="http://google.com/"></div>
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
	</div>
</div>
<div class="row">
	<div class="col-sm-2">
		<h4>Vertical and no counter</h4>
		<div class="awe-share awe-share-vertical" data-counter="false"></div>
	</div>
	<div class="col-sm-2">
		<h4>Vertical brand background and no counter</h4>
		<div class="awe-share awe-share-vertical awe-share-brand-bg" data-counter="false"></div>
	</div>
	<div class="col-sm-2">
		<h4>Vertical brand background (http://facebook.com/)</h4>
		<div class="awe-share awe-share-vertical awe-share-brand-bg" data-url="http://facebook.com/"></div>
	</div>
</div>
</p>

<div id="log">

</div>

<?php
require '_footer.php'
?>
