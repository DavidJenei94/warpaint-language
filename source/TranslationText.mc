import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Math;

class TranslationText extends WatchUi.Text {

    private var _translationText as String;
    private var _font as Number;

    //! Contructor
    //! @params params as in the custom drawable in layouts
    public function initialize(params as Dictionary) {
        Text.initialize(params);
    }

    //! draw the texts
    //! @param dc Device Content
    function draw(dc as Dc) {
        self.setColor(Graphics.COLOR_WHITE);
        self.setFont(_font);
        self.setText(_translationText);
		Text.draw(dc);
    }

    //! Set the translation text and font
    //! @param translationText the text to show
    //! @param font the font to show the text with
    function setTranslationText(translationText as String, font as Number) as Void {
        _translationText = translationText;
        _font = font;
    }

    //! split the translation text according to length
    //! @param dc Device Content
    //! @param translation the text to split
    //! @param isFrom a little different layout if from or to (because the round watch)
    //! @return array of splitted text and selected font
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
            // 1 line
    		translationMiddle = translation;
            selectedFont = Graphics.FONT_LARGE;
    	} else if (dc.getTextWidthInPixels(translation, Graphics.FONT_MEDIUM) <= screenWidth * screenLengthPercent) {
            // 1 line
            translationMiddle = translation;
            selectedFont = Graphics.FONT_MEDIUM;
        } else if (dc.getTextWidthInPixels(translation, Graphics.FONT_SMALL) <= screenWidth * screenLengthPercent) {
            // 1 line
            translationMiddle = translation;
            selectedFont = Graphics.FONT_SMALL;
        } else if (dc.getTextWidthInPixels(translation, Graphics.FONT_TINY) <= screenWidth * screenLengthPercent) {
            // 1 line
            translationMiddle = translation;
            selectedFont = Graphics.FONT_TINY;
        } else {
            // 2 lines
            for (var iFont = Graphics.FONT_SMALL; iFont >= 0; iFont--){
                var textLength = dc.getTextWidthInPixels(translation, iFont);
                var maxTextLength = (screenWidth * screenLengthPercent) * 2;

                selectedFont = iFont;
                var splitPart = isFrom ? 0.47 : 0.48;

                // if it is a bit too long, split with "-"
                if (iFont == 0 && dc.getTextWidthInPixels(translation, iFont) > (screenWidth * screenLengthPercent) * 1.80) {
                    var middleIndex = Math.ceil(translationLength * splitPart);
                    translationTop = translation.substring(0, middleIndex);
                    // if "space" or "," is not the splitting part, then use "-"
                    if (!translation.substring(middleIndex, middleIndex + 1).equals(" ") && !translation.substring(middleIndex, middleIndex + 1).equals(",") && 
                        !translation.substring(middleIndex - 1, middleIndex).equals(" ") && !translation.substring(middleIndex - 1, middleIndex).equals(",")) {
                        translationTop += "-";
                    }
                    translationBottom = translation.substring(middleIndex, translationLength);
                    break;
                }

                // Otherwise split at middle at the next space
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

                    translationBottom = translation.substring(spaceIndex + 1, translationLength);

                    // If second line is way longer do not split (with next if), but change to smaller font if possible
                    if (iFont != 0 && dc.getTextWidthInPixels(translationBottom, iFont) >= screenWidth * screenLengthPercent) {
                        continue;
                    }

                    // If long word found (+second line is longer because of this), split with "-" 
                    if (spaceIndex == null || dc.getTextWidthInPixels(translationBottom, iFont) >= screenWidth * screenLengthPercent) {
                        splitPart = 0.47;
                        translationTop = translation.substring(0, Math.ceil(translationLength * splitPart)) + "-";
                        translationBottom = translation.substring(Math.ceil(translationLength * splitPart), translationLength);
                    }

                    break;
                }
            }
        }

        return [translationTop, translationMiddle, translationBottom, selectedFont];
    }
}
