import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;

var wordsArray = [];

var languagesDict = {
    "en" => "English",
    "de" => "German",
    "fr" => "French"
};

var selectedLanguageFrom as String;
var selectedLanguageTo as String;

class WarpaintLanguageApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
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
        if (selectedLanguageFrom != "None" && selectedLanguageFrom != null &&
            selectedLanguageTo != "None" && selectedLanguageTo != null) {

            if (wordsArray == null || wordsArray.size() < 10) {
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
            }
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

            Storage.deleteValue("WordsArray");
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

function getApp() as WarpaintLanguageApp {
    return Application.getApp() as WarpaintLanguageApp;
}