import Toybox.Graphics;
import Toybox.WatchUi;

(:glance)
class WarpaintLanguageGlanceView extends WatchUi.GlanceView {

    private var _fromFlag as BitmapResource;
    private var _toFlag as BitmapResource;

    var _selectedLanguageWordsNo as Number;
    var _totalWordsNo as Number;

    function initialize(selectedLanguageWordsNo, totalWordsNo) {
        GlanceView.initialize();
        _selectedLanguageWordsNo = selectedLanguageWordsNo;
        _totalWordsNo = totalWordsNo;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.GlanceLayout(dc));

        // Load flags
        if (selectedLanguageFrom != null && !selectedLanguageFrom.equals("None")) {
            _fromFlag = WatchUi.loadResource(languages[selectedLanguageFrom]["flags"][1]);
        }

        if (selectedLanguageTo != null && !selectedLanguageTo.equals("None")) {
            _toFlag = WatchUi.loadResource(languages[selectedLanguageTo]["flags"][1]);
        } 
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Draw flags
        if (selectedLanguageFrom != null && !selectedLanguageFrom.equals("None")) {
            dc.drawBitmap(dc.getWidth() * 0.30, dc.getHeight() * 0.43, _fromFlag);
        }
        if (selectedLanguageTo != null && !selectedLanguageTo.equals("None")) {
            dc.drawBitmap(dc.getWidth() * 0.57, dc.getHeight() * 0.43, _toFlag);
        }

        var displayStats = selectedLanguageTo + " " + _selectedLanguageWordsNo + " / Σ " + _totalWordsNo;
        dc.setColor(Graphics.COLOR_WHITE, dc.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() * 0.50, dc.getHeight() * 0.78, Graphics.FONT_XTINY, displayStats, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {

    }
}
