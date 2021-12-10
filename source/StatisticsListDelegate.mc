import Toybox.WatchUi;

//! Handle button view behavior
class StatisticsListDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle on Title
    //! @return true if handled, false otherwise
    function onTitle() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;        
    }

    //! Handle on Footer
    //! @return true if handled, false otherwise
    function onFooter() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;        
    }

    //! Handle on Done
    //! @return true if handled, false otherwise
    function onDone() as Boolean {
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

    //! Handle wrap
    //! @param key The key triggering the menu wrap
    //! @return true - wrapping is allowed
    function onWrap(key as Key) as Boolean {
        return true;        
    }
}