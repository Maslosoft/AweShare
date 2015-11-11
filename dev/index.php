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
		<h4>Horizontal</h4>
		<div class="awe-share" data-url="http://stackoverflow.com/"></div>
		<h4>Selected services and no counter</h4>
		<div class="awe-share" data-counter="false" data-services=" facebook,  twitter, google-plus ,github  "></div>
		<h4>Brand background</h4>
		<div class="awe-share awe-share-brand-bg" data-url="http://google.com/"></div>
		<h4>Brand background on hover</h4>
		<div class="awe-share awe-share-brand-bg-hover"></div>
		<h4>Brand background with hover foreground</h4>
		<div class="awe-share awe-share-brand-bg awe-share-brand-fg-hover"></div>

		<h4>Brand foreground</h4>
		<div class="awe-share awe-share-brand-fg"></div>
		<h4>Brand foreground on hover</h4>
		<div class="awe-share awe-share-brand-fg-hover"></div>
		<h4>Brand foreground with hover background</h4>
		<div class="awe-share awe-share-brand-fg awe-share-brand-bg-hover"></div>
	</div>
</div>
<div class="row">
	<div class="col-md-2">
		<h4>Vertical</h4>
		<div class="awe-share awe-share-vertical"></div>
	</div>
	<div class="col-md-2">
		<h4>Vertical brand background</h4>
		<div class="awe-share awe-share-vertical awe-share-brand-bg"></div>
	</div>
</div>
</p>

<div id="log">

</div>

<?php
require '_footer.php'
?>
