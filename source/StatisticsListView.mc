import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;

class StatisticsListView extends WatchUi.View {

    var firstFlag as Bitmap;
    var secondFlag as Bitmap;
    var thirdFlag as Bitmap;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.StatsListLayout(dc));

        firstFlag = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.enFlag,
            :locX=>dc.getWidth() * 0.10,
            :locY=>dc.getHeight() * 0.20
        });
        secondFlag = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.deFlag,
            :locX=>dc.getWidth() * 0.35,
            :locY=>dc.getHeight() * 0.20
        });
        thirdFlag = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.enFlag,
            :locX=>dc.getWidth() * 0.60,
            :locY=>dc.getHeight() * 0.20
        });
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() * 0.50, dc.getHeight() * 0.15, Graphics.FONT_XTINY, "Total: 444444", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    }
}