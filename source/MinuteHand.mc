using Toybox.Graphics;
using Toybox.Application;

class MinuteHand {
	private var sinA;
	private var cosA;
	private var scp;  
	
	var handColor = Graphics.COLOR_WHITE;
	var handEdgeColor = ColorUtil.darkerColor(handColor);
	var accentColor = Application.getApp().getProperty("MarksColor");
	var accentShadowColor = ColorUtil.darkerColor(accentColor);

  	private var hand = [[-2,0],[-2,-15],[-6,-25],[-6, -80],[-2,-90],[-2,-98],[0,-100],[2,-98],[2,-90],[6,-80],[6,-25],[2,-15],[2,0]];
	private var handEdge = [[-3,0],[-3,-15],[-7,-25],[-7, -80],[-3,-90],[-3,-98],[0,-101],[3,-98],[3,-90],[7,-80],[7,-25],[3,-15],[3,0]];
	private var accent = [[-2,-25],[-2,-80],[2,-80],[2,-25]];
	private var accentShadow = [[-3,-24],[-3,-81],[3,-81],[3,-24]];
	private var harborSize = 6;
	private var harborEdgeSize = harborSize + 1;
	
	private var transformedHand;
	private var transformedHandEdge;
	private var transformedAccent;
	private var transformedAccentShadow;
	
	function initialize(width, height) {
		hand = Util.normPts(hand, width, height);
    	handEdge = Util.normPts(handEdge, width, height);
	   	accent = Util.normPts(accent, width, height);
	   	accentShadow = Util.normPts(accentShadow, width, height);
	   	harborSize = Util.norm(harborSize, width, height);
	   	harborEdgeSize = Util.norm(harborEdgeSize, width, height);
	}
	
	public function set(angle) {
		sinA = Math.sin(angle);
   		cosA = Math.cos(angle);
   		transformedHand = Util.transformPolygonRound(hand, centerPoint[0], centerPoint[1], sinA, cosA);
   		transformedHandEdge = Util.transformPolygonRound(handEdge, centerPoint[0], centerPoint[1], sinA, cosA);
   		transformedAccent = Util.transformPolygonRound(accent, centerPoint[0], centerPoint[1], sinA, cosA);
   		transformedAccentShadow = Util.transformPolygonRound(accentShadow, centerPoint[0], centerPoint[1], sinA, cosA);
	}

   	public function draw(dc) {
    	dc.setColor(handEdgeColor, Graphics.COLOR_TRANSPARENT);
    	dc.fillPolygon(transformedHandEdge);
    	dc.fillCircle(centerPoint[0], centerPoint[1], harborEdgeSize);
    	
    	dc.setColor(handColor, Graphics.COLOR_TRANSPARENT);
    	dc.fillPolygon(transformedHand);
    	dc.fillCircle(centerPoint[0], centerPoint[1], harborSize);
    	
    	dc.setColor(accentShadowColor, Graphics.COLOR_TRANSPARENT);
    	dc.fillPolygon(transformedAccentShadow);
    		
    	dc.setColor(accentColor, Graphics.COLOR_TRANSPARENT);
   		dc.fillPolygon(transformedAccent);
   	}
   	
   	public static function refreshColors() {
   		accentColor = Application.getApp().getProperty("MarksColor");
		accentShadowColor = ColorUtil.darkerColor(accentColor);
   	}
}