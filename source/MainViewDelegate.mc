import Toybox.WatchUi;

//! Handle button view behavior
class MainViewDelegate extends WatchUi.BehaviorDelegate {

    private var _view as WarpaintLanguageView;

    //! Constructor
    //! @param view The check box view
    public function initialize(view as WarpaintLanguageView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    //! Handle asking next word
    //! @return true if handled, false otherwise
    public function onNext() as Boolean {
        // WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        _view.revealLabel.setText("R E V E A L");
        _view.revealHider.unhide();
        _view.refreshWordsOnView();
        return true;
    }

    //! Handle reveal translation
    //! @return true if handled, false otherwise
    public function onReveal() as Boolean {
        // WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        _view.revealLabel.setText("");
        _view.revealHider.hide();
        _view.toTextArea.setText(_view.hiddenWordTo);
        return true;
    }
}