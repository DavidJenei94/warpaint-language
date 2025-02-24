import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

//! This is the menu input delegate for the Basic Drawables menu
class MenuLanguageSelection extends WatchUi.Menu2InputDelegate {

    var _mainView;
    var _parentmenu as Menu2;
	var _parentmenuItemId;

    //! Constructor
    //! @param mainView The mainView
    //! @param parentMenu The parent menu - the Languages From or Languages To
    //! @param parentmenuItemId the id of the parent manu
	function initialize(mainView, parentMenu, parentmenuItemId) {
		Menu2InputDelegate.initialize();
        _mainView = mainView;
		_parentmenu = parentMenu;
		_parentmenuItemId = parentmenuItemId;
	}

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        var key = item.getId().toString();
        var languageCode = item.getSubLabel();
        Storage.setValue(key, languageCode);
        if (key.equals("languageFrom")) {
            selectedLanguageFrom = languageCode;
        } else if (key.equals("languageTo")) {
            selectedLanguageTo = languageCode;
        }
        _mainView.loadFlags();

        // Change to other language - on the main view onSettingsChange will be called in onUpdate()
        settingsChanged = true;
        
        // Set the parent menu sublabel to the new one
        var parent_idx = _parentmenu.findItemById(_parentmenuItemId);
		var parent_item = _parentmenu.getItem(parent_idx);
		if (parent_item != null) {
            var newSubLabel = item.getLabel();
			parent_item.setSubLabel(newSubLabel);
			_parentmenu.updateItem(parent_item, parent_idx);
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
        // Allow wrapping
        return true;
    }
}