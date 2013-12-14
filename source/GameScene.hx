package;

import com.haxepunk.graphics.Tilemap;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class GameScene extends Scene {
	private var _player:Player;
	private var _tileMap:Tiles;
	
	override public function begin():Void {
		_player = new Player( 40, 40 );
		_tileMap = new Tiles( "images/tiles.png", 20 );
		
		add( _tileMap );
		add( _player );
		
		super.begin();
	}
	override public function update():Void {
		//HXP.camera.x = _player.x - HXP.halfWidth;
		//HXP.camera.y = _player.y - HXP.halfHeight;
		
		super.update();
	}
}