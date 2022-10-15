using Toybox.Graphics;

class ColorUtil {

	public static function getLuma(color) {
		var r = (color >> 16) & 0xff;  // extract red
		var g = (color >>  8) & 0xff;  // extract green
		var b = (color >>  0) & 0xff;  // extract blue
		
		return 0.2126 * r + 0.7152 * g + 0.0722 * b; // per ITU-R BT.709
    }
    
    public static function darkerColor(color) {
    	return (color & 0xFEFEFE) >> 1;
    }
}