import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;

//! This is the menu input delegate for the Basic Drawables menu
class MenuLanguageSelection extends WatchUi.Menu2InputDelegate {

    var _mainView as View;
    var _parentmenu as Menu2;
	var _parentmenuItemId;
    //! Constructor
	function initialize(mainView, parentMenu, parentmenuItemId) {
		Menu2InputDelegate.initialize();
        _mainView = mainView;
		_parentmenu = parentMenu;
		_parentmenuItemId = parentmenuItemId;
	}

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        var key = item.getId();
        var languageCode = item.getSubLabel();
        Properties.setValue(key, languageCode);
        if (key.equals("languageFrom")) {
            selectedLanguageFrom = languageCode;
            fromFlagId = languageCode;
        } else if (key.equals("languageTo")) {
            selectedLanguageTo = languageCode;
            toFlagId = languageCode;
        }
        _mainView.loadFlags();

        // Change to other language
        wordsArray = [];
        Storage.deleteValue("WordsArray");
        getApp().onSettingsChanged();
        
        var parent_idx = _parentmenu.findItemById(_parentmenuItemId);
		var parent_item = _parentmenu.getItem(parent_idx);
		if (parent_item) {
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
        // Don't allow wrapping
        return false;
    }
}