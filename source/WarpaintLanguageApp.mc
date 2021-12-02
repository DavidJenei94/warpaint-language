import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Communications;

class WarpaintLanguageApp extends Application.AppBase {

    var _mainView as View;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        if (_mainView != null) {
            var wordsArray = _mainView.getWordsArray();
            Storage.setValue("WordsArray", wordsArray);
        }
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        _mainView = new WarpaintLanguageView();
        var delegate = new WarpaintLanguageDelegate(_mainView);
        return [_mainView, delegate] as Array<Views or InputDelegates>;
    }

    // Return the glance view of your application here
    (:glance)
    function getGlanceView() as Array<Views or InputDelegates>? {
        loadLanguages();

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

        totalLearnedWords = Storage.getValue("totalLearnedWords");

        var totalWordsNo = 0;
        var selectedLanguageWordsNo = 0;
        if (totalLearnedWords != null) {
            var totalLearnedWordsKeys = totalLearnedWords.keys();
            for (var i = 0; i < totalLearnedWords.size(); i++) {
                totalWordsNo += totalLearnedWords[totalLearnedWordsKeys[i]];
                if (totalLearnedWordsKeys[i].equals(selectedLanguageTo)) {
                    selectedLanguageWordsNo = totalLearnedWords[selectedLanguageTo];
                }
            }
        }

        var glanceView = new WarpaintLanguageGlanceView(selectedLanguageWordsNo, totalWordsNo);
        return [glanceView] as View;
    }

    function onSettingsChanged() as Void {
        _mainView.onSettingsChanged();
    }
}

function getApp() as WarpaintLanguageApp {
    return Application.getApp() as WarpaintLanguageApp;
}