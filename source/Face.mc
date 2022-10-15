using Toybox.Graphics;
using Toybox.Application;
using Toybox.WatchUi;

class Face {
	var bitmap;
	var size;
	var currentDay;
	
	var bgColor = Graphics.COLOR_BLACK;
	var ticksColor = Graphics.COLOR_WHITE;
	var marksColor = Application.getApp().getProperty("MarksColor");
	var accentColor = Application.getApp().getProperty("AccentColor");
	
	var mark = [[-4,-114],[-4,-118],[4,-118],[4,-114]];
	var bigLabel = [0, -90];
	var smallLabel = [0, -70];
	var tick = [[0,-107],[0,-120]];
	
	var radioRad = 10;
    var radioPoint = [150, 106];
	var h3Coord = [85, 90];
	
	var dayWindowMask = [[180, 105], [220,105], [220, 135], [180, 135]];
    var dayWindow = [[187, 109], [215,109], [215, 131], [187, 131]];
    var dayWindowShadow = [[189, 111], [214,111], [214, 130], [189, 130]];
    var dayPoint = [201, 120];
	
    var zzzSmall = Application.loadResource(Rez.Fonts.ZzzSmall);
    var zzzMedium = Application.loadResource(Rez.Fonts.ZzzMedium);
    var zzzDate = Application.loadResource(Rez.Fonts.ZzzDate);
    var zzzH3 = Application.loadResource(Rez.Fonts.ZzzH3);
    
    function initialize(width, height) {
    	size = [width, height];
    	mark = Util.normPts(mark, width, height);
    	bigLabel = Util.normPt(bigLabel, width, height);
    	smallLabel = Util.normPt(smallLabel, width, height);
    	tick = Util.normPts(tick, width, height);
    	radioPoint = Util.normPt(radioPoint, width, height);
    	radioRad = Util.norm(radioRad, width, height);
    	h3Coord = Util.normPt(h3Coord, width, height);
    	dayWindowMask = Util.normPts(dayWindowMask, width, height);
    	dayWindow = Util.normPts(dayWindow, width, height);
    	dayWindowShadow = Util.normPts(dayWindowShadow, width, height);
    	dayPoint = Util.normPt(dayPoint, width, height);
    }
    
    function draw(dc) {
    	dc.setColor(bgColor,bgColor);
    	dc.clear();
    	drawH3(dc);
        drawRadioactive(dc);
        drawTicks(dc);
        drawDate(dc);
    }

	private function drawTicks(dc) {
    	var label = 12;
    	for (var i = 0; i < 60; i++) {
    		var ang = i.toFloat() / 60 * 2 * Math.PI;
    		
    		var sinA = Math.sin(ang);
    		var cosA = Math.cos(ang);
    		
    		if (i % 5 == 0) {
    			drawMark(dc, label, sinA, cosA);
    			drawLabel(dc, label, zzzMedium, ticksColor, sinA, cosA, bigLabel);
    			drawLabel(dc, label + 12, zzzSmall, ticksColor, sinA, cosA, smallLabel);
    			label = label + 1;
    			if (label > 12) {
    				label = 1;
    			}
    		} else {
    			drawTick(dc, sinA, cosA);
    		}
    	}
    }
    
    private function drawMark(dc, label, sinA, cosA) {
    	dc.setPenWidth(1);
		if (sinA == 0) {
			// 12 o'clock
			dc.setColor(accentColor, Graphics.COLOR_TRANSPARENT);
			var transformedMark = Util.transformPolygon(mark, centerPoint[0], centerPoint[1], sinA, cosA);
			dc.fillPolygon(transformedMark);
		} else {
			// others
			dc.setColor(marksColor, Graphics.COLOR_TRANSPARENT);
			var transformedMark = Util.transformPolygon(mark, centerPoint[0], centerPoint[1], sinA, cosA);
			dc.fillPolygon(transformedMark);
		}
    }
    
    private function drawLabel(dc, label, font, color, sinA, cosA, point) {
		dc.setColor(color, Graphics.COLOR_TRANSPARENT);
		var fontHeight = Graphics.getFontHeight(font);
		var transformedPoint = Util.transform([point[0],point[1]], centerPoint[0], centerPoint[1] - fontHeight / 2, sinA, cosA);
		dc.drawText(transformedPoint[0], transformedPoint[1], font, label + "", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    private function drawTick(dc, sinA, cosA) {
    	dc.setColor(ticksColor, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(2);
    	var transformedTick = Util.transformPolygon(tick, centerPoint[0], centerPoint[1], sinA, cosA);
    	Util.drawPolygon(dc, transformedTick);
    }
    
    private function drawH3(dc) {
        dc.setColor(ticksColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(h3Coord[0], h3Coord[1], zzzH3, "H3", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    private function drawRadioactive(dc) {
		dc.setColor(ticksColor, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(2);
		dc.fillCircle(radioPoint[0], radioPoint[1], radioRad);
		
		var side = radioRad.toFloat() * 1.3;
		
		dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
		dc.fillPolygon([[radioPoint[0],radioPoint[1]],[radioPoint[0]+side, radioPoint[1]],[radioPoint[0]+side/2,radioPoint[1]+side]]);
		dc.fillPolygon([[radioPoint[0],radioPoint[1]],[radioPoint[0]-side, radioPoint[1]],[radioPoint[0]-side/2,radioPoint[1]+side]]);
		dc.fillPolygon([[radioPoint[0],radioPoint[1]],[radioPoint[0]-side/2, radioPoint[1]-side],[radioPoint[0]+side/2,radioPoint[1]-side]]);
		
		dc.setColor(ticksColor, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(radioPoint[0], radioPoint[1], 3);
		
		dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(1);
		dc.drawCircle(radioPoint[0], radioPoint[1], 3);
    }
    
    private function drawDate(dc) {
    	currentDay = Util.getCurrentDay();
        dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
    	dc.fillPolygon(dayWindowMask);
    	dc.setColor(ticksColor, Graphics.COLOR_TRANSPARENT);
    	dc.fillPolygon(dayWindow);
    	dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
    	Util.drawPolygon(dc, dayWindowShadow);
		dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
    	dc.drawText(dayPoint[0], dayPoint[1] - Graphics.getFontHeight(zzzDate)/2, zzzDate, currentDay, Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function getAsBitmap() {
    	if (bitmap == null) {
    		bitmap = new Graphics.BufferedBitmap({
                :width=>size[0],
                :height=>size[1],
                :palette=> [
					bgColor,
					ticksColor,
					marksColor,
					accentColor
		        ]
            });
            draw(bitmap.getDc());
    	} else if (currentDay != Util.getCurrentDay()) {
    		draw(bitmap.getDc());
    	}
    	return bitmap;
    }
    
    public static function refreshColors() {
    	marksColor = Application.getApp().getProperty("MarksColor");
		accentColor = Application.getApp().getProperty("AccentColor");
    	bitmap.setPalette([
			bgColor,
			ticksColor,
			marksColor,
			accentColor
	    ]);
		draw(bitmap.getDc());
    }
}