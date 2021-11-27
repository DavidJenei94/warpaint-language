import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Application.Properties;
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

class WarpaintLanguageView extends WatchUi.View {

    var myShapes;

    var fromTextArea as TextArea;
    var toTextArea as TextArea;
    var wordFrom as String;
    var wordTo as String;

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
        fromTextArea = View.findDrawableById("TextAreaFrom");
        toTextArea = View.findDrawableById("TextAreaTo");
        revealLabel = View.findDrawableById("RevealLabel");
        revealHider = View.findDrawableById("RevealHider");

        loadFlags();

        refreshWordsOnView(false);
    }

    function loadFlags() as Void {
        if (!selectedLanguageFrom.equals("None") && selectedLanguageFrom != null) {
            _fromFlag = WatchUi.loadResource(languages[selectedLanguageFrom]["flags"][0]);
        }

        if (!selectedLanguageTo.equals("None") && selectedLanguageTo != null) {
            _toFlag = WatchUi.loadResource(languages[selectedLanguageTo]["flags"][0]);
        }        
    }

    function refreshWordsOnView(withViewRefresh as Boolean) as Void {

        self.downloadWords();

        var words = getLastWords();
        if (words != null) {
            // System.println("to with get: " + words.get("to"));
            // System.println("to with []: " + words["to"]);
            wordFrom = words.get("from");
            wordTo = words.get("to");

            fromTextArea.setText(wordFrom);
            toTextArea.setText("");
        } else if (selectedLanguageFrom.equals("None") || !selectedLanguageTo.equals("None")) {
            wordFrom = "Select languages";
            wordTo = "in the settings";

            fromTextArea.setText(wordFrom);
            toTextArea.setText(wordTo);
            revealLabel.setText("");
            revealHider.hide();
            revealed = true;
        } else {
            wordFrom = "Connect to Internet";
            wordTo = "Then click Next";

            fromTextArea.setText(wordFrom);
            toTextArea.setText(wordTo);
            revealLabel.setText("");
            revealHider.hide();
            revealed = true;
        }

        // fromTextArea.setText("the dog\na dog");
        // toTextArea.setText("der Hund\nein Hund");

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

        if (!selectedLanguageFrom.equals("None") && selectedLanguageFrom != null) {
            dc.drawBitmap(dc.getWidth() * 0.27, dc.getHeight() * 0.10, _fromFlag);
        }
        if (!selectedLanguageTo.equals("None") && selectedLanguageTo != null) {
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
            if (!selectedLanguageFrom.equals("None") && selectedLanguageFrom != null &&
                !selectedLanguageTo.equals("None") && selectedLanguageTo != null) {

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
                    var options = {
                        :method => Communications.HTTP_REQUEST_METHOD_GET,
                        :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
                    };
                    Communications.makeWebRequest(
                        "https://script.google.com/macros/s/AKfycbzVALwGCzk_J85y7R1BvLdWE3INeTnGKXNgyAMXMN3Go1iK6J1TgL9Z_YhE7pn_ZcuL/exec", 
                        params,
                        options,
                        method(:recieveWords)
                    );

                    downloading = true;

                    // Only show the progressbar if there are no more stores words
                    if (_wordsArray == null || _wordsArray.size() < 1) {
                        var progressBar = new WatchUi.ProgressBar("Downloading", null);
                        WatchUi.pushView(progressBar as ProgressBar, new $.ProgressDelegate(method(:stopTimer)), WatchUi.SLIDE_IMMEDIATE);

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
        }
    }

	function recieveWords(responseCode, data) as Void {
        System.println("recieveWords data: " + data);

		// HTTP failure: return responseCode.
		// Otherwise, return data response.
		var words = null;
        if (responseCode != 200) {
			data = responseCode;
		} else {
            words = data.get("results");
            
            if (_wordsArray == null) {
                _wordsArray = [];
            }
            _wordsArray.addAll(words);
        }

        downloading = false;

        self.revealLabel.setText(revealText);
        self.revealHider.unhide();
        self.revealed = false;
        self.refreshWordsOnView(true);
	}

    //! Store the array when App stops
    //! @return _wordsArray the last downloaded words
    function getWordsArray() as Array<String> {
        return _wordsArray;
    }

    function onSettingsChanged() as Void {
        selectedLanguageFrom = Properties.getValue("languageFrom");
        selectedLanguageTo = Properties.getValue("languageTo");

        WatchUi.requestUpdate();
    }

}

//! Input handler for the progress bar
class ProgressDelegate extends WatchUi.BehaviorDelegate {
    private var _callback as Method() as Void;

    //! Constructor
    //! @param callback Callback function
    public function initialize(callback as Method() as Void) {
        BehaviorDelegate.initialize();
        _callback = callback;
    }

    //! Handle back behavior
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        _callback.invoke();
        Communications.cancelAllRequests();
        downloading = false;
        return true;
    }
}
