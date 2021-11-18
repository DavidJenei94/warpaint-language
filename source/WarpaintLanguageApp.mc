import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Communications;

var wordsArray = [];

var languagesDict = {
    "en" => "English",
    "de" => "German",
    "fr" => "French"
};

var selectedLanguageFrom as String;
var selectedLanguageTo as String;

class WarpaintLanguageApp extends Application.AppBase {

    var _downloadTimer as Timer.Timer;
    var _downloading as Boolean;

    function initialize() {
        AppBase.initialize();
        _downloading = false;
        wordsArray = Storage.getValue("WordsArray");
        setGlobalVariables();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        downloadWords();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        var view = new WarpaintLanguageView();
        var delegate = new WarpaintLanguageDelegate(view);
        return [view, delegate] as Array<Views or InputDelegates>;

    }

    function downloadWords() as Void {
        if (!selectedLanguageFrom.equals("None") && selectedLanguageFrom != null &&
            !selectedLanguageTo.equals("None") && selectedLanguageTo != null) {

            // Downloading starts when wordsArray has <10 words, if it does not finish in time, start a new request
            if (wordsArray == null || wordsArray.size() < 1) {
                // Communications.cancelAllRequests();
                _downloading = false;
            }

            if (!_downloading && System.getDeviceSettings().connectionAvailable && (wordsArray == null || wordsArray.size() < 10)) {
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

                _downloading = true;

                // Only show the progressbar if there are no more stores words
                if (wordsArray == null || wordsArray.size() < 1) {
                    var progressBar = new WatchUi.ProgressBar("Downloading", null);
                    WatchUi.pushView(progressBar as ProgressBar, new $.ProgressDelegate(method(:stopTimer)), WatchUi.SLIDE_IMMEDIATE);

                    _downloadTimer = new Timer.Timer();
                    _downloadTimer.start(method(:timerCallback), 200, true);
                }
            }
        }
    }

        //! Stop the timer
    public function stopTimer() as Void {
        if (_downloadTimer != null) {
            _downloadTimer.stop();
        }
    }

    //! Update the progress bar every second
    public function timerCallback() as Void {
        if (wordsArray != null && wordsArray.size() > 10) {
            _downloadTimer.stop();
            _downloading = false;
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
            
            if (wordsArray == null) {
                wordsArray = [];
            }
            wordsArray.addAll(words);

            // Storage.deleteValue("WordsArray");
            Storage.setValue("WordsArray", wordsArray);
        }
	}

    function onSettingsChanged() as Void {
        setGlobalVariables();
    }

    function setGlobalVariables() as Void {
        selectedLanguageFrom = Properties.getValue("languageFrom");
        selectedLanguageTo = Properties.getValue("languageTo");
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
        _downloading = false;
        return true;
    }
}

function getApp() as WarpaintLanguageApp {
    return Application.getApp() as WarpaintLanguageApp;
}