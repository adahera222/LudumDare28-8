package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.display.BitmapData;

class TheEndScene extends Scene {
	private var _gameOver:TextEntity;
	private var _continue:TextEntity;
	private var _spaceOnce:Bool = false;
	
	override public function begin() {
		super.begin();
		
		Reg.FADE = new Fade();
		add( Reg.FADE );
		Reg.FADE.add();
		
		addGraphic( new Image( new BitmapData( 640, 480, false, 0xff222222 ) ) );
		
		_gameOver = new TextEntity( "The End!", 64 );
		_continue = new TextEntity( "Press space to retry", 16 );
		
		_gameOver.x = 160;
		_gameOver.y = 200;
		_continue.x = 220;
		_continue.y = 280;
		
		_continue.color = _gameOver.color = 0xff1111EE;
		
		add( _gameOver );
		Reg.FADE.fadeIn( 0.5 );
	}
	
	override public function update():Void {
		if ( Input.pressed( Key.SPACE ) ) {
			if ( _spaceOnce ) {
				Reg.FADE.fadeOut( 0.5, function() { HXP.scene = new MenuScene(); } );
			} else {
				var t:TextEntity = new TextEntity( "Press space again to restart", 16 );
				t.x = 300;
				t.y = 10;
				t.color = 0xCCDDCC;
				add( t );
				_spaceOnce = true;
			}
		}
		
		super.update();
	}
}