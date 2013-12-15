package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.display.BitmapData;

class GameOverScene extends Scene {
	private var _gameOver:TextEntity;
	private var _continue:TextEntity;
	
	override public function begin() {
		super.begin();
		
		addGraphic( new Image( new BitmapData( 640, 480, false, 0xff111111 ) ) );
		
		_gameOver = new TextEntity( "Game Over!", 64 );
		_continue = new TextEntity( "Press space to retry", 16 );
		
		_gameOver.x = 140;
		_gameOver.y = 200;
		_continue.x = 220;
		_continue.y = 280;
		
		_continue.color = _gameOver.color = 0xffEE1111;
		
		add( _gameOver );
		add( _continue );
	}
	
	override public function update():Void {
		if ( Input.pressed( Key.SPACE ) ) {
			HXP.scene = new GameScene();
		}
		
		super.update();
	}
}