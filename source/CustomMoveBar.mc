using Toybox.WatchUi;

class CustomMoveBar extends WatchUi.Drawable {

	function initialize(args) {
		WatchUi.Drawable.initialize(args);
	}

    function draw(dc) {
    	System.println("CustomMoveBar.draw()");
    	dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(120,120,30);
    }
}