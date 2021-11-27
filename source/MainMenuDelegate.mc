import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Graphics;
import Toybox.WatchUi;

//! This is the menu input delegate for the main menu of the application
class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    var _mainMenu as Menu2;
    var _mainView as Menu2;

    //! Constructor
    public function initialize(mainView, mainMenu) {
        Menu2InputDelegate.initialize();
        _mainMenu = mainMenu;
        _mainView = mainView;
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;
        if (id.equals("category")) {
            // When the toggle menu item is selected, push a new menu that demonstrates
            // left and right toggles with automatic substring toggles.
            var toggleMenu = new WatchUi.Menu2({:title=>"Categories"});
            toggleMenu.addItem(new WatchUi.ToggleMenuItem("Animals", {:enabled=>"On", :disabled=>"Off"}, "animalsCategory", true, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            toggleMenu.addItem(new WatchUi.ToggleMenuItem("Plants", {:enabled=>"On", :disabled=>"Off"}, "plantsCategory", true, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            toggleMenu.addItem(new WatchUi.ToggleMenuItem("Food", {:enabled=>"On", :disabled=>"Off"}, "foodCategory", true, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            WatchUi.pushView(toggleMenu, new $.SubMenuDelegate(), WatchUi.SLIDE_UP);
        } else if (id.equals("languageFrom") || id.equals("languageTo")) {
            var title = id.equals("languageFrom") ? "Language From" : "Language To";
            var subMenuId = id.equals("languageFrom") ? "languageFrom" : "languageTo";
            var languageMenu = new WatchUi.Menu2({:title=>title});
            
            var languagesKeys = languages.keys();
            for (var i = 0; i < languages.size(); i++) {
                var key = languagesKeys[i];
                languageMenu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(languages[key]["name"]), key, subMenuId, null));
            }
            
            WatchUi.pushView(languageMenu, new $.MenuLanguageSelection(_mainView, _mainMenu, id), WatchUi.SLIDE_UP);
        }  else if (id.equals("stats")) {
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
    }
}

//! This is the menu input delegate shared by all the basic sub-menus in the application
class SubMenuDelegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;
        Properties.setValue(id, item.isEnabled());

        WatchUi.requestUpdate();
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the done item being selected
    public function onDone() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
