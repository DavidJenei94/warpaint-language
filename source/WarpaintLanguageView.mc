import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;

// Gobals
var languages = {};
var totalLearnedWords = {};
var actualLearnedWords = {};

var selectedLanguageFrom as String;
var selectedLanguageTo as String;

var downloading as Boolean;
var settingsChanged as Boolean;

var screenSize as Number;

class WarpaintLanguageView extends WatchUi.View {

    private var wordFrom as String;
    private var wordTo as String;

    private var fromTopText as Text;
    private var fromMiddleText as Text;
    private var fromBottomText as Text;
    private var toTopText as Text;
    private var toMiddleText as Text;
    private var toBottomText as Text;

    var revealText as String;
    var revealLabel as label;
    var revealHider as Drawable;
    var revealed as Boolean;

    private var _screenShape as Number;
    private var _fromFlag as BitmapResource;
    private var _toFlag as BitmapResource;

    private var _wordsArray = [];

    private var _downloadTimer as Timer.Timer;

    function initialize() {
        View.initialize();

        _wordsArray = Storage.getValue("WordsArray");
        totalLearnedWords = Storage.getValue("totalLearnedWords");
        actualLearnedWords = Storage.getValue("actualLearnedWords");
        
        downloading = false;
        revealed = false;
        settingsChanged = false;

        _screenShape = System.getDeviceSettings().screenShape;

        loadLanguages();
        self.onSettingsChanged();

        if (!selectedLanguageFrom.equals("None")) {
            revealText = languages[selectedLanguageFrom]["reveal"];
        }
    }

    // Load your resources here
    //! @param dc Device Content
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        revealLabel = View.findDrawableById("RevealLabel");
        revealHider = View.findDrawableById("RevealHider");

        fromTopText = View.findDrawableById("FromTopText");
		fromMiddleText = View.findDrawableById("FromMiddleText");
		fromBottomText = View.findDrawableById("FromBottomText");
        toTopText = View.findDrawableById("ToTopText");
		toMiddleText = View.findDrawableById("ToMiddleText");
		toBottomText = View.findDrawableById("ToBottomText");

        loadFlags();

        refreshWordsOnView(false);

