package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import flash.display.BitmapData;

class Fade extends Entity {
	private var _sprite:Image;
	private var _fadeIn:Bool = false;
	private var _fadeOut:Bool = false;
	private var _fadeTime:Float = 0.0;
	private var _callBack:Void -> Void;
	
	public function new() {
		_sprite = new Image( new BitmapData( 640, 480, true, 0xff000000 ) );
		
		super( 0, 0, _sprite );
		
		layer = Reg.LAYER_FADE;
		visible = false;
		_sprite.scrollX = 0;
		_sprite.scrollY = 0;
	}
	
	override public function update():Void {
		if ( _fadeIn ) {
			_sprite.alpha -= HXP.elapsed / _fadeTime;
			
			if ( _sprite.alpha <= 0 ) {
				_fadeIn = false;
				
				if ( _callBack != null ) {
					_callBack();
				}
			}
		}
		
		if ( _fadeOut ) {
			_sprite.alpha += HXP.elapsed / _fadeTime;
			
			if ( _sprite.alpha >= 1 ) {
				_fadeOut = false;
				
				if ( _callBack != null ) {
					_callBack();
				}
			}
		}
		
		super.update();
	}
	
	public function fadeIn( Time:Float, ?CallBack:Void -> Void ):Void {
		if ( _fadeIn == false ) {
			_fadeOut = false;
			_fadeIn = true;
			_fadeTime = Time;
			
			if ( CallBack != null ) {
				_callBack = CallBack;
			}
			
			visible = true;
			_sprite.alpha = 1;
		}
	}
	
	public function fadeOut( Time:Float, ?CallBack:Void -> Void ):Void {
		if ( _fadeOut == false ) {
			_fadeOut = true;
			_fadeIn = false;
			_fadeTime = Time;
			
			if ( CallBack != null ) {
				_callBack = CallBack;
			}
			
			visible = true;
			_sprite.alpha = 0;
		}
	}
	
	public function add():Void {
		_fadeIn = false;
		_fadeOut = false;
		visible = true;
		_sprite.alpha = 1;
	}
	
	public function remove():Void {
		_fadeIn = false;
		_fadeOut = false;
		visible = false;
		_sprite.alpha = 0;
	}
}