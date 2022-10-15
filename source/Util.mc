using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.Math;

class Util {
	private static const refWidth = 240;
	private static const refHeight = 240;

	public static function transformPolygonRound(points, cx, cy, sinA, cosA) {
    	var newPoints = [];
        for (var i = 0; i < points.size(); i++) {
        	var newPoint = transformRound(points[i], cx, cy, sinA, cosA);
    		newPoints.add(newPoint);
    	}
    	return newPoints;
    }
    
    public static function transformPolygon(points, cx, cy, sinA, cosA) {
    	var newPoints = [];
        for (var i = 0; i < points.size(); i++) {
        	var newPoint = transform(points[i], cx, cy, sinA, cosA);
    		newPoints.add(newPoint);
    	}
    	return newPoints;
    }
    
    public static function transformRound(point, cx, cy, sinA, cosA) {
    	var newX = cx - point[0] * cosA - point[1] * sinA;
    	var newY = cy + point[1] * cosA - point[0] * sinA;
    	return [Math.round(newX), Math.round(newY)];
    }
    
    public static function transform(point, cx, cy, sinA, cosA) {
    	var newX = cx - point[0] * cosA - point[1] * sinA;
    	var newY = cy + point[1] * cosA - point[0] * sinA;
    	return [newX, newY];
    }
    
    public static function drawPolygon(dc, points) {
    	if (points.size() > 2)
    	{
	    	for (var i = 0; i < points.size(); i++) {
	    		if (i + 1 < points.size()) {
	    			dc.drawLine(points[i][0], points[i][1], points[i+1][0], points[i+1][1]);
	    		} else {
	    			dc.drawLine(points[i][0], points[i][1], points[0][0], points[0][1]);
	    		}
	    	}
    	} else if (points.size() == 2) {
    		dc.drawLine(points[0][0],points[0][1],points[1][0],points[1][1]);
    	} else if (points.size() == 1) {
    		dc.drawPoint(points[0][0],points[0][1]);
    	}
    }
    
    public static function getCurrentDay() {
    	var date = new Time.Moment(Time.today().value());
		var gregorianDate = Time.Gregorian.info(date, Time.FORMAT_MEDIUM);
		return gregorianDate.day;
    }
    
    // returns array [handColor, handEdgeColor, handShadowColor]
    public static function getHandColors(bgColor) {
        if (getLuma(bgColor) < 100) {
    		// bg is dark
	        return [0xFFFFFF,0x303030,0x202020];
	    } else {
	    	//bg is light
	        return [0x000000,Graphics.COLOR_TRANSPARENT,darkerColor(bgColor)];
	    }
    }
    
    public static function norm(number, actualWidth, actualHeight) {
    	if (actualWidth > actualHeight) {
    		return number.toFloat() * actualHeight / refHeight;
    	} else {
    		return number.toFloat() * actualWidth / refWidth;
    	}
    }
    
    public static function normPt(point, actualWidth, actualHeight) {
		var x = point[0].toFloat() * actualWidth / refWidth;
		var y = point[1].toFloat() * actualHeight / refHeight;
		return [x, y];
    }
    
    public static function normPts(points, actualWidth, actualHeight) {
    	var newPoints = [];
        for (var i = 0; i < points.size(); i++) {
        	newPoints.add(normPt(points[i], actualWidth, actualHeight));
    	}
    	return newPoints;
    }
    
    // Compute a bounding box from the passed in points
    public static function getBoundingBox( points ) {
        var min = [9999,9999];
        var max = [0,0];

        for (var i = 0; i < points.size(); ++i) {
            if(points[i][0] < min[0]) {
                min[0] = points[i][0];
            }

            if(points[i][1] < min[1]) {
                min[1] = points[i][1];
            }

            if(points[i][0] > max[0]) {
                max[0] = points[i][0];
            }

            if(points[i][1] > max[1]) {
                max[1] = points[i][1];
            }
        }
        var width = max[0] - min[0] + 1;
        var height = max[1] - min[1] + 1;
        return [min, max, [width, height]];
    }
}