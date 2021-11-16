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

        // var textPositions = calculateTextPosition(dc, "402332", "66000", "5555", Graphics.FONT_XTINY);
        // System.println(textPositions);
        // var textBackgroundLength = calculateTextBackgroundPosition(dc, "402332", "66000", "5555", Graphics.FONT_XTINY);
        // System.println(textBackgroundLength);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() * 0.50, dc.getHeight() * 0.15, Graphics.FONT_XTINY, "Total: 444444", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Set penwidth for arc
        dc.setPenWidth(dc.getWidth() * 0.32);

        dc.setColor(secondColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, dc.getHeight() * 0.21, dc.getWidth() * 0.32, dc.getHeight() * 0.09);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.65, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, 255, 135);

        dc.setColor(firstColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(dc.getWidth() * 0.33, dc.getHeight() * 0.21, dc.getWidth() * 0.34, dc.getHeight() * 0.09);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.65, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, 0, 255);

        dc.setColor(thirdColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(dc.getWidth() * 0.68, dc.getHeight() * 0.21, dc.getWidth() * 0.32, dc.getHeight() * 0.09);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.65, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, 135, 55);

        dc.setColor(otherColor, Graphics.COLOR_BLACK);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.65, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, 55, 0);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        // dc.drawText(textPositions[0], dc.getHeight() * 0.25, Graphics.FONT_XTINY, "402332", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        // dc.drawText(textPositions[1], dc.getHeight() * 0.25, Graphics.FONT_XTINY, "66000", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        // dc.drawText(textPositions[2], dc.getHeight() * 0.25, Graphics.FONT_XTINY, "5555", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth() * 0.19, dc.getHeight() * 0.25, Graphics.FONT_XTINY, "6560000", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth() * 0.50, dc.getHeight() * 0.25, Graphics.FONT_XTINY, "9402332", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth() * 0.81, dc.getHeight() * 0.25, Graphics.FONT_XTINY, "5555555", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // dc.setColor(0x0055AA, Graphics.COLOR_BLACK);
        // dc.fillRectangle(0, dc.getHeight() * 0.21, dc.getWidth(), dc.getHeight() * 0.09);
        // dc.setColor(firstColor, Graphics.COLOR_TRANSPARENT);
        // dc.drawText(textPositions[0], dc.getHeight() * 0.25, Graphics.FONT_XTINY, "402332", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        // dc.setColor(secondColor, Graphics.COLOR_TRANSPARENT);
        // dc.drawText(textPositions[1], dc.getHeight() * 0.25, Graphics.FONT_XTINY, "66000", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        // dc.setColor(thirdColor, Graphics.COLOR_TRANSPARENT);
        // dc.drawText(textPositions[2], dc.getHeight() * 0.25, Graphics.FONT_XTINY, "5555", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        firstFlag.setLocation(dc.getWidth() * 0.55, dc.getHeight() * 0.75);
        secondFlag.setLocation(dc.getWidth() * 0.28, dc.getHeight() * 0.65);

        firstFlag.draw(dc);
        secondFlag.draw(dc);
        // thirdFlag.draw(dc);
    }

    function calculateTextPosition(dc as Dc, text1 as String, text2 as String, text3 as String, font as Number) as Array<Number> {

        var text1Width = dc.getTextWidthInPixels(text1, font);
        var text2Width = dc.getTextWidthInPixels(text2, font);
        var text3Width = dc.getTextWidthInPixels(text3, font);
        var allTextWidth = (text1Width + text2Width + text3Width).toFloat();

        var text1percent = text1Width / allTextWidth;
        var text2percent = text2Width / allTextWidth;
        var text3percent = text3Width / allTextWidth;

        var obscureWidth = dc.getWidth() * 0.10;
        var useableScreenWidth = dc.getWidth() * 0.80;

        var textPositions = new Number[3];
        textPositions[0] = useableScreenWidth * (text1percent / 2);
        textPositions[1] = useableScreenWidth * (text2percent / 2) + textPositions[0] * 2;
        textPositions[2] = useableScreenWidth * (text3percent / 2) + textPositions[1]  + dc.getWidth() * (text2percent / 2);

        textPositions[0] += obscureWidth;
        textPositions[1] += obscureWidth;
        textPositions[2] += obscureWidth;

        return textPositions;
    }

    function calculateTextBackgroundPosition(dc as Dc, text1 as String, text2 as String, text3 as String, font as Number) as Array<Number>  {
        var text1Width = dc.getTextWidthInPixels(text1, font);
        var text2Width = dc.getTextWidthInPixels(text2, font);
        var text3Width = dc.getTextWidthInPixels(text3, font);
        var allTextWidth = (text1Width + text2Width + text3Width).toFloat();

        var text1percent = text1Width / allTextWidth;
        var text2percent = text2Width / allTextWidth;
        var text3percent = text3Width / allTextWidth;

        var obscureWidth = dc.getWidth() * 0.10;
        var useableScreenWidth = dc.getWidth() * 0.80;
        useableScreenWidth = dc.getWidth();

        var textBackgroundLength = new Number[3];
        textBackgroundLength[0] = useableScreenWidth * text1percent;
        textBackgroundLength[1] = useableScreenWidth * text2percent;
        textBackgroundLength[2] = useableScreenWidth * text3percent;

        // textBackgroundLength[0] += obscureWidth;
        // textBackgroundLength[1] += obscureWidth;
        // textBackgroundLength[2] += obscureWidth;

        return textBackgroundLength;
    }

}