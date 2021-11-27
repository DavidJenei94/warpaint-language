import Toybox.WatchUi;

//! Handle button view behavior
class StatisticsDelegate extends WatchUi.BehaviorDelegate {

    private var _statisticsView;

    //! Constructor
    public function initialize(view) {
        BehaviorDelegate.initialize();
        _statisticsView = view;
    }

    //! Handle the back event
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    //! Handle the select event
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        var totalWordsNo = _statisticsView.totalWordsNo;
        var customMenu = new WatchUi.CustomMenu(35, 0x000000, {
            :titleItemHeight=>70,
            :title=>new $.StatisticsListMenuTitle(totalWordsNo)
        });

        var languagesKeysDescending = _statisticsView.languagesKeysDescending;
        for (var i = 0; i < languagesKeysDescending.size(); i++) {
            var languageWordsNo = languagesDict[languagesKeysDescending[i]]["totalLearnedWords"];
            if (languageWordsNo == 0) {
                break;
            }

            var languageName = WatchUi.loadResource(languagesDict[languagesKeysDescending[i]]["name"]);
            var text = languageName + ": " + languageWordsNo;
            customMenu.addItem(new $.StatisticsListItem(languagesKeysDescending[i], text));
        }
        WatchUi.pushView(customMenu, new $.StatisticsListDelegate(), WatchUi.SLIDE_UP);

        return true;
    }

    // //! Handle select
    // //! @return true if handled, false otherwise
    // public function onSelect() as Boolean {
    //     onMenu();
    //     return true;
    // }
}
