import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.WatchUi;

//! Handle button view behavior
class WarpaintLanguageDelegate extends WatchUi.BehaviorDelegate {

    private var _view as WarpaintLanguageView;

    //! Constructor
    //! @param view The main view
    public function initialize(view as WarpaintLanguageView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    //! Handle the menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        // Generate a new Menu with a drawable Title
        var menu = new WatchUi.Menu2({:title=>"Settings"});

        var languageFromSublabel = Properties.getValue("languageFrom"); // gets the iso code
        var languageToSublabel = Properties.getValue("languageTo");
        languageFromSublabel = languagesDict[languageFromSublabel];
        languageToSublabel = languagesDict[languageToSublabel];
        // Label, sublabel, id, 
        menu.addItem(new WatchUi.MenuItem("Language From", languageFromSublabel, "languageFrom", null));
        menu.addItem(new WatchUi.MenuItem("Language To", languageToSublabel, "languageTo", null));
        menu.addItem(new WatchUi.MenuItem("Categories", null, "category", null));
        WatchUi.pushView(menu, new $.MainMenuDelegate(menu), WatchUi.SLIDE_UP);
        return true;
    }

    //! Handle asking next word
    //! @return true if handled, false otherwise
    public function onNext() as Boolean {
        _view.revealLabel.setText("R E V E A L");
        _view.revealHider.unhide();

        _view.refreshWordsOnView();
        return true;
    }

    //! Handle reveal translation
    //! @return true if handled, false otherwise
    public function onReveal() as Boolean {
        _view.revealLabel.setText("");
        _view.revealHider.hide();
        _view.toTextArea.setText(_view.wordTo);
        return true;
    }

    //! Handle Statistics translation
    //! @return true if handled, false otherwise
    public function onStats() as Boolean {
        var view = new $.StatisticsView();
        var delegate = new $.StatisticsDelegate();
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
    }
}