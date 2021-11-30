import Toybox.WatchUi;

//! Handle button view behavior
class StatisticsListDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    function onTitle() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;        
    }

    function onFooter() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;        
    }

    //! Handle the select event
    //! @return true if handled, false otherwise
    public function onSelect(item as MenuItem) as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    //! Handle the back event
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}