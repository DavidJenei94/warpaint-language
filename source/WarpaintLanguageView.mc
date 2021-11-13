import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;

class WarpaintLanguageView extends WatchUi.View {

    var myShapes;
    var fromTextArea as TextArea;
    var toTextArea as TextArea;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        fromTextArea = View.findDrawableById("TextAreaFrom");
        toTextArea = View.findDrawableById("TextAreaTo");

        var myTimer = new Timer.Timer();
        myTimer.start(method(:refreshWordsOnView), 5000, true);

        // to test text area sizes:
        //myShapes = new Rez.Drawables.textAreas();
    }

    function refreshWordsOnView() as Void {
        WatchUi.requestUpdate();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var words = getLastWords();
        var wordFrom = "";
        var wordTo = "";
        if (words != null) {
            wordFrom = words.get("from");
            wordTo = words.get("to");  
        } else {
            wordFrom = "Connect to Internet";
            wordTo = "Then Refresh";
        }

        fromTextArea.setText(wordFrom);
        toTextArea.setText(wordTo);
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // to test text area sizes:
        //myShapes.draw(dc);
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
