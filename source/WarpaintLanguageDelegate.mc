import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Application.Storage;
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
        languageFromSublabel = languageFromSublabel.equals("None") ? languageFromSublabel : languagesDict[languageFromSublabel][0];
        languageToSublabel = languageToSublabel.equals("None") ? languageFromSublabel : languagesDict[languageToSublabel][0];
        
        // Label, sublabel, id, 
        menu.addItem(new WatchUi.MenuItem("Language From", languageFromSublabel, "languageFrom", null));
        menu.addItem(new WatchUi.MenuItem("Language To", languageToSublabel, "languageTo", null));
        menu.addItem(new WatchUi.MenuItem("Categories", null, "category", null));
        menu.addItem(new WatchUi.MenuItem("Statistics", null, "stats", null));
        WatchUi.pushView(menu, new $.MainMenuDelegate(_view, menu), WatchUi.SLIDE_UP);
        return true;
    }

    //! Handle key events
    //! @param keyEvent
    //! @return true if handled, false otherwise
    function onKey(keyEvent) as Boolean {
        // System.println(keyEvent.getKey());
        if (keyEvent.getKey() == KEY_ENTER){
            if (_view.revealed) {
                onNext();
            } else {
                onReveal();
            }
        } else if (keyEvent.getKey() == KEY_CLOCK) {
            onStats();
        }
        return true;
    }

    //! Handle asking next word
    //! @return true if handled, false otherwise
    public function onNext() as Boolean {
        System.println("onNext");
        _view.revealLabel.setText("R E V E A L");
        _view.revealHider.unhide();

        _view.revealed = false;
        _view.refreshWordsOnView();
        return true;
    }

    //! Handle reveal translation
    //! @return true if handled, false otherwise
    public function onReveal() as Boolean {
        // System.println("onReveal");
        _view.revealLabel.setText("");
        _view.revealHider.hide();
        _view.toTextArea.setText(_view.wordTo);

        if (_view.revealed == false) {
            languagesDict[selectedLanguageTo][2]++;
            Storage.setValue("languagesDict", languagesDict);
        }
        _view.revealed = true;
        WatchUi.requestUpdate();
        return true;
    }

    //! Handle Statistics translation
    //! @return true if handled, false otherwise
    public function onStats() as Boolean {
        // System.println("onStats");
        var view = new $.StatisticsView();
        var delegate = new $.StatisticsDelegate();
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
    }
}