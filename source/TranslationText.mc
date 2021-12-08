import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Math;

class TranslationText extends WatchUi.Text {

    private var _translationText as String;
    private var _font as Number;

    public function initialize(params as Dictionary) {
        Text.initialize(params);
    }

    function draw(dc as Dc) {
        //dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        self.setColor(Graphics.COLOR_WHITE);
        self.setFont(_font);
        self.setText(_translationText);
		Text.draw(dc);
    }

    // Set the text
    function setTranslationText(translationText as String, font as Number) as Void {
        _translationText = translationText;
        _font = font;
    }

    static function splitTranslation(dc as DC, translation as String, isFrom as Boolean) as Array<String or Number> {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();

        var translationLength = translation.length();

        var translationTop = "";
        var translationMiddle = "";
        var translationBottom = "";
        var selectedFont = Graphics.FONT_XTINY;

        var spaceIndex = 0;
        var screenLengthPercent = 0.95;

        if (dc.getTextWidthInPixels(translation, Graphics.FONT_LARGE) <= screenWidth * screenLengthPercent) {
    		translationMiddle = translation;
            selectedFont = Graphics.FONT_LARGE;
    	} else if (dc.getTextWidthInPixels(translation, Graphics.FONT_MEDIUM) <= screenWidth * screenLengthPercent) {
            translationMiddle = translation;
            selectedFont = Graphics.FONT_MEDIUM;
        } else {
            for (var iFont = Graphics.FONT_SMALL; iFont >= 0; iFont--){
                var textLength = dc.getTextWidthInPixels(translation, iFont);
                var maxTextLength = (screenWidth * screenLengthPercent) * 2;

                selectedFont = iFont;
                var splitPart = isFrom ? 0.47 : 0.48;

                // if it is a bit too long, split with "-"
                if (iFont == 0 && dc.getTextWidthInPixels(translation, iFont) > (screenWidth * screenLengthPercent) * 1.80) {
                    var middleIndex = Math.ceil(translationLength * splitPart);
                    translationTop = translation.substring(0, middleIndex);
                    // if space or , is not the splitting part
                    if (!translation.substring(middleIndex, middleIndex + 1).equals(" ") && !translation.substring(middleIndex, middleIndex + 1).equals(",") && 
                        !translation.substring(middleIndex - 1, middleIndex).equals(" ") && !translation.substring(middleIndex - 1, middleIndex).equals(",")) {
                        translationTop += "-";
                    }
                    translationBottom = translation.substring(middleIndex, translationLength);
                    break;
                }

                if (dc.getTextWidthInPixels(translation, iFont) <= (screenWidth * screenLengthPercent) * 2) {
                    do {
                        translationBottom = translation.substring(Math.ceil(translationLength * splitPart), translationLength); 
                        spaceIndex = translationBottom.find(" ");
                        if (spaceIndex != null) {
                            spaceIndex += Math.ceil(translationLength * splitPart);
                            translationTop = translation.substring(0, spaceIndex);
                        }

                        splitPart -= 0.02;
                        if (splitPart < 0) {
                            break;
                        }
                    } while (dc.getTextWidthInPixels(translationTop, iFont) >= screenWidth * screenLengthPercent || spaceIndex == null);

                    if (spaceIndex == null) {
                        splitPart = 0.48;
                        translationTop = translation.substring(0, Math.ceil(translationLength * splitPart)) + "-";
                        translationBottom = translation.substring(Math.ceil(translationLength * splitPart), translationLength);
                        break;
                    }

                    translationBottom = translation.substring(spaceIndex + 1, translationLength);
                    break;
                }
            }
        }

        return [translationTop, translationMiddle, translationBottom, selectedFont];
    }

}