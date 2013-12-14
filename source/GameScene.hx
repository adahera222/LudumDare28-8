package;

import com.haxepunk.graphics.Emitter;
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
	private var _enemies:Array<Enemy>;
	private var _particles:Particles;
	
	override public function begin():Void {
		Reg.GS = this;
		
		_player = new Player( 80, 120 );
		_tileMap = new Tiles( "maps/Map_01.tmx", "images/tiles.png" );
		Reg.PARTICLES = new Particles();
		
		add( _tileMap );
		add( Reg.PARTICLES );
		add( _player );
		
		super.begin();
	}
	
	override public function update():Void {
		HXP.camera.x = _player.x - HXP.halfWidth;
		HXP.camera.y = _player.y - HXP.halfHeight;
		
		super.update();
	}
}