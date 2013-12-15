package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

class TextEntity extends Entity {
	private var _text:Text;
	
	public var text(get, set):String;
	
	private function get_text():String {
		return _text.text;
	}
	
	private function set_text( NewText:String ):String {
		_text.text = NewText;
		
		return _text.text;
	}
	
	public var color(null, set):Int;
	
	private function set_color( NewColor:Int ):Int {
		_text.color = NewColor;
		
		return _text.color;
	}
	
	public function new( Content:String, Size:Int = 8 ) {
		_text = new Text( Content );
		_text.size = Size;
		
		super( 0, 0, _text );
	}
}