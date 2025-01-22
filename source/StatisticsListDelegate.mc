import Toybox.WatchUi;
import Toybox.Lang;

//! Handle button view behavior
// class StatisticsListDelegate extends WatchUi.BehaviorDelegate {
class StatisticsListDelegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        // BehaviorDelegate.initialize();
        Menu2InputDelegate.initialize();
    }

    //! Handle on Title
    //! @return true if handled, false otherwise
    function onTitle() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle on Footer
    //! @return true if handled, false otherwise
    function onFooter() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle on Done
    //! @return true if handled, false otherwise
    function onDone() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the select event
    //! @return true if handled, false otherwise
    public function onSelect(item as MenuItem) as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the back event
    //! @return true if handled, false otherwise
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle wrap
    //! @param key The key triggering the menu wrap
    //! @return true - wrapping is allowed
    function onWrap(key as Key) as Boolean {
        return true;        
    }
}