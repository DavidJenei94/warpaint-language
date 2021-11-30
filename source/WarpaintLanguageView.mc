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

        loadLanguages();
        self.onSettingsChanged();

        if (!selectedLanguageFrom.equals("None")) {
            revealText = languages[selectedLanguageFrom]["reveal"];
        }
    }

    // Load your resources here
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

    function loadFlags() as Void {
        if (selectedLanguageFrom != null && !selectedLanguageFrom.equals("None")) {
            _fromFlag = WatchUi.loadResource(languages[selectedLanguageFrom]["flags"][0]);
        }

        if (selectedLanguageTo != null && !selectedLanguageTo.equals("None")) {
            _toFlag = WatchUi.loadResource(languages[selectedLanguageTo]["flags"][0]);
        }        
    }

    function refreshWordsOnView(withViewRefresh as Boolean) as Void {

        self.downloadWords();

        var words = getLastWords();
        if (words != null) {
            wordFrom = words.get("from");
            wordTo = words.get("to");
            revealed = false;
        } else if (selectedLanguageFrom.equals("None") || selectedLanguageTo.equals("None")) {
            wordFrom = "Select languages";
            wordTo = "in settings";

            revealLabel.setText("");
            revealHider.hide();
            revealed = true;
        } else {
            wordFrom = "Connect to Internet";
            wordTo = "Then click Next";

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
    function onUpdate(dc as Dc) as Void {

        var splittedTranslationFrom = TranslationText.splitTranslation(dc, wordFrom);
        var selectedFontFrom = splittedTranslationFrom[3];
        fromTopText.setTranslationText(splittedTranslationFrom[0], selectedFontFrom);
        fromMiddleText.setTranslationText(splittedTranslationFrom[1], selectedFontFrom);
        fromBottomText.setTranslationText(splittedTranslationFrom[2], selectedFontFrom);

        if (revealed) {
            var splittedTranslationTo = TranslationText.splitTranslation(dc, wordTo);
            var selectedFontTo = splittedTranslationTo[3];
            toTopText.setTranslationText(splittedTranslationTo[0], selectedFontTo);
            toMiddleText.setTranslationText(splittedTranslationTo[1], selectedFontTo);
            toBottomText.setTranslationText(splittedTranslationTo[2], selectedFontTo);
        } else {
            toTopText.setTranslationText("", Graphics.FONT_MEDIUM);
            toMiddleText.setTranslationText("", Graphics.FONT_MEDIUM);
            toBottomText.setTranslationText("", Graphics.FONT_MEDIUM);
        }

        if (settingsChanged) {
            _wordsArray = [];
            Storage.deleteValue("WordsArray");

            if (!selectedLanguageFrom.equals("None")) {
                revealText = languages[selectedLanguageFrom]["reveal"];
            }
            self.refreshWordsOnView(false);

            settingsChanged = false;
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_DK_GRAY);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // // Test
        // dc.drawText(dc.getWidth() * 0.50, dc.getHeight() * 0.55, Graphics.FONT_TINY, wordTo, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        if (selectedLanguageFrom != null && !selectedLanguageFrom.equals("None")) {
            dc.drawBitmap(dc.getWidth() * 0.27, dc.getHeight() * 0.10, _fromFlag);
        }
        if (selectedLanguageTo != null && !selectedLanguageTo.equals("None")) {
            dc.drawBitmap(dc.getWidth() * 0.56, dc.getHeight() * 0.10, _toFlag);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function getLastWords() as Dictionary {
        var words = null;
        if (_wordsArray != null && _wordsArray.size() != 0) {
            words = _wordsArray[_wordsArray.size() - 1];

            _wordsArray = _wordsArray.slice(0, _wordsArray.size() - 1);
        }

        return words;
    }

    function downloadWords() as Void {
        // try {
            if (selectedLanguageFrom != null && !selectedLanguageFrom.equals("None") && 
                selectedLanguageTo != null && !selectedLanguageTo.equals("None")) {

                // Downloading starts when wordsArray has <10 words, if it does not finish in time, start a new request
                if (_wordsArray == null || _wordsArray.size() < 1) {
                    Communications.cancelAllRequests();
                    downloading = false;
                }

                if (!downloading && System.getDeviceSettings().connectionAvailable && (_wordsArray == null || _wordsArray.size() < 10)) {
                    System.println("Start downloading");
                    var params = {
                        "lan1" => selectedLanguageFrom,
                        "lan2" => selectedLanguageTo,
                        "wordsNo" => 20
                    };
                    // Add actual words to params
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
                    var url = "https://script.google.com/macros/s/AKfycbzq5I8VstN7DwAjObKn5JUZJTC_QgAcgyJ4x1mxiZ_bpiYoF52MbBOXz9_2eoAd1L38/exec";
                    Communications.makeWebRequest(
                        url, 
                        params,
                        options,
                        method(:recieveWords)
                    );

                    downloading = true;

                    // Only show the progressbar if there are no more stores words
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
        if (_wordsArray != null && _wordsArray.size() > 10) {
            _downloadTimer.stop();
            downloading = false;
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            self.refreshWordsOnView(true);
        }
    }

	function recieveWords(responseCode, data) as Void {
        System.println("Response code: " + responseCode);
        System.println("recieveWords data: " + data);

		// If no HTTP failure:  return data response.
		var words = null;
		if (responseCode == 200) {
            words = data.get("results");
            
            if (_wordsArray == null) {
                _wordsArray = [];
            }
            _wordsArray.addAll(words);
        }

        // Probably the words already uploaded but there was issue in the response
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
    //! @param callback Callback function
    public function initialize(stopTimerCallback as Method() as Void, revealHider as HiderDrawable, setRevealed as Method() as Void) {
        BehaviorDelegate.initialize();
        _stopTimerCallback = stopTimerCallback;
        _revealHider = revealHider;
        _setRevealed = setRevealed;
    }

    //! Handle back behavior
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
