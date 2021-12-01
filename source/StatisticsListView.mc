import Toybox.Graphics;
import Toybox.WatchUi;

//! This is the custom drawable we will use for our main menu title
class StatisticsListMenuTitle extends WatchUi.Drawable {

    private var _totalWordsNo;

    //! Constructor
    public function initialize(totalWordsNo) {
        Drawable.initialize({});
        _totalWordsNo = totalWordsNo;
    }

    //! Draw the application icon and main menu title
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        dc.setColor(0x0055AA, 0x0055AA);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, "Words\nTotal: " + _totalWordsNo, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}


//! This is the custom item drawable.
//! It draws the label it is initialized with at the center of the region
class StatisticsListItem extends WatchUi.CustomMenuItem {

    private var _id as String;
    private var _label as String;

    //! Constructor
    //! @param id The identifier for this item
    //! @param text Text to display
    public function initialize(id as String, text as String) {
        CustomMenuItem.initialize(id, {});
        _id = id;
        _label = text;
    }

    //! Draw the item string at the center of the item.
    //! @param dc Device context
    public function draw(dc as Dc) as Void {

        if (_id.equals(selectedLanguageTo)) {
            dc.setColor(0xFFFFFF, 0xFFFFFF);
            dc.clear();
        }

        dc.setPenWidth(1);
        dc.setColor(0x0055AA, Graphics.COLOR_BLACK);
        dc.drawLine(0, 0, dc.getWidth(), 0);
        dc.drawLine(0, dc.getHeight() - 1, dc.getWidth(), dc.getHeight() - 1);

        if (_id.equals(selectedLanguageTo)) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, _label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
