using Toybox.Graphics;
using Toybox.Application;

class Battery {
	var batteryLevel = 0;
	const batteryColor = Graphics.COLOR_WHITE;
	const lowBatteryColor = Graphics.COLOR_DK_GRAY;
	
	var batteryCoord = [150,106];
	var batteryRad = 14;
	
	function initialize(width, height) {
    	batteryCoord = Util.normPt(batteryCoord, width, height);
    	batteryRad = Util.norm(batteryRad, width, height);
	}
	
	function draw(dc, batteryLevel) {
		dc.setPenWidth(3);
		dc.setColor(lowBatteryColor, Graphics.COLOR_TRANSPARENT);
		dc.drawCircle(batteryCoord[0], batteryCoord[1], batteryRad);
		dc.setColor(batteryColor, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(batteryCoord[0], batteryCoord[1], batteryRad, Graphics.ARC_COUNTER_CLOCKWISE, 90, 90 + 360 * batteryLevel / 100);
		dc.setPenWidth(1);
	}
}