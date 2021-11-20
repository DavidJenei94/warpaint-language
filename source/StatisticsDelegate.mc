import Toybox.WatchUi;

//! Handle button view behavior
class StatisticsDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle the back event
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        var view = new $.StatisticsListView();
        var delegate = new $.StatisticsListDelegate();
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_UP);

        return true;
    }
}