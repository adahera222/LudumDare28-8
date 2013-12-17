package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.display.BitmapData;
import flash.display.Sprite;
import haxe.remoting.FlashJsConnection;

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
	private var _arrowGroup:Array<Arrow>;
	private var _nextArrowLaunched:Int;
	private var _paused:Bool = false;
	private var _pauseDark:Entity;
	private var _pauseText:TextEntity;
	private var _fireArray:Array<Body>;
	private var _nextfire:Int;
	
	// sounds
	private var _sndArrow:Sfx;
	private var _sndBlaster:Sfx;
	private var _sndBoss:Sfx;
	private var _sndBow:Sfx;
	private var _sndCave:Sfx;
	private var _sndClimb:Sfx;
	private var _sndForest:Sfx;
	private var _sndGhost:Sfx;
	private var _sndHurt:Sfx;
	private var _sndJump:Sfx;
	private var _sndNinja:Sfx;
	private var _sndSmusher:Sfx;
	private var _sndSpider:Sfx;
	private var _sndSpike:Sfx;
	private var _sndTreasure:Sfx;
	private var _sndVillage:Sfx;
	private var _sndWalk:Sfx;
	
	#if debug
	inline static private var INVINCIBLE:Bool = false;
	#end
	
	override public function begin():Void {
		Reg.GS = this;
		
		Reg.FADE = new Fade();
		add( Reg.FADE );
		Reg.FADE.add();
		
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
		
		for ( e in _tileMap.smusherPositions ) {
			var enemy:Enemy = new Enemy( e.x, e.y, "images/smusher.png", 96, 96 );
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
		
		if ( _finalBoss != null ) {
			_nextfire = 0;
			_fireArray = new Array<Body>();
			
			for ( i in 0...10 ) {
				var ent:Body = new Body( 2200, 0, new Image( "images/bossfire.png" ), 63, 63 );
				ent.visible = false;
				ent.velocity.x = 3;
				ent.velocity.y = 3;
				ent.setHitbox( 63, 63, 0, 0 );
				_fireArray.push( ent );
				_fireArray[i].layer = Reg.LAYER_ENEMY;
				add( _fireArray[i] );
			}
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
		
		// Set up arrows
		
		_arrowInd = new TextEntity( "Arrows: " + Reg.totalArrows, 32 );
		_arrowInd.x = 10;
		_arrowInd.y = 444;
		_arrowInd.scrollX = 0;
		_arrowInd.scrollY = 0;
		_arrowInd.layer = Reg.LAYER_HUD;
		
		_arrowGroup = new Array<Arrow>();
		
		for ( i in 0...20 ) {
			var arr:Arrow = new Arrow();
			_arrowGroup.push( arr );
			arr.visible = false;
		}
		
		_nextArrowLaunched = 0;
		
		Reg.PARTICLES = new Particles();
		Reg.LASERBEAM = new Laserbeam();
		Reg.BLASTER = new Blaster();
		Reg.BLASTER.layer = Reg.LAYER_ENEMY;
		Reg.BLASTER.visible = false;
		
		Reg.ARROW = new Arrow();
		Reg.ARROW.visible = false;
		
		var img:Image = new Image( new BitmapData( 640, 480, true, 0x88000000 ) );
		img.scrollX = 0;
		img.scrollY = 0;
		_pauseDark = new Entity( 0, 0, img );
		_pauseText = new TextEntity( "Game Paused", 32 );
		_pauseText.scrollX = 0;
		_pauseText.scrollY = 0;
		_pauseText.x = 200;
		_pauseText.y = 200;
		_pauseDark.visible = false;
		_pauseText.visible = false;
		_pauseDark.layer = Reg.LAYER_FADE;
		_pauseText.layer = Reg.LAYER_FADE;
		
		add( _tileMap );
		add( _player );
		add( Reg.PARTICLES );
		add( Reg.LASERBEAM );
		add( Reg.BLASTER );
		add( Reg.ARROW );
		add( _foreground );
		add( _arrowInd );
		add( _pauseDark );
		add( _pauseText );
		
		// Set up sounds
		
		_sndArrow = new Sfx( "arrow" );
		_sndBlaster = new Sfx( "blaster" );
		_sndBoss = new Sfx( "boss" );
		_sndBow = new Sfx( "bow" );
		_sndCave = new Sfx( "cave" );
		_sndClimb = new Sfx( "climb" );
		_sndForest = new Sfx( "forest" );
		_sndGhost = new Sfx( "ghost" );
		_sndHurt = new Sfx( "hurt" );
		_sndJump = new Sfx( "jump" );
		_sndNinja = new Sfx( "ninja" );
		_sndSmusher = new Sfx( "smusher" );
		_sndSpider = new Sfx( "spider" );
		_sndSpike = new Sfx( "spike" );
		_sndTreasure = new Sfx( "treasure" );
		_sndVillage = new Sfx( "village" );
		_sndWalk = new Sfx( "walk" );
		
		if ( Reg.level == 0 ) {
			playSound( "village" );
		} else if ( Reg.level == 1 ) {
			playSound( "forest" );
		} else {
			playSound( "cave" );
		}
		
		Reg.FADE.fadeIn( 1 );
		super.begin();
	} // end begin
	
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
		
		if ( Input.pressed( Key.P ) ) {
			_paused = !_paused;
			
			if ( _paused ) {
				_pauseDark.visible = true;
				_pauseText.visible = true;
			} else {
				_pauseDark.visible = false;
				_pauseText.visible = false;
			}
		}
		
		if ( _paused ) {
			return;
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
			Reg.FADE.fadeOut( 1, nextLevel );
		}
		
		for ( i in 0..._treasureBoxes.length ) {
			if ( _treasureBoxes[i].collideWith( _player ) ) {
				if ( Input.check( Key.X ) ) {
					if ( _treasures[i].open() ) {
						var arrowPickup:ArrowsPlus = new ArrowsPlus( _treasures[i].x, _treasures[i].y );
						add( arrowPickup );
					}
				}
			}
		}
		
		// What follows is probably the cheesiest collision code ever written.
		
		var playerHitEnemy:Enemy = null;
		
		if ( !_invincible ) {
			for ( enemy in _enemies ) {
				if ( enemy.getType() == "smusher" ) {
					if ( _player.fx > enemy.x - enemy.originX ) {
						if ( _player.fy > enemy.y - enemy.originY ) {
							if ( _player.x < enemy.x + enemy.width -  enemy.originX ) {
								if ( _player.y < enemy.y + enemy.height - enemy.originY ) {
									playerHitEnemy = enemy;
								}
							}
						}
					}
				} else {
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
			}
		}
		
		if ( playerHitEnemy != null ) {
			if ( playerHitEnemy.getType() == "spider" ) {
				_player.mint( playerHitEnemy );
				addAHeart();
			} else if ( playerHitEnemy.getType() == "smusher" ) {
				if ( playerHitEnemy.smushing() ) {
					_player.hurt( playerHitEnemy );
					takeAheart();
				}
			} else if ( _player.hurt( playerHitEnemy ) ) {
				takeAheart();
			}
		}
		
		var hitEnemy:Enemy = null;
		var hitArrow:Arrow = null;
		
		for ( enemy in _enemies ) {
			for ( arrow in _arrowGroup ) {
				if ( arrow.fx > enemy.x ) {
					if ( arrow.fy > enemy.y ) {
						if ( arrow.x < enemy.fx ) {
							if ( arrow.y < enemy.fy ) {
								hitEnemy = enemy;
								hitArrow = arrow;
							}
						}
					}
				}
			}
		}
		
		if ( hitEnemy != null ) {
			hitEnemy.hurt( hitArrow.damage, hitArrow.getBox() );
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
		
		if ( !_invincible ) {
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
		}
		
		if ( _invincible ) {
			_player.visible = !_player.visible;
			
			_invTimer -= HXP.elapsed;
			
			if ( _invTimer < 0 ) {
				_invincible = false;
				_player.visible = true;
			}
		}
		
		// FINAL BOSS
		
		if ( _finalBoss != null ) {
			for ( arrow in _arrowGroup ) {
				if ( _finalBoss != null ) {
					if ( arrow.fx > _finalBoss.x ) {
						if ( _finalBoss != null ) {
							if ( arrow.fy > _finalBoss.y ) {
								if ( _finalBoss != null ) {
									if ( arrow.x < _finalBoss.fx ) {
										if ( _finalBoss != null ) {
											if ( arrow.y < _finalBoss.fy ) {
												_finalBoss.hurt( arrow.damage );
											}
										}
									}
								}
							}
						}
					}
				}
			}
			
			for ( beam in Reg.LASERBEAM.boxes ) {
				if ( beam.fx > _finalBoss.x ) {
					if ( beam.fy > _finalBoss.y ) {
						if ( beam.x < _finalBoss.x + _finalBoss.getWidth() ) {
							if ( beam.y < _finalBoss.y + _finalBoss.getHeight() ) {
								if ( Reg.LASERBEAM.hasDamage ( beam ) ) {
									_finalBoss.hurt( 2.5 );
									Reg.LASERBEAM.noDamage( beam );
								}
							}
						}
					}
				}
			}
			
			if ( !_invincible ) {
				if ( _finalBoss != null ) {
					if ( _player.fx > _finalBoss.x ) {
						if ( _player.fy > _finalBoss.y ) {
							if ( _player.x < _finalBoss.fx ) {
								if ( _player.y < _finalBoss.fy ) {
									takeAheart();
									
									if ( _player.hurtBoss() ) {
										takeAheart();
									}
								}
							}
						}
					}
				}
			}
			/*
			for ( f in _fireArray ) {
				if ( f.visible ) {
					f.moveBy( f.velocity.x, f.velocity.y );
				}
				var b:Box = new Box( f.x, f.y, 63, 63 );
				if ( b.collideWith( _player ) ) {
					takeAheart;
					
					if ( _player.hurtBoss() ) {
						takeAheart;
					}
				}
			}*/
		}
		
		_arrowInd.text = "Arrows: " + Reg.totalArrows;
		
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
		if ( Input.released( Key.G ) ) {
			HXP.scene = new GameOverScene();
		}
		if ( Input.released( Key.T ) ) {
			HXP.scene = new EndScene();
		}
		if ( Input.released( Key.K ) ) {
			_finalBoss.hurt( 199 );
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
	
	public function removeNinja():Void {
		if ( _redNinja != null ) {
			remove( _redNinja );
			_redNinja = null;
		}
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
		Reg.totalArrows --;
	}
	
	public function addArrows( AmountToAdd:Int ):Void {
		Reg.totalArrows += AmountToAdd;
	}
	
	public function numArrows():Int {
		return Reg.totalArrows;
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
	
	public function launchArrow( VelocityX:Float ):Void {
		var arr:Arrow = _arrowGroup[ _nextArrowLaunched ];
		arr.x = Reg.ARROW.x;
		arr.y = Reg.ARROW.y;
		arr.velocity.x = VelocityX;
		
		if ( !arr.visible ) {
			arr.visible = true;
			add( arr );
		}
		
		_nextArrowLaunched++;
		
		if ( _nextArrowLaunched > 19 ) {
			_nextArrowLaunched = 0;
		}
	}
	
	public function setNextArrow( Flipped:Bool, Damage:Int = 5 ):Void {
		_arrowGroup[ _nextArrowLaunched ].flipped = Flipped;
		_arrowGroup[ _nextArrowLaunched ].damage = Damage;
	}
	
	public function nextLevel():Void {
		Reg.level++;
		HXP.scene = new GameScene();
	}
	
	private function gameover():Void {
		HXP.scene = new GameOverScene();
	}
	
	public function gotBone():Void {
		var flash:Flash = new Flash( endGame );
		add( flash );
	}
	
	public function endGame():Void {
		Reg.FADE.fadeOut( 5, goToEnd );
	}
	
	public function goToEnd():Void {
		HXP.scene = new EndScene();
	}
	
	public function playSound( Desired:String ):Void {
		switch ( Desired ) {
			case "arrow":
				_sndArrow.play();
			case "blaster":
				_sndBlaster.play();
			case "boss":
				_sndBoss.play();
			case "bow":
				_sndBow.play();
			case "cave":
				_sndCave.play();
			case "climb":
				_sndClimb.play();
			case "forest":
				_sndForest.play();
			case "ghost":
				_sndGhost.play();
			case "hurt":
				_sndHurt.play();
			case "jump":
				_sndJump.play();
			case "ninja":
				_sndNinja.play();
			case "smusher":
				_sndSmusher.play();
			case "spider":
				_sndSpider.play();
			case "spike":
				_sndSpike.play();
			case "treasure":
				_sndTreasure.play();
			case "village":
				_sndVillage.play();
			case "walk":
				_sndWalk.play();
		}
	}
	
	public function walkPlaying():Bool {
		return _sndWalk.playing;
	}
	
	public function stopWalk():Void {
		_sndWalk.stop();
	}
	
	public function shootFire( X:Float, Y:Float, Flipped:Bool ):Void {
		_fireArray[ _nextfire ].x = X;
		_fireArray[ _nextfire ].y = Y;
		//_fireArray[ _nextfire ].flipped = Flipped;
		_fireArray[ _nextfire ].visible = true;
		
		if ( _player.x < X ) {
			_fireArray[ _nextfire ].velocity.x = -2;
		}
		
		_fireArray[ _nextfire ].velocity.y = Math.abs( _player.x - X ) / Math.abs( _player.y - Y );
		
		_nextfire ++;
		
		if ( _nextfire > 8 ) {
			_nextfire = 0;
		}
	}
	
	public function removeBoss():Void {
		if ( _finalBoss != null ) {
			remove( _finalBoss );
			_finalBoss = null;
		}
	}
}