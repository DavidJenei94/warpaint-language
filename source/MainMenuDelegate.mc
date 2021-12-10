import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;

//! This is the menu input delegate for the main menu of the application
class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    var _mainMenu as Menu2;
    var _mainView as View;

    //! Constructor
    //! @param mainView The main view
    //! @param mainMenu the current main Menu - to pass as a parameter to Language selection 
    //! to be able to change the sublebel when seelcting a new language
    public function initialize(mainView, mainMenu) {
        Menu2InputDelegate.initialize();
        _mainMenu = mainMenu;
        _mainView = mainView;
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;
        if (id.equals("languageFrom") || id.equals("languageTo")) {
            var title = id.equals("languageFrom") ? "Language From" : "Language To";
            var subMenuId = id.equals("languageFrom") ? "languageFrom" : "languageTo";
            var languageMenu = new WatchUi.Menu2({:title=>title});
            
            // Add all loaded languages to list
            var languagesKeys = languages.keys();
            for (var i = 0; i < languages.size(); i++) {
                var key = languagesKeys[i];
                languageMenu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(languages[key]["name"]), key, subMenuId, null));
            }
            
            WatchUi.pushView(languageMenu, new $.MenuLanguageSelection(_mainView, _mainMenu, id), WatchUi.SLIDE_UP);
        } else if (id.equals("stats")) {
            var view = new $.StatisticsView();
            var delegate = new $.StatisticsDelegate(view);
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        } else {
            WatchUi.requestUpdate();
        }
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
        return true;
    }
}
