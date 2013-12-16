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
	private var _thorns:Array<Box>;
	private var _treasures:Array<Treasure>;
	private var _treasureBoxes:Array<Box>;
	private var _exit:Box;
	private var _arrow:Arrow;
	private var _hearts:Array<Entity>;
	private var _foreground:Entity;
	private var _redNinja:RedNinja;
	private var _finalBoss:FinalBoss;
	private var _invincible:Bool = false;
	private var _invTimer:Float = 0.0;
	private var _arrowInd:TextEntity;
	private var _arrows:Int = 20;
	
	#if debug
	inline static private var INVINCIBLE:Bool = false;
	#end
	
	override public function begin():Void {
		Reg.GS = this;
		
		#if debug
		// Use to test a specific level
		Reg.level = 2;
		#end
		
		if ( Reg.level == 0 ) {
			_tileMap = new Tiles( "maps/Map_03.tmx", "images/village.png" );
			_foreground = Tiles.getForeground( "maps/Map_03.tmx", "images/village.png" );
		} else if ( Reg.level == 1 ) {
			_tileMap = new Tiles( "maps/Map_04.tmx", "images/forest.png" );
			_foreground = Tiles.getForeground( "maps/Map_04.tmx", "images/forest.png" );
		} else {
			_tileMap = new Tiles( "maps/Map_05.tmx", "images/cave.png" );
			_foreground = Tiles.getForeground( "maps/Map_05.tmx", "images/cave.png" );
		}
		
		_foreground.layer = Reg.LAYER_FOREGROUND;
		
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
		
		// Thorns
		
		_thorns = new Array<Box>();
		
		for ( e in _tileMap.thornAreas ) {
			var thorn:Box = new Box( e.x, e.y, e.width, e.height );
			_thorns.push( thorn );
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
		
		if ( _tileMap.exit != null ) {
			_exit = new Box( _tileMap.exit.x, _tileMap.exit.y, _tileMap.exit.width, _tileMap.exit.height );
		}
		
		// Final level stuff
		
		if ( _tileMap.bigNinjaSpawn != null ) {
			_redNinja = new RedNinja( _tileMap.bigNinjaSpawn.x, _tileMap.bigNinjaSpawn.y );
			add( _redNinja );
		}
		
		for ( p in _tileMap.smallNinjaSpawn ) {
			var e:Enemy = new Enemy( p.x, p.y, "images/ninja_sm.png", 32, 40 );
			_enemies.push ( e );
			add( e );
		}
		
		if ( _tileMap.bossSpawn != null ) {
			_finalBoss = new FinalBoss( _tileMap.bossSpawn.x, _tileMap.bossSpawn.y );
			add( _finalBoss );
		}
		
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
		
		_arrowInd = new TextEntity( "Arrows: " + _arrows, 16 );
		_arrowInd.x = 10;
		_arrowInd.y = 460;
		_arrowInd.scrollX = 0;
		_arrowInd.scrollY = 0;
		_arrowInd.layer = Reg.LAYER_HUD;
		
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
		add( _foreground );
		add( _arrowInd );
		
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
		
		for ( thorn in _thorns ) {
			if ( thorn.collideWith( _player ) ) {
				_player.thornHurt();
				takeAheart();
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
		
		var playerHitEnemy:Enemy = null;
		
		for ( enemy in _enemies ) {
			if ( _player.fx > enemy.x ) {
				if ( _player.fy > enemy.y ) {
					if ( _player.x < enemy.fx ) {
						if ( _player.y < enemy.fy ) {
							playerHitEnemy = enemy;
						}
					}
				}
			}
		}
		
		if ( playerHitEnemy != null ) {
			if ( playerHitEnemy.getType() == "spider" ) {
				_player.mint( playerHitEnemy );
				addAHeart();
			} else {
				if ( _player.hurt( playerHitEnemy ) ) {
					takeAheart();
				}
				
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
		
		var hitBeamEnemy:Enemy = null;
		var hitEnemyBeam:Box = null;
		
		for ( enemy in _enemies ) {
			for ( beam in Reg.LASERBEAM.boxes ) {
				if ( beam.fx > enemy.x ) {
					if ( beam.fy > enemy.y ) {
						if ( beam.x < enemy.fx ) {
							if ( beam.y < enemy.fy ) {
								if ( Reg.LASERBEAM.hasDamage ( beam ) ) {
									hitBeamEnemy = enemy;
									hitEnemyBeam = beam;
								}
							}
						}
					}
				}
			}
		}
		
		if ( hitBeamEnemy != null ) {
			hitBeamEnemy.hurt( 3, hitEnemyBeam );
			Reg.LASERBEAM.noDamage( hitEnemyBeam );
		}
		
		if ( _redNinja != null ) {
			if ( _player.fx > _redNinja.x ) {
				if ( _player.fy > _redNinja.y ) {
					if ( _player.x < _redNinja.fx ) {
						if ( _player.y < _redNinja.fy ) {
							_player.hurtNinja( new Box( _redNinja.x, _redNinja.y, _redNinja.width, _redNinja.height ) );
						}
					}
				}
			}
		}
		
		if ( _invincible ) {
			_player.visible = !_player.visible;
			
			_invTimer -= HXP.elapsed;
			
			if ( _invTimer < 0 ) {
				_invincible = false;
				_player.visible = true;
			}
		}
		
		_arrowInd.text = "Arrows: " + _arrows;
		
		#if debug
		if ( Input.released( Key.R ) ) {
			HXP.scene = new GameScene();
		}
		if ( Input.released( Key.N ) ) {
			Reg.level ++;
			HXP.scene = new GameScene();
		}
		if ( Input.released( Key.W ) ) {
			_player.x += 500;
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
	
	public var tilemap(get, null):Tiles;
	
	private function get_tilemap():Tiles {
		return _tileMap;
	}
	
	private function takeAheart():Void {
		#if debug
		if ( INVINCIBLE ) return;
		#end
		
		if ( _invincible ) return;
		
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
		
		_invTimer = 2;
		_invincible = true;
	}
	
	public function decrementArrows():Void {
		_arrows --;
	}
	
	public function addArrows( AmountToAdd:Int ):Void {
		_arrows += AmountToAdd;
	}
	
	public function numArrows():Int {
		return _arrows;
	}
	
	private function addAHeart():Void {
		if ( _invincible ) return;
		
		var i:Int = 0;
		
		while ( i <= _hearts.length - 1 ) {
			if ( _hearts[i].visible == false ) {
				_hearts[i].visible = true;
				break;
			}
			
			i++;
		}
		
		_invTimer = 2;
		_invincible = true;
	}
	
	private function gameover():Void {
		HXP.scene = new GameOverScene();
	}
}