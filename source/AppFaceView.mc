using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;
using Toybox.Application;

var partialUpdatesAllowed = false;
var centerPoint;

class AppFaceView extends WatchUi.WatchFace {

	const PI = 3.1415926535;

    var isAwake;
    var offscreenBuffer;
    var curClip;
    var fullScreenRefresh;
    
    var battery;
    var secondHand;
    var minuteHand;
    var hourHand;
    var face;
    
    function initialize() {
        WatchFace.initialize();
        fullScreenRefresh = true;
        partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );
    }

    // Load your resources here
    function onLayout(dc) {
    	battery = new Battery(dc.getWidth(), dc.getHeight());
    	secondHand = new SecondHand(dc.getWidth(), dc.getHeight());
    	minuteHand = new MinuteHand(dc.getWidth(), dc.getHeight());
    	hourHand = new HourHand(dc.getWidth(), dc.getHeight());
    	face = new Face(dc.getWidth(), dc.getHeight());

        // If this device supports BufferedBitmap, allocate the buffers we use for drawing
        if(Toybox.Graphics has :BufferedBitmap) {
            // Allocate a full screen size buffer with a palette of only 4 colors to draw
            // the background image of the watchface.  This is used to facilitate blanking
            // the second hand during partial updates of the display
            offscreenBuffer = new Graphics.BufferedBitmap({
                :width=>dc.getWidth(),
                :height=>dc.getHeight(),
                :palette=>[
					face.bgColor,
					face.marksColor,
					face.accentColor,
					face.ticksColor,
					minuteHand.accentShadowColor,
					minuteHand.handEdgeColor,
					battery.lowBatteryColor
		        ]
            });
        } else {
            offscreenBuffer = null;
        }

        curClip = null;

        centerPoint = [dc.getWidth()/2, dc.getHeight()/2];
    }

    // Handle the update event
    function onUpdate(dc) {
        var clockTime = System.getClockTime();
        var minuteHandAngle;
        var hourHandAngle;
        var secondHandAngle;
        var targetDc = null;

        // We always want to refresh the full screen when we get a regular onUpdate call.
        fullScreenRefresh = true;

        if(null != offscreenBuffer) {
            dc.clearClip();
            curClip = null;
            // If we have an offscreen buffer that we are using to draw the background,
            // set the draw context of that buffer as our target.
            targetDc = offscreenBuffer.getDc();
        } else {
            targetDc = dc;
        }

        // Draw the tick marks around the edges of the screen
        targetDc.drawBitmap(0, 0, face.getAsBitmap());
        
        if (Application.getApp().getProperty("ShowBattery")) {
	        var batteryLevel = (System.getSystemStats().battery + 0.5).toNumber();
	        battery.draw(targetDc, batteryLevel);
        }

        // Draw the hour hand. Convert it to minutes and compute the angle.
        hourHandAngle = (((clockTime.hour % 12) * 60) + clockTime.min);
        hourHandAngle = hourHandAngle / (12 * 60.0);
        hourHandAngle = hourHandAngle * PI * 2;
        
		hourHand.set(hourHandAngle);
		hourHand.draw(targetDc);


        // Draw the minute hand.
        minuteHandAngle = (clockTime.min / 60.0) * PI * 2;
        
		minuteHand.set(minuteHandAngle);
		minuteHand.draw(targetDc);
		
		if (partialUpdatesAllowed || (isAwake != null && isAwake)) {
			secondHand.drawHarbor(targetDc);
		}
		
        // Output the offscreen buffers to the main display if required.
        drawBackground(dc);

        if( partialUpdatesAllowed ) {
            // If this device supports partial updates and they are currently
            // allowed run the onPartialUpdate method to draw the second hand.
            onPartialUpdate( dc );
        } else if ( isAwake ) {
            // Otherwise, if we are out of sleep mode, draw the second hand
            // directly in the full update method.
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            secondHandAngle = (clockTime.sec / 60.0) * PI * 2;
            secondHand.set(secondHandAngle);
            secondHand.draw(dc);
        }

        fullScreenRefresh = false;
    }

    // Handle the partial update event
    function onPartialUpdate( dc ) {
    
    
        // If we're not doing a full screen refresh we need to re-draw the background
        // before drawing the updated second hand position. Note this will only re-draw
        // the background in the area specified by the previously computed clipping region.
        if(!fullScreenRefresh) {
        	dc.setClip(curClip[0][0], curClip[0][1], curClip[2][0], curClip[2][1]);
            drawBackground(dc);
        }

        var clockTime = System.getClockTime();
        var secondHandAngle = (clockTime.sec / 60.0) * PI * 2;
        secondHand.set(secondHandAngle);

        // Update the cliping rectangle to the new location of the second hand.
        curClip = Util.getBoundingBox(secondHand.getBox());
        dc.setClip(curClip[0][0], curClip[0][1], curClip[2][0], curClip[2][1]);

        // Draw the second hand to the screen.
		secondHand.draw(dc);
    }

    // Draw the watch face background
    // onUpdate uses this method to transfer newly rendered Buffered Bitmaps
    // to the main display.
    // onPartialUpdate uses this to blank the second hand from the previous
    // second before outputing the new one.
    function drawBackground(dc) {
        //If we have an offscreen buffer that has been written to
        //draw it to the screen.
        if( null != offscreenBuffer ) {
            dc.drawBitmap(0, 0, offscreenBuffer);
        }
    }

    // This method is called when the device re-enters sleep mode.
    // Set the isAwake flag to let onUpdate know it should stop rendering the second hand.
    function onEnterSleep() {
        isAwake = false;
        WatchUi.requestUpdate();
    }

    // This method is called when the device exits sleep mode.
    // Set the isAwake flag to let onUpdate know it should render the second hand.
    function onExitSleep() {
        isAwake = true;
    }
    
	function refreshColors() {
		// order is important
		secondHand.refreshColors();
		minuteHand.refreshColors();
		hourHand.refreshColors();
		face.refreshColors();
   	    
   	    offscreenBuffer.setPalette([
			face.bgColor,
			face.marksColor,
			face.accentColor,
			face.ticksColor,
			minuteHand.accentShadowColor,
			minuteHand.handEdgeColor,
			battery.lowBatteryColor
		]);
    }
}