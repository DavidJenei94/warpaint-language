import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class StatisticsView extends WatchUi.View {

    var flags = new [3];

    private var languagesWordsNo = []; // words number sorted in this in descending
    var languagesKeysDescending = [];
    var totalWordsNo as Integer = 0;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    //! @param dc as Device Content
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.StatsLayout(dc));

        orderLanguages();

        // load flags of the 3 most learned languages
        for (var i = 0; i < 3; i++) {
            if (languagesWordsNo[i] > totalWordsNo * 0.12) {
                flags[i] = WatchUi.loadResource(languages[languagesKeysDescending[i]]["flags"][0]);
            } else if (languagesWordsNo[i] > totalWordsNo * 0.01) {
                flags[i] = WatchUi.loadResource(languages[languagesKeysDescending[i]]["flags"][1]);
            } else {
                break;
            }        
        }
    }

    // Update the view
    //! @param dc as Device Content
    function onUpdate(dc as Dc) as Void {

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Calculate and draw the pie chart and percentages
        if (totalWordsNo > 0) {
            var otherColor = 0x555555;

            var firstLanguagePercentage = languagesWordsNo[0].toFloat() / totalWordsNo;
            var secondLanguagePercentage = languagesWordsNo[1].toFloat() / totalWordsNo;
            var thirdLanguagePercentage = languagesWordsNo[2].toFloat() / totalWordsNo;
            var otherLanguagePercentage = (totalWordsNo - languagesWordsNo[0] - languagesWordsNo[1] - languagesWordsNo[2]).toFloat() / totalWordsNo;

            // percentage to display (needed to calculate because of roundings)
            var otherLanguagePercentageDisplay = Math.round(otherLanguagePercentage * 100);
            var thirdLanguagePercentageDisplay = Math.round(thirdLanguagePercentage * 100);
            var secondLanguagePercentageDisplay = Math.round(secondLanguagePercentage * 100);
            var firstLanguagePercentageDisplay = (100 - otherLanguagePercentageDisplay -thirdLanguagePercentageDisplay - secondLanguagePercentageDisplay);

            var firstLanguageArcDegree = firstLanguagePercentage * 360;
            var secondLanguageArcDegree = secondLanguagePercentage * 360;
            var thirdLanguageArcDegree = thirdLanguagePercentage * 360;
            var otherLanguageArcDegree = otherLanguagePercentage * 360;
            
            var firstLanguageArcDegreeEnd = 360 - firstLanguageArcDegree;
            var secondLanguageArcDegreeEnd = firstLanguageArcDegreeEnd - secondLanguageArcDegree;
            var thirdLanguageArcDegreeEnd = secondLanguageArcDegreeEnd - thirdLanguageArcDegree;

            var firstLanguageMidlleDegree = 360 - firstLanguageArcDegree / 2;
            var secondLanguageMidlleDegree = firstLanguageArcDegreeEnd - secondLanguageArcDegree / 2;
            var thirdLanguageMidlleDegree = secondLanguageArcDegreeEnd - thirdLanguageArcDegree / 2;
            var otherLanguageMidlleDegree = thirdLanguageArcDegreeEnd - otherLanguageArcDegree / 2;

            // Set penwidth for arc
            dc.setPenWidth(dc.getWidth() * 0.32);
            // First most learned language arc and bar
            if (firstLanguagePercentage > 0.00) {
                dc.setColor(languages[languagesKeysDescending[0]]["chartColor"], Graphics.COLOR_BLACK);
                dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.50, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, 0, firstLanguageArcDegreeEnd);
            }
            // Second most learned language arc and bar
            if (secondLanguagePercentage > 0.00 && firstLanguageArcDegreeEnd - secondLanguageArcDegreeEnd > 1) {
                dc.setColor(languages[languagesKeysDescending[1]]["chartColor"], Graphics.COLOR_BLACK);
                dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.50, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, firstLanguageArcDegreeEnd, secondLanguageArcDegreeEnd);
            }
            // Third most learned language arc and bar
            if (thirdLanguagePercentage > 0.00 && secondLanguageArcDegreeEnd - thirdLanguageArcDegreeEnd > 1) {
                dc.setColor(languages[languagesKeysDescending[2]]["chartColor"], Graphics.COLOR_BLACK);
                dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.50, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, secondLanguageArcDegreeEnd, thirdLanguageArcDegreeEnd);
            }
            // Other learned languages arc
            if (otherLanguagePercentage > 0.00 && thirdLanguageArcDegreeEnd > 1) {
                dc.setColor(otherColor, Graphics.COLOR_BLACK);
                dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.50, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, thirdLanguageArcDegreeEnd, 0);
            }

            // Draw the flags and percents
            drawFlagAndPercentage(dc, -1, otherLanguagePercentage, otherLanguagePercentageDisplay, otherLanguageMidlleDegree, true);
            drawFlagAndPercentage(dc, 2, thirdLanguagePercentage, thirdLanguagePercentageDisplay, thirdLanguageMidlleDegree, false);
            drawFlagAndPercentage(dc, 1, secondLanguagePercentage, secondLanguagePercentageDisplay, secondLanguageMidlleDegree, false);
            drawFlagAndPercentage(dc, 0, firstLanguagePercentage, firstLanguagePercentageDisplay, firstLanguageMidlleDegree, false);
        }
    }

    //! draw the flags and percentages on top of pie chart
    //! @param dc as Device Content
    //! @param languageNo the order of the language (1st, 2nd, 3rd, other)
    //! @param percentage Actual percentage
    //! @param percentageDisplay percentage to display (needed to calculate because of roundings)
    //! @param middleDegree the middle of the arc to position flags
    //! @param isOther if other, then no flag is necessary
    private function drawFlagAndPercentage(dc as Dc, languageNo as Integer, percentage as Float, percentageDisplay as Float, middleDegree as Float, isOther as Boolean) as Void {
        // Draw the flags and percents
        var shiftDistance = dc.getWidth() / 2.00;
        var xShift = shiftDistance - dc.getWidth() * 0.08;
        var yShift = shiftDistance - dc.getWidth() * 0.05;
        var xShiftSmall = shiftDistance - dc.getWidth() * 0.04;
        var yShiftSmall = shiftDistance - dc.getWidth() * 0.02;
        var distance = dc.getWidth() * 0.16; // distance of the top left corner of the flags from the center of screen
        var percentTextDistance = distance * 2.40;
        var coordinates;

        if (percentage > 0.00) {
            if (!isOther) {
                if (percentage > 0.12) {
                    coordinates = calculateXYfromDegree(middleDegree, distance, xShift, yShift);
                } else {
                    coordinates = calculateXYfromDegree(middleDegree, distance, xShiftSmall, yShiftSmall);
                }
                dc.drawBitmap(coordinates[0], coordinates[1], flags[languageNo]);
            }

            // determine the coordinate of the text - adjust if necessary (at the end and in the middle)
            coordinates = calculateXYfromDegree(middleDegree, percentTextDistance, shiftDistance, shiftDistance);
            if (coordinates[0] > dc.getWidth() * 0.4 && coordinates[0] < dc.getWidth() * 0.6) {
                percentTextDistance = distance * 2.25;
                coordinates = calculateXYfromDegree(middleDegree, percentTextDistance, shiftDistance, shiftDistance);
            } else if (coordinates[0] > dc.getWidth() * 0.85 || coordinates[0] < dc.getWidth() * 0.15) {
                percentTextDistance = distance * 2.50;
                coordinates = calculateXYfromDegree(middleDegree, percentTextDistance, shiftDistance, shiftDistance);
            }
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                coordinates[0], 
                coordinates[1], 
                Graphics.FONT_XTINY, 
                percentageDisplay.format("%.0f").toString() + "%", 
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }       
    }

    //! reposition the x and y for flags
    //! @param degree current middle degree
    //! @param distance the distance from middle
    //! @param xShift the shift from x
    //! @param yShift the shift from y
    private function calculateXYfromDegree(degree as Float, distance as Float, xShift as Float, yShift as Float) as Array<Float> {
        var radians = Math.toRadians(degree);
        var x = distance * Math.cos(radians) + xShift;
        var y = -1 * distance * Math.sin(radians) + yShift;
        return [x, y];
    }

    //! Sort learned words in Descending order
    function orderLanguages() as Void {
        // Language Order does not matter at this point, it will be searched below
        var languagesKeys = languages.keys();
        for (var i = 0; i < languagesKeys.size(); i++) {
            if (totalLearnedWords != null && totalLearnedWords.hasKey(languagesKeys[i])) {
                languagesWordsNo.add(totalLearnedWords[languagesKeys[i]]);
            } else {
                languagesWordsNo.add(0);
            }
        }
        languagesWordsNo = mergesort(languagesWordsNo);

        totalWordsNo = 0;
        for (var i = 0; i < languagesWordsNo.size(); i++) {
            if (languagesWordsNo[i] == 0) {
                break;
            }
            totalWordsNo += languagesWordsNo[i];
        }

        if (totalWordsNo == 0) {
            return;
        }
        
        // Store the languages in an array according to the descending order of words
        languagesKeysDescending = new [totalLearnedWords.size()];
        // var languagesKeys = languages.keys();
        for (var j = 0; j < languagesKeys.size(); j++) {
            // If the language is in the total learned words keys
            if (totalLearnedWords.hasKey(languagesKeys[j])) {
                for (var i = 0; i < totalLearnedWords.size(); i++) {
                    if (languagesKeysDescending[i] == null && totalLearnedWords[languagesKeys[j]] == languagesWordsNo[i]) {
                        languagesKeysDescending[i] = languagesKeys[j];
                        break;
                    }
                }
            }
        }
    }

    //! Merge sort implementation
    //! @param arrayToSort the array to sort
    //! @return the sorted array
    function mergesort(arrayToSort) {
        if (arrayToSort.size() == 1) {
            return arrayToSort;
        }

        var arrayOne = arrayToSort.slice(0, (arrayToSort.size()) / 2);
        var arrayTwo = arrayToSort.slice((arrayToSort.size() / 2), arrayToSort.size());

        arrayOne = mergesort(arrayOne);
        arrayTwo = mergesort(arrayTwo);

        return merge(arrayOne, arrayTwo);
    }

    //! merge of the Merge sort implementation
    //! @param arrayOne the first array
    //! @param arrayTwo the second array
    //! @return new sorted array from the 2 of them
    function merge(arrayOne, arrayTwo) {
        var arrayThree = [];

        while (arrayOne.size() > 0 && arrayTwo.size() > 0) {
            if (arrayOne[0] < arrayTwo[0]) {
                arrayThree.add(arrayTwo[0]);
                arrayTwo.remove(arrayTwo[0]);
            } else {
                arrayThree.add(arrayOne[0]);
                arrayOne.remove(arrayOne[0]);
            }
        }

        // either a or b array is empty
        while (arrayOne.size() > 0) {
            arrayThree.add(arrayOne[0]);
            arrayOne.remove(arrayOne[0]);
        }

        while (arrayTwo.size() > 0) {
            arrayThree.add(arrayTwo[0]);
            arrayTwo.remove(arrayTwo[0]);
        }

        return arrayThree;
    }

}
