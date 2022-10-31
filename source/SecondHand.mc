using Toybox.Graphics;
using Toybox.Application;

class SecondHand {
	private var sinA;
	private var cosA;
	private var scp;    
	
	private static var handColor = Application.getApp().getProperty("AccentColor");
	private static var noHarborColor = ColorUtil.darkerColor(Graphics.COLOR_WHITE);
   
//   	private var line = [[0,35],[0,-100]];
//   	private var box = [[-4, 40],[-4,-100],[4,-100],[4,40]];
   	private var line = [[0,20],[0,-98]];
   	private var box = [[-4, 20],[-4,-98],[4,-98],[4,20]];
   	private var harborSize = 5;
   	private var tipSize = 4;

   	private var transformedLine = line;
   	private var transformedBox = box;
   	
	function initialize(width, height) {
		line = Util.normPts(line, width, height);
		box = Util.normPts(box, width, height);
		harborSize = Util.norm(harborSize, width, height);
		tipSize = Util.norm(tipSize, width, height);
	}
		
	public function set(angle) {
		sinA = Math.sin(angle);
   		cosA = Math.cos(angle);
   		transformedLine = Util.transformPolygonRound(line, centerPoint[0], centerPoint[1], sinA, cosA);
   		transformedBox = Util.transformPolygon(box, centerPoint[0], centerPoint[1], sinA, cosA);
	}
		
	public function getBox() {
   		return transformedBox;
	}

   	public function draw(dc) {
    	dc.setColor(handColor, Graphics.COLOR_TRANSPARENT);
    	dc.setPenWidth(3);
    	dc.drawLine(transformedLine[0][0],transformedLine[0][1],transformedLine[1][0],transformedLine[1][1]);
//    	dc.fillCircle(transformedLine[0][0],transformedLine[0][1], tipSize);
   	}
   	
   	public function drawHarbor(dc) {
    	dc.setColor(handColor, Graphics.COLOR_TRANSPARENT);
    	dc.fillCircle(centerPoint[0], centerPoint[1], harborSize);
   	}

	public function drawNoHarbor(dc) {
    	dc.setColor(noHarborColor, Graphics.COLOR_TRANSPARENT);
    	dc.fillCircle(centerPoint[0], centerPoint[1], harborSize/2);
   	}
   	
   	public static function refreshColors() {
   		handColor = Application.getApp().getProperty("AccentColor");
   	}
}