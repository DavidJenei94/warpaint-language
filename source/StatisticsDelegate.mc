import Toybox.WatchUi;

//! Handle button view behavior
class StatisticsDelegate extends WatchUi.BehaviorDelegate {

    private var _statisticsView as View;
    private var _menuTitleHeight as Number;

    //! Constructor
    //! @param view Statistics view
    public function initialize(view) {
        BehaviorDelegate.initialize();
        _statisticsView = view;
        _menuTitleHeight = screenSize / 3.50;
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
        var customMenu = new WatchUi.CustomMenu((_menuTitleHeight / 2).toNumber(), 0x000000, {
            :titleItemHeight=>_menuTitleHeight.toNumber(),
            :title=>new $.StatisticsListMenuTitle(totalWordsNo)
        });

        if (totalWordsNo > 0) {
            var languagesKeysDescending = _statisticsView.languagesKeysDescending;
            for (var i = 0; i < languagesKeysDescending.size(); i++) {
                var languageWordsNo = totalLearnedWords[languagesKeysDescending[i]];
                if (languageWordsNo == 0) {
                    break;
                }

                var languageName = WatchUi.loadResource(languages[languagesKeysDescending[i]]["name"]);
                var text = languageName + ": " + languageWordsNo;
                customMenu.addItem(new $.StatisticsListItem(languagesKeysDescending[i], text));
            }
        } else {
            customMenu.addItem(new $.StatisticsListItem("", ""));
        }
        WatchUi.pushView(customMenu, new $.StatisticsListDelegate(), WatchUi.SLIDE_UP);

        return true;
    }
}
