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
	private var _treasureBoxes:Array<Box>;
	private var _exit:Box;
	private var _arrow:Arrow;
	private var _hearts:Array<Entity>;
	
	override public function begin():Void {
		Reg.GS = this;
		
		#if debug
		//Reg.level = 0;
		#end
		
		if ( Reg.level == 0 ) {
			_tileMap = new Tiles( "maps/Map_03.tmx", "images/village.png" );
		} else if ( Reg.level == 1 ) {
			_tileMap = new Tiles( "maps/Map_04.tmx", "images/forest.png" );
		} else {
			_tileMap = new Tiles( "maps/Map_05.tmx", "images/cave.png" );
		}
		
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
		_treasureBoxes = new Array<Box>();
		
		for ( e in _tileMap.treasurePositions ) {
			var treas:Treasure = new Treasure( e.x, e.y );
			_treasures.push( treas );
			add( treas );
			var box:Box = new Box( e.x, e.y, 40, 40 );
			_treasureBoxes.push( box );
		}
		
		// Set up level exit
		
		_exit = new Box( _tileMap.exit.x, _tileMap.exit.y, _tileMap.exit.width, _tileMap.exit.height );
		
		// Set up hearts
		
		_hearts = new Array<Entity>();
		var s:Spritemap = new Spritemap( "images/heart.png" );
		s.scrollX = 0;
		s.scrollY = 0;
		s.layer = Reg.LAYER_HUD;
		
		for ( i in 0...20 ) {
			_hearts.push( new Entity( HXP.camera.x + 5 + 28 * i, HXP.camera.y + 5, s ) );
			_hearts[i].layer = Reg.LAYER_HUD;
			add( _hearts[i] );
		}
		
		Reg.PARTICLES = new Particles();
		Reg.LASERBEAM = new Laserbeam();
		Reg.BLASTER = new Blaster();
		Reg.BLASTER.layer = Reg.LAYER_ENEMY;
		Reg.BLASTER.visible = false;
		
		Reg.ARROW = new Arrow();
		Reg.ARROW.visible = false;
		
		add( _tileMap );
		add( _player );
		add( Reg.PARTICLES );
		add( Reg.LASERBEAM );
		add( Reg.BLASTER );
		add( Reg.ARROW );
		
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
		
		if ( _exit.collideWith( _player ) ) {
			Reg.level++;
			HXP.scene = new GameScene();
		}
		
		for ( i in 0..._treasureBoxes.length ) {
			if ( _treasureBoxes[i].collideWith( _player ) ) {
				if ( Input.check( Key.X ) ) {
					_treasures[i].open();
				}
			}
		}
		
		// What follows is probably the cheesiest collision code ever written.
		
		var playerHitEnemy:Bool = false;
		
		for ( enemy in _enemies ) {
			if ( _player.fx > enemy.x ) {
				if ( _player.fy > enemy.y ) {
					if ( _player.x < enemy.fx ) {
						if ( _player.y < enemy.fy ) {
							playerHitEnemy = true;
						}
					}
				}
			}
		}
		
		if ( playerHitEnemy ) {
			_player.hurt();
			
			var i:Int = _hearts.length - 1;
			
			while ( i >= 0 ) {
				if ( _hearts[i].visible == true ) {
					_hearts[i].visible = false;
					break;
				}
				
				if ( i == 0 ) {
					gameover();
					break;
				}
				
				i--;
			}
		}
		
		var hitEnemy:Enemy = null;
		
		for ( enemy in _enemies ) {
			if ( Reg.ARROW.fx > enemy.x ) {
				if ( Reg.ARROW.fy > enemy.y ) {
					if ( Reg.ARROW.x < enemy.fx ) {
						if ( Reg.ARROW.y < enemy.fx ) {
							hitEnemy = enemy;
						}
					}
				}
			}
		}
		
		if ( hitEnemy != null ) {
			hitEnemy.hurt( Reg.ARROW.damage );
		}
		
		#if debug
		if ( Input.released( Key.R ) ) {
			HXP.scene = new GameScene();
		}
		#end
		
		super.update();
	}
	
	public function playerX():Int {
		return Std.int( _player.x );
	}
	
	public function playerY():Int {
		return Std.int( _player.y );
	}
	
	public function removeEnemy( e:Enemy ):Void {
		remove( e );
		_enemies.remove( e );
		e = null;
	}
	
	private function gameover():Void {
		HXP.scene = new GameOverScene();
	}
}