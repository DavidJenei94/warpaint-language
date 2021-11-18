import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Graphics;
import Toybox.WatchUi;

//! This is the menu input delegate for the main menu of the application
class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    var mainMenu as Menu2;

    //! Constructor
    public function initialize(mainMenu) {
        Menu2InputDelegate.initialize();
        self.mainMenu = mainMenu;
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
            
            var languagesDictKeys = languagesDict.keys();
            for (var i = 0; i < languagesDict.size(); i++) {
                var key = languagesDictKeys[i];
                languageMenu.addItem(new WatchUi.MenuItem(languagesDict.get(key), key, subMenuId, null));
            }
            
            // languageMenu.addItem(new WatchUi.MenuItem("German", "de", newId, null));
            // languageMenu.addItem(new WatchUi.MenuItem("French", "fr", newId, null));
            WatchUi.pushView(languageMenu, new $.MenuLanguageSelection(mainMenu, id), WatchUi.SLIDE_UP);
        }  else if (id.equals("stats")) {
            var view = new $.StatisticsView();
            var delegate = new $.StatisticsDelegate();
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        }
        // else if (id.equals("check")) {
        //     // When the check menu item is selected, push a new menu that demonstrates
        //     // left and right checkbox menu items
        //     var checkMenu = new WatchUi.CheckboxMenu({:title=>"Checkboxes"});
        //     checkMenu.addItem(new WatchUi.CheckboxMenuItem("Item 1", "Left Check", "left", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
        //     checkMenu.addItem(new WatchUi.CheckboxMenuItem("Item 2", "Right Check", "right", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
        //     checkMenu.addItem(new WatchUi.CheckboxMenuItem("Item 3", "Check", "default", true, null));
        //     WatchUi.pushView(checkMenu, new $.Menu2SampleSubMenuDelegate(), WatchUi.SLIDE_UP);
        // } else if (id.equals("icon")) {
        //     // When the icon menu item is selected, push a new menu that demonstrates
        //     // left and right custom icon menus
        //     var iconMenu = new WatchUi.Menu2({:title=>"Icons"});
        //     var drawable1 = new $.CustomIcon();
        //     var drawable2 = new $.CustomIcon();
        //     var drawable3 = new $.CustomIcon();
        //     iconMenu.addItem(new WatchUi.IconMenuItem("Icon 1", drawable1.getString(), "left", drawable1, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
        //     iconMenu.addItem(new WatchUi.IconMenuItem("Icon 2", drawable2.getString(), "right", drawable2, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
        //     iconMenu.addItem(new WatchUi.IconMenuItem("Icon 3", drawable3.getString(), "default", drawable3, null));
        //     WatchUi.pushView(iconMenu, new $.Menu2SampleSubMenuDelegate(), WatchUi.SLIDE_UP);
        // } else if (id.equals("custom")) {
        //     // When the custom menu item is selected, push a new menu that demonstrates
        //     // custom menus
        //     var customMenu = new WatchUi.Menu2({:title=>"Custom Menus"});
        //     customMenu.addItem(new WatchUi.MenuItem("Basic Drawables", null, :basic, null));
        //     customMenu.addItem(new WatchUi.MenuItem("Images", null, :images, null));
        //     customMenu.addItem(new WatchUi.MenuItem("Wrap Out", null, :wrap, null));
        //     WatchUi.pushView(customMenu, new $.Menu2SampleCustomDelegate(), WatchUi.SLIDE_UP);
        // } 
        else {
            WatchUi.requestUpdate();
        }
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
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
        // System.println(id);
        // if (id.equals("category")) {

        // }

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
