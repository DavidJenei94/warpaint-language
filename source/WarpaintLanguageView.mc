import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;

class WarpaintLanguageView extends WatchUi.View {

    var myShapes;

    var fromTextArea as TextArea;
    var toTextArea as TextArea;
    var wordFrom as String;
    var wordTo as String;

    var revealLabel as label;
    var revealHider as Drawable;

    var fromFlag as Bitmap;
    var toFlag as Bitmap;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        fromTextArea = View.findDrawableById("TextAreaFrom");
        toTextArea = View.findDrawableById("TextAreaTo");
        revealLabel = View.findDrawableById("RevealLabel");
        revealHider = View.findDrawableById("RevealHider");

        fromFlag = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.usFlag,
            :locX=>dc.getWidth() * 0.27,
            :locY=>dc.getHeight() * 0.10
        });
        toFlag = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.deFlag,
            :locX=>dc.getWidth() * 0.56,
            :locY=>dc.getHeight() * 0.10
        });

        refreshWordsOnView();

        // var myTimer = new Timer.Timer();
        // myTimer.start(method(:refreshWordsOnView), 5000, true);

        // to test text area sizes:
        //myShapes = new Rez.Drawables.textAreas();
    }

    function refreshWordsOnView() as Void {

        getApp().downloadWords();

        var words = getLastWords();
        if (words != null) {
            wordFrom = words.get("from");
            wordTo = words.get("to");

            fromTextArea.setText(wordFrom);
            toTextArea.setText("");
        } else {
            wordFrom = "Connect to Internet";
            wordTo = "Then click Next";

            fromTextArea.setText(wordFrom);
            toTextArea.setText(wordTo);
            revealLabel.setText("");
            revealHider.hide();
        }

        // fromTextArea.setText("I am not accepting anything else at");
        // toTextArea.setText("Do you understand what I’m saying?");

        WatchUi.requestUpdate();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_DK_GRAY);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        fromFlag.draw(dc);
        toFlag.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function getLastWords() as Dictionary {
        var words = null;
        if (wordsArray != null && wordsArray.size() != 0) {
            words = wordsArray[wordsArray.size() - 1];

            wordsArray = wordsArray.slice(0, wordsArray.size() - 1);
            Storage.setValue("WordsArray", wordsArray);
        }

        return words;
    }

}
