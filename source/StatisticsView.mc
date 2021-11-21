import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;

class StatisticsView extends WatchUi.View {

    var flags = new [3];

    private var languagesWordsNo = []; // words number sorted in this in descending
    var languagesKeysDescending;
    var totalWordsNo as Number;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.StatsLayout(dc));

        orderLanguages();

        // load flags
        for (var i = 0; i < 3; i++) {
            if (languagesWordsNo[i] > totalWordsNo * 0.01) {
                flags[i] = WatchUi.loadResource(languagesDict[languagesKeysDescending[i]][1]);
            } else {
                break;
            }        
        }
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var firstColor = 0xFFFF00;
        var secondColor = 0xFF0000;
        var thirdColor = 0x00FF00;
        var otherColor = 0x555555;

        var firstLanguagePercentage = languagesWordsNo[0].toFloat() / totalWordsNo;
        var secondLanguagePercentage = languagesWordsNo[1].toFloat() / totalWordsNo;
        var thirdLanguagePercentage = languagesWordsNo[2].toFloat() / totalWordsNo;
        var otherLanguagePercentage = 360 - firstLanguagePercentage - secondLanguagePercentage - thirdLanguagePercentage;

        var firstLanguageArcDegree = firstLanguagePercentage * 360;
        var secondLanguageArcDegree = secondLanguagePercentage * 360;
        var thirdLanguageArcDegree = thirdLanguagePercentage * 360;
        var otherLanguageArcDegree = otherLanguagePercentage * 360;
        
        var firstLanguageArcDegreeEnd = 360 - firstLanguageArcDegree;
        var secondLanguageArcDegreeEnd = firstLanguageArcDegreeEnd - secondLanguageArcDegree;
        var thirdLanguageArcDegreeEnd = secondLanguageArcDegreeEnd - thirdLanguageArcDegree;

        // Set penwidth for arc
        dc.setPenWidth(dc.getWidth() * 0.32);
        // First most learned language arc and bar
        dc.setColor(firstColor, Graphics.COLOR_BLACK);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.50, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, 0, firstLanguageArcDegreeEnd);
        // Second most learned language arc and bar
        dc.setColor(secondColor, Graphics.COLOR_BLACK);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.50, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, firstLanguageArcDegreeEnd, secondLanguageArcDegreeEnd);
        // Third most learned language arc and bar
        dc.setColor(thirdColor, Graphics.COLOR_BLACK);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.50, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, secondLanguageArcDegreeEnd, thirdLanguageArcDegreeEnd);
        // Other learned languages arc
        dc.setColor(otherColor, Graphics.COLOR_BLACK);
        dc.drawArc(dc.getWidth() * 0.50, dc.getHeight() * 0.50, dc.getWidth() * 0.16, Graphics.ARC_CLOCKWISE, thirdLanguageArcDegreeEnd, 0);

        // Draw the flags and percents
        var shiftDistance = dc.getWidth() / 2;
        var xShift = shiftDistance - dc.getWidth() * 0.08;
        var yShift = shiftDistance - dc.getWidth() * 0.05;
        var distance = dc.getWidth() * 0.16; // distance of the top left corner of the flags from the center of screen
        var degree, radians as Float;
        var x, y as Integer;

        if (firstLanguagePercentage > 0.01) {
            degree = 360 - firstLanguageArcDegree / 2;
            radians = Math.toRadians(degree);
            x = distance * Math.cos(radians) + xShift;
            y = -1 * distance * Math.sin(radians) + yShift;

            dc.drawBitmap(x, y, flags[0]);
        }

        if (secondLanguagePercentage > 0.01) {
            degree = firstLanguageArcDegreeEnd - secondLanguageArcDegree / 2;
            radians = Math.toRadians(degree);
            x = distance * Math.cos(radians) + xShift;
            y = -1 * distance * Math.sin(radians) + yShift;

            dc.drawBitmap(x, y, flags[1]);
        }

        if (thirdLanguagePercentage > 0.01) {
            degree = secondLanguageArcDegreeEnd - thirdLanguageArcDegree / 2;
            radians = Math.toRadians(degree);
            x = distance * Math.cos(radians) + xShift;
            y = -1 * distance * Math.sin(radians) + yShift;

            dc.drawBitmap(x, y, flags[2]);
        }
    }

    function orderLanguages() as Void {
        // Sort learned words in Descending order
        var languagesDictValues = languagesDict.values();
        for (var i = 0; i < languagesDictValues.size(); i++) {
            languagesWordsNo.add(languagesDictValues[i][2]);
        }
        languagesWordsNo = mergesort(languagesWordsNo);
        
        // Store the languages in an array according to the descending order of words
        languagesKeysDescending = new [languagesWordsNo.size()];
        var languagesDictKeys = languagesDict.keys();
        for (var j = 0; j < languagesDictKeys.size(); j++) {
            for (var i = 0; i < languagesWordsNo.size(); i++) {
                if (languagesKeysDescending[i] == null && languagesDict[languagesDictKeys[j]][2] == languagesWordsNo[i]) {
                    languagesKeysDescending[i] = languagesDictKeys[j];
                    break;
                }
            }
        }

        totalWordsNo = 0;
        for (var i = 0; i < languagesWordsNo.size(); i++) {
            if (languagesWordsNo[i] == 0) {
                break;
            }
            totalWordsNo += languagesWordsNo[i];
        }
    }

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