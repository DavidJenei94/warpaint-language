import Toybox.Graphics;
import Toybox.WatchUi;

(:glance)
class WarpaintLanguageGlanceView extends WatchUi.GlanceView {

    private var _fromFlag as BitmapResource;
    private var _toFlag as BitmapResource;

    function initialize() {
        GlanceView.initialize();
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
            dc.drawBitmap(dc.getWidth() * 0.75, dc.getHeight() * 0.16, _fromFlag);
        }
        if (selectedLanguageTo != null && !selectedLanguageTo.equals("None")) {
            dc.drawBitmap(dc.getWidth() * 0.75, dc.getHeight() * 0.65, _toFlag);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {

    }
}
