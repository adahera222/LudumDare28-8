package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import flash.display.BitmapData;

class Flash extends Entity {
	private var _sprite:Image;
	private var _fadeIn:Bool = false;
	private var _fadeOut:Bool = false;
	private var _fadeTime:Float = 0.0;
	private var _callBack:Void -> Void;
	private var _numFlash:Int = 0;
	private var _timer:Float = 0;
	
	public function new( CallBack:Void->Void ) {
		_sprite = new Image( new BitmapData( 640, 480, true, 0xffFFFFFF ) );
		
		super( 0, 0, _sprite );
		
		layer = Reg.LAYER_FADE;
		_sprite.scrollX = 0;
		_sprite.scrollY = 0;
		
		_callBack = CallBack;
	}
	
	override public function update():Void {
		_timer += HXP.elapsed;
		
		if ( _timer > 0.3 ) {
			visible = !visible;
			_numFlash++;
		}
		
		if ( _numFlash > 10 ) {
			visible = false;
			_callBack();
		}
		
		super.update();
	}
}