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
	private var _treasures:Array<Treasure>;
	
	override public function begin():Void {
		Reg.GS = this;
		
		_tileMap = new Tiles( "maps/Map_03.tmx", "images/village.png" );
		_player = new Player( _tileMap.playerSpawn.x, _tileMap.playerSpawn.y );
		
		// Set up enemies
		
		_enemies = new Array<Enemy>();
		
		for ( e in _tileMap.spikePositions ) {
			var enemy:Enemy = new Enemy( e.x, e.y, "images/spike.png", 80, 80 );
			_enemies.push( enemy );
			add( enemy );
		}
		
		for ( e in _tileMap.spiderPositions ) {
			var enemy:Enemy = new Enemy( e.x, e.y, "images/spider.png", 48, 40 );
			_enemies.push( enemy );
			add( enemy );
		}
		
		for ( e in _tileMap.ghostPositions ) {
			var enemy:Enemy = new Enemy( e.x, e.y, "images/ghost.png", 96, 112 );
			_enemies.push( enemy );
			add( enemy );
		}
		
		// Set up vines
		
		_vines = new Array<Box>();
		
		for ( e in _tileMap.vineAreas ) {
			var vine:Box = new Box( e.x, e.y, e.width, e.height );
			_vines.push( vine );
		}
		
		// Set up treasures
		
		_treasures = new Array<Treasure>();
		
		for ( e in _tileMap.treasurePositions ) {
			var treas:Treasure = new Treasure( e.x, e.y );
			_treasures.push( treas );
			add( treas );
		}
		
		Reg.PARTICLES = new Particles();
		Reg.LASERBEAM = new Laserbeam();
		Reg.BLASTER = new Entity( 0, 0, new Spritemap( "images/blaster.png" ) );
		Reg.BLASTER.layer = Reg.LAYER_ENEMY;
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
		
		if ( HXP.camera.x < 0 ) {
			HXP.camera.x = 0;
		}
		
		if ( HXP.camera.x > _tileMap.width - 640 ) {
			HXP.camera.x = _tileMap.width - 640;
		}
		
		if ( HXP.camera.y < 0 ) {
			HXP.camera.y = 0;
		}
		
		if ( HXP.camera.y > _tileMap.height - 480 ) {
			HXP.camera.y = _tileMap.height - 480;
		}
		
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