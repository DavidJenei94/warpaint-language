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
        var glanceView = new WarpaintLanguageGlanceView();
        return [glanceView] as View;
    }

    function onSettingsChanged() as Void {
        _mainView.onSettingsChanged();
    }
}

function getApp() as WarpaintLanguageApp {
    return Application.getApp() as WarpaintLanguageApp;
}