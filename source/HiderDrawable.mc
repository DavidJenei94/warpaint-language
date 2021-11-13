import Toybox.WatchUi;

class HiderDrawable extends WatchUi.Drawable {

    private var _width as Float;
    private var _height as Float;
    private var _color as Number;

    public function initialize(params as Dictionary) {
        Drawable.initialize(params);
        _width = params[:width];
		_height = params[:height];
		_color = params[:color];
    }

    function draw(dc as Dc) {
        dc.setColor(_color, Graphics.COLOR_BLACK);
        dc.fillRectangle(
            self.locX,
            self.locY,
            _width,
            _height
        );
    }

    // hide the reveal
    function hide() as Void {
        _color = Graphics.COLOR_BLACK;
    }

    function unhide() as Void {
        _color = Graphics.COLOR_TRANSPARENT;
    }
}