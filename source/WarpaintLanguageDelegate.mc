import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

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

        var languageFromSublabel = Storage.getValue("languageFrom"); // gets the iso code (ISO 639-1)
        var languageToSublabel = Storage.getValue("languageTo");
        languageFromSublabel = languageFromSublabel.equals("None") ? languageFromSublabel : WatchUi.loadResource(languages[languageFromSublabel]["name"]);
        languageToSublabel = languageToSublabel.equals("None") ? languageToSublabel : WatchUi.loadResource(languages[languageToSublabel]["name"]);
        
        // Label, sublabel, id, 
        menu.addItem(new WatchUi.MenuItem("Language From", languageFromSublabel, "languageFrom", null));
        menu.addItem(new WatchUi.MenuItem("Language To", languageToSublabel, "languageTo", null));
        menu.addItem(new WatchUi.MenuItem("Statistics", null, "stats", null));
        WatchUi.pushView(menu, new $.MainMenuDelegate(_view, menu), WatchUi.SLIDE_UP);
        return true;
    }

    //! Handle key events - next or reveal on no touchsreen devices
    //! @param keyEvent
    //! @return true if handled, false otherwise: false handles the system's default action
    public function onKey(keyEvent) as Boolean {
        // System.println(keyEvent.getKey());
        if (keyEvent.getKey() == KEY_ENTER){
            if (_view.revealed) {
                onNext();
            } else {
                onReveal();
            }
        } else if (keyEvent.getKey() == KEY_CLOCK) {
            onStats();
        } else {
            return false;
        }
        return true;
    }

    //! Handle asking next word
    //! Restore the RevealHider and get new words within refreshWordsOnView
    //! @return true if handled, false otherwise
    public function onNext() as Void {
        if (selectedLanguageFrom != null && !selectedLanguageFrom.equals("None") && 
            selectedLanguageTo != null && !selectedLanguageTo.equals("None")) {

            _view.revealLabel.setText(_view.revealText);
            _view.revealHider.unhide();

            _view.revealed = false;
            _view.refreshWordsOnView(true);
        }
        WatchUi.requestUpdate();
    }

    //! Handle tap events - instead of buttons in layout
    //! @param clickEvent
    //! @return true if handled, false otherwise
    public function onTap(clickEvent as WatchUi.ClickEvent) as Lang.Boolean {
        var coordinateY = clickEvent.getCoordinates()[1];
        var screenHeight = System.getDeviceSettings().screenHeight;
        if (coordinateY < screenHeight * 0.25) {
            onStats();
        } else if (coordinateY >= screenHeight * 0.25 && coordinateY < screenHeight * 0.50) {
            onMenu();
        } else if (coordinateY >= screenHeight * 0.50 && coordinateY < screenHeight * 0.75) {
            if (selectedLanguageFrom.equals("None") || selectedLanguageTo.equals("None")) {
                onMenu();
            } else {
                onReveal();
            }
        } else if (coordinateY >= screenHeight * 0.75) {
            onNext();
        }
        return true;
    }

    //! Handle hold events on touchscreen
    //! @param keyEvent
    //! @return true if handled, false otherwise
    public function onHold(keyEvent) as Boolean {
        onMenu();
        return true;
    }

    //! Handle reveal translation
    //! Make the revealHider transparent and hide its text
    //! Increase the value of learned words only when revealed
    //! @return true if handled, false otherwise
    public function onReveal() as Void {
        _view.revealLabel.setText("");
        _view.revealHider.hide();

        if (_view.revealed == false) {
            if (totalLearnedWords == null) {
                totalLearnedWords = {};
            }
            if (totalLearnedWords.hasKey(selectedLanguageTo)) {
                totalLearnedWords[selectedLanguageTo]++;
            } else {
                totalLearnedWords.put(selectedLanguageTo, 1);
            }
            Storage.setValue("totalLearnedWords", totalLearnedWords);
            
            if (actualLearnedWords == null) {
                actualLearnedWords = {};
            }
            if (actualLearnedWords.hasKey(selectedLanguageTo)) {
                actualLearnedWords[selectedLanguageTo]++;
            } else {
                actualLearnedWords.put(selectedLanguageTo, 1);
            }
            Storage.setValue("actualLearnedWords", actualLearnedWords);
        }
        _view.revealed = true;
        WatchUi.requestUpdate();
    }

    //! Handle Statistics translation
    //! @return true if handled, false otherwise
    public function onStats() as Void {
        var view = new $.StatisticsView();
        var delegate = new $.StatisticsDelegate(view);
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
    }
}

//! HiderDrawable class to hide the To word with a white panel and text
class HiderDrawable extends WatchUi.Drawable {

    private var _width as Float;
    private var _height as Float;
    private var _color as Number;

    //! Contructor
    //! @param params the parameters from the custom drawable from layout
    public function initialize(params as Dictionary) {
        Drawable.initialize(params);
        _width = params[:width];
		_height = params[:height];
		_color = params[:color];
    }

    //! draw the panel
    //! @param dc Device Content
    function draw(dc as Dc) {
        dc.setColor(_color, Graphics.COLOR_BLACK);
        dc.fillRectangle(
            self.locX,
            self.locY,
            _width,
            _height
        );
    }

    //! hide the reveal panel
    function hide() as Void {
        _color = Graphics.COLOR_BLACK;
    }

    //! show the reveal panel
    function unhide() as Void {
        _color = Graphics.COLOR_TRANSPARENT;
    }
}
