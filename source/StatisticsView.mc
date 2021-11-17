import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;

class StatisticsView extends WatchUi.View {

    var firstFlag as Bitmap;
    var secondFlag as Bitmap;
    var thirdFlag as Bitmap;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.StatsLayout(dc));

        firstFlag = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.usFlagS,
            :locX=>dc.getWidth() * 0.10,
            :locY=>dc.getHeight() * 0.20
        });
        secondFlag = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.deFlagS,
            :locX=>dc.getWidth() * 0.35,
            :locY=>dc.getHeight() * 0.20
        });
        thirdFlag = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.usFlagS,
            :locX=>dc.getWidth() * 0.60,
            :locY=>dc.getHeight() * 0.20
        });
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var firstColor = 0xFFFF00;
        var secondColor = 0xFF0000;
        var thirdColor = 0x00FF00;
        var otherColor = 0x555555;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() * 0.50, dc.getHeight() * 0.15, Graphics.FONT_XTINY, "Total: 444444", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Set penwidth for arc
        dc.setPenWidth(dc.getWidth() * 0.32);

        // Second most learned language arc and bar
        dc.setColor(secondColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, dc.getHeight() * 0.21, dc.getWidth() * 0.50, dc.getHeight() * 0.09);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.65, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, 255, 135);

        // Third most learned language arc and bar
        dc.setColor(thirdColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(dc.getWidth() * 0.50, dc.getHeight() * 0.21, dc.getWidth() * 0.50, dc.getHeight() * 0.09);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.65, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, 135, 55);

        // First most learned language arc and bar
        dc.setColor(firstColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(dc.getWidth() * 0.35, dc.getHeight() * 0.21, dc.getWidth() * 0.31, dc.getHeight() * 0.09);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.65, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, 0, 255);

        // Other learned languages arc
        dc.setColor(otherColor, Graphics.COLOR_BLACK);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.65, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, 55, 0);

        // Draw 2 divider lines on learned language bars
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(dc.getWidth() * 0.35, dc.getHeight() * 0.21, dc.getWidth() * 0.01, dc.getHeight() * 0.09);
        dc.fillRectangle(dc.getWidth() * 0.66, dc.getHeight() * 0.21, dc.getWidth() * 0.01, dc.getHeight() * 0.09);
        
        // Draw number of learned words
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() * 0.20, dc.getHeight() * 0.25, Graphics.FONT_XTINY, "70000", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth() * 0.50, dc.getHeight() * 0.25, Graphics.FONT_XTINY, "140512", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth() * 0.80, dc.getHeight() * 0.25, Graphics.FONT_XTINY, "678", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw the flags
        firstFlag.setLocation(dc.getWidth() * 0.55, dc.getHeight() * 0.75);
        secondFlag.setLocation(dc.getWidth() * 0.28, dc.getHeight() * 0.65);
        firstFlag.draw(dc);
        secondFlag.draw(dc);
        // thirdFlag.draw(dc);
    }

}