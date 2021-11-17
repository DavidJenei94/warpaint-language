import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Graphics;
import Toybox.WatchUi;

//! This is the menu input delegate for the Basic Drawables menu
class MenuLanguageSelection extends WatchUi.Menu2InputDelegate {

    // //! Constructor
    // public function initialize() {
    //     Menu2InputDelegate.initialize();
    // }


    var parentmenu;
	var parentmenu_itemId;
    //! Constructor
	function initialize(parentmenu, parentmenu_itemId) {
		Menu2InputDelegate.initialize();
		self.parentmenu = parentmenu;
		self.parentmenu_itemId = parentmenu_itemId;
	}

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        var key = item.getId();
        Properties.setValue(key, item.getSubLabel());

        // Change to other language
        wordsArray = null;
        getApp().onSettingsChanged();
        
        var parent_idx = parentmenu.findItemById(parentmenu_itemId);
		var parent_item = parentmenu.getItem(parent_idx);
		if (parent_item) {
            var newSubLabel = item.getLabel();
			parent_item.setSubLabel(newSubLabel);
			parentmenu.updateItem(parent_item, parent_idx);
		}
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the user navigating off the end of the menu
    //! @param key The key triggering the menu wrap
    //! @return true if wrap is allowed, false otherwise
    public function onWrap(key as Key) as Boolean {
        // Don't allow wrapping
        return false;
    }
}