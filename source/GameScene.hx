package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.display.Sprite;

class GameScene extends Scene {
	private var _player:Player;
	private var _tileMap:Tiles;
	private var _enemies:Array<Enemy>;
	private var _particles:Particles;
	private var _vines:Array<Box>;
	
	override public function begin():Void {
		Reg.GS = this;
		
		_tileMap = new Tiles( "maps/Map_03.tmx", "images/village.png" );
		_player = new Player( _tileMap.playerSpawn.x, _tileMap.playerSpawn.y );
		
		// Set up enemies
		
		_enemies = new Array<Enemy>();
		
		for ( e in _tileMap.enemyPositions ) {
			var enemy:Enemy = new Enemy( e.x, e.y, "images/monster.png" );
			_enemies.push( enemy );
			add( enemy );
		}
		
		// Set up vines
		
		_vines = new Array<Box>();
		
		for ( e in _tileMap.vineAreas ) {
			var vine:Box = new Box( e.x, e.y, e.width, e.height );
			_vines.push( vine );
		}
		
		Reg.PARTICLES = new Particles();
		Reg.LASERBEAM = new Laserbeam();
		Reg.BLASTER = new Entity( 0, 0, new Spritemap( "images/blaster.png" ) );
		Reg.BLASTER.visible = false;
		
		add( _tileMap );
		add( _player );
		add( Reg.PARTICLES );
		add( Reg.LASERBEAM );
		add( Reg.BLASTER );
		
		super.begin();
	}
	
	override public function update():Void {
		HXP.camera.x = _player.x - HXP.halfWidth;
		HXP.camera.y = _player.y - HXP.halfHeight;
		
		for ( vine in _vines ) {
			if ( vine.collideWith( _player ) ) {
				_player.canClimb = true;
			}
		}
		
		#if debug
		if ( Input.released( Key.R ) ) {
			HXP.scene = new GameScene();
		}
		#end
		
		super.update();
	}
}