        screenSize = dc.getWidth();
    }

    //! Load the flags of the 2 selected languages
    function loadFlags() as Void {
        if (selectedLanguageFrom != null && !selectedLanguageFrom.equals("None")) {
            _fromFlag = WatchUi.loadResource(languages[selectedLanguageFrom]["flags"][0]);
        }

        if (selectedLanguageTo != null && !selectedLanguageTo.equals("None")) {
            _toFlag = WatchUi.loadResource(languages[selectedLanguageTo]["flags"][0]);
        }        
    }

    //! Refresh the words displayed
    //! @param withViewRefresh if false, it does not update the view
    function refreshWordsOnView(withViewRefresh as Boolean) as Void {

        self.downloadWords();

        var words = getLastWords();
        if (words != null) {
            wordFrom = words.get("from");
            wordTo = words.get("to");
            revealed = false;
        } else if (selectedLanguageFrom.equals("None") || selectedLanguageTo.equals("None")) {
            // If no languages have been selected yet
            wordFrom = WatchUi.loadResource(Rez.Strings.languageSelection1);
            wordTo = WatchUi.loadResource(Rez.Strings.languageSelection2);

            revealLabel.setText("");
            revealHider.hide();
            revealed = true;
        } else {
            // If no internet connection
            wordFrom = WatchUi.loadResource(Rez.Strings.internetConnection1);
            wordTo = WatchUi.loadResource(Rez.Strings.internetConnection2);

            revealLabel.setText("");
            revealHider.hide();
            revealed = true;
        }
        
        if (withViewRefresh) {
            WatchUi.requestUpdate();
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    //! @param dc as Device Content
    function onUpdate(dc as Dc) as Void {

        // Split the current translation words 
        var splittedTranslationFrom = TranslationText.splitTranslation(dc, wordFrom, true);
        var selectedFontFrom = splittedTranslationFrom[3];
        fromTopText.setTranslationText(splittedTranslationFrom[0], selectedFontFrom);
        fromMiddleText.setTranslationText(splittedTranslationFrom[1], selectedFontFrom);
        fromBottomText.setTranslationText(splittedTranslationFrom[2], selectedFontFrom);

        if (revealed) {
            var splittedTranslationTo = TranslationText.splitTranslation(dc, wordTo, false);
            var selectedFontTo = splittedTranslationTo[3];
            toTopText.setTranslationText(splittedTranslationTo[0], selectedFontTo);
            toMiddleText.setTranslationText(splittedTranslationTo[1], selectedFontTo);
            toBottomText.setTranslationText(splittedTranslationTo[2], selectedFontTo);
        } else {
            toTopText.setTranslationText("", Graphics.FONT_MEDIUM);
            toMiddleText.setTranslationText("", Graphics.FONT_MEDIUM);
            toBottomText.setTranslationText("", Graphics.FONT_MEDIUM);
        }

        // On settings change empty the words array
        if (settingsChanged) {
            _wordsArray = [];
            Storage.deleteValue("WordsArray");

            if (!selectedLanguageFrom.equals("None")) {
                revealText = languages[selectedLanguageFrom]["reveal"];
            }
            self.refreshWordsOnView(false);

            settingsChanged = false;
        }

        // Call the parent onUpdate function to redraw the layout
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_DK_GRAY);
        View.onUpdate(dc);

        // Draw flags
        if (selectedLanguageFrom != null && !selectedLanguageFrom.equals("None")) {
            if (_screenShape == System.SCREEN_SHAPE_RECTANGLE) {
                dc.drawBitmap(dc.getWidth() * 0.27, dc.getHeight() * 0.08, _fromFlag);
            } else {
                dc.drawBitmap(dc.getWidth() * 0.27, dc.getHeight() * 0.10, _fromFlag);
            }
        }
        if (selectedLanguageTo != null && !selectedLanguageTo.equals("None")) {
            if (_screenShape == System.SCREEN_SHAPE_RECTANGLE) {
                dc.drawBitmap(dc.getWidth() * 0.56, dc.getHeight() * 0.08, _toFlag);
            } else {
                dc.drawBitmap(dc.getWidth() * 0.56, dc.getHeight() * 0.10, _toFlag);
            }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // Get the last words from wordsArray and pop those ones from the end of the list
    function getLastWords() as Dictionary {
        var words = null;
        if (_wordsArray != null && _wordsArray.size() != 0) {
            words = _wordsArray[_wordsArray.size() - 1];

            _wordsArray = _wordsArray.slice(0, _wordsArray.size() - 1);
        }

        return words;
    }

    //! Download the words according to the selected languages
    //! Download as much as the "wordsNo" param is equal
    function downloadWords() as Void {
        // try {
            if (selectedLanguageFrom != null && !selectedLanguageFrom.equals("None") && 
                selectedLanguageTo != null && !selectedLanguageTo.equals("None")) {

                // If it does not finish in time, stop current request and start a new one
                if (_wordsArray == null || _wordsArray.size() < 1) {
                    Communications.cancelAllRequests();
                    downloading = false;
                }

                // Downloading only starts when wordsArray has <10 words
                if (!downloading && System.getDeviceSettings().connectionAvailable && (_wordsArray == null || _wordsArray.size() < 10)) {
                    System.println("Start downloading");
                    var params = {
                        "lan1" => selectedLanguageFrom,
                        "lan2" => selectedLanguageTo,
                        "wordsNo" => 25
                    };
                    // Add actual words to params to upload the to total learned words statistics
                    if (actualLearnedWords != null) {
                        for (var i = 0; i < actualLearnedWords.size(); i++) {
                            var actualLearnedWordsKeys = actualLearnedWords.keys();
                            params.put(actualLearnedWordsKeys[i], actualLearnedWords[actualLearnedWordsKeys[i]]);
                        }
                    }
                    var options = {
                        :method => Communications.HTTP_REQUEST_METHOD_GET,
                        :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
                    };
                    var url = "https://script.google.com/macros/s/AKfycbwEUraBqCOTwWHfHX_u46vk9o_WDfTdrbPt3Tutpfjyuoc7zAcgYfphBRg8RyemJdSk/exec";
                    Communications.makeWebRequest(
                        url, 
                        params,
                        options,
                        method(:recieveWords)
                    );

                    downloading = true;

                    // Only show the progressbar if there are no more stored words
                    if (_wordsArray == null || _wordsArray.size() < 1) {
                        var progressBar = new WatchUi.ProgressBar("Download\nwords", null);
                        WatchUi.pushView(progressBar as ProgressBar, new $.ProgressDelegate(method(:stopTimer), revealHider, method(:setRevealed)), WatchUi.SLIDE_IMMEDIATE);

                        _downloadTimer = new Timer.Timer();
                        _downloadTimer.start(method(:timerCallback), 200, true);
                    }
                }
            }
        // } catch (ex) {

        // } finally {
        //     if (_downloadTimer != null) {
        //         _downloadTimer.stop();
        //     }
        // }
    }

    //! Stop the timer
    public function stopTimer() as Void {
        if (_downloadTimer != null) {
            _downloadTimer.stop();
        }
    }

    //! Update the progress bar every second
    public function timerCallback() as Void {
        // If wordsArray is filled up stop timer and downloading and go back to main view
        if (_wordsArray != null && _wordsArray.size() > 10) {
            _downloadTimer.stop();
            downloading = false;
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            self.refreshWordsOnView(true);
        }
    }

	function recieveWords(responseCode, data) as Void {
        // System.println("Response code: " + responseCode);
        // System.println("recieveWords data: " + data);

		// If no HTTP failure: add data to wordsArray
		var words = null;
		if (responseCode == 200) {
            words = data.get("results");
            
            if (_wordsArray == null) {
                _wordsArray = [];
            }
            _wordsArray.addAll(words);
        }

        // Probably the words already uploaded but there was issue in the response
        // Does not empty the words upload array in these cases:
        if (responseCode != Communications.BLE_CONNECTION_UNAVAILABLE || responseCode != Communications.BLE_QUEUE_FULL) {
            actualLearnedWords = {};
            Storage.setValue("actualLearnedWords", actualLearnedWords);
        }

        downloading = false;

        self.revealLabel.setText(revealText);
        self.revealHider.unhide();
        self.revealed = false;
	}

    //! Store the array when App stops
    //! @return _wordsArray the last downloaded words
    function getWordsArray() as Array<String> {
        return _wordsArray;
    }

    //! perform at settings change: get selected languages from storage
    function onSettingsChanged() as Void {
        selectedLanguageFrom = Storage.getValue("languageFrom");
        selectedLanguageTo = Storage.getValue("languageTo");
        if (selectedLanguageFrom == null) { 
            selectedLanguageFrom = "None"; 
            Storage.setValue("languageFrom", selectedLanguageFrom);
        }
        if (selectedLanguageTo == null) { 
            selectedLanguageTo = "None"; 
            Storage.setValue("languageTo", selectedLanguageTo);
        }

        WatchUi.requestUpdate();
    }

    //! set revealed value
    function setRevealed(value as Boolean) as Void {
        revealed = value;
    }

}

//! Input handler for the progress bar
class ProgressDelegate extends WatchUi.BehaviorDelegate {
    private var _stopTimerCallback as Method() as Void;
    private var _revealHider as HiderDrawable;
    private var _setRevealed as Method() as Void;

    //! Constructor
    //! @param stopTimerCallback Callback function
    //! @param revealHider RevealHider object
    //! @param setRevealed Callback function
    public function initialize(stopTimerCallback as Method() as Void, revealHider as HiderDrawable, setRevealed as Method() as Void) {
        BehaviorDelegate.initialize();
        _stopTimerCallback = stopTimerCallback;
        _revealHider = revealHider;
        _setRevealed = setRevealed;
    }

    //! Handle back behavior
    //! if progressbar is cancelled - cancel downloading too
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        _stopTimerCallback.invoke();

        Communications.cancelAllRequests();
        downloading = false;

        _revealHider.hide();
        _setRevealed.invoke(true);

        return true;
    }
}
