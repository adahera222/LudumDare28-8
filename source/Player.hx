package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * Influenced heavily by
 * https://github.com/HaxePunk/HaxePunk/blob/master/examples/src/platformer/entities/Player.hx
 * Because I don't know what I'm doing
 */
class Player extends Body {
	public var canClimb:Bool = false;
	private var _spriteMap:Spritemap;
	private var _blaster:Sfx;
	private var _drawTime:Float = 0.0;
	private var _mintTimer:Int = -1;
	
	inline static private var MOVE_SPEED:Float = 1.0;
	inline static private var JUMP_HEIGHT:Float = 10.0;
	inline static private var GRAVITY:Float = 0.5;
	inline static private var VELOCITY_MAX_X:Float = 4;
	inline static private var VELOCITY_MAX_Y:Float = 20;
	inline static private var FRICTION_X:Float = 0.75;
	inline static private var FRICTION_Y:Float = 1.0;
	
	override public function new( X:Float, Y:Float ):Void {
		_spriteMap = new Spritemap( "images/jack.png", 40, 80 );
		_spriteMap.add( "idle", [0] );
		_spriteMap.add( "duck", [1] );
		_spriteMap.add( "jump", [3] );
		_spriteMap.add( "run", [2, 3], 8 );
		_spriteMap.add( "blaster", [4] );
		_spriteMap.add( "arrow", [5] );
		
		super( X, Y, _spriteMap, 40, 80 );
		
		layer = Reg.LAYER_PLAYER;
		
		setHitbox( 40, 80, 0, 0 );
		
		// Physics
		
		gravity.y = GRAVITY;
		velocityMax.x = VELOCITY_MAX_X;
		velocityMax.y = VELOCITY_MAX_Y;
		friction.x = FRICTION_X;
		friction.y = FRICTION_Y;
		
		// Input Mapping
		
		Input.define( "left", [ Key.LEFT ] );
		Input.define( "right", [ Key.RIGHT ] );
		Input.define( "up", [ Key.UP ] );
		Input.define( "down", [ Key.DOWN ] );
		Input.define( "space", [ Key.SPACE ] );
		Input.define( "c", [ Key.C ] );
		
		// Sound
		
		_blaster = new Sfx( "blaster" );
	}
	
	override public function update():Void {
		acceleration.x = acceleration.y = 0;
		
		#if debug
		if ( Input.check( Key.Q ) ) {
			velocity.y = -100;
		}
		#end
		
		if ( Input.check( "left" ) ) {
			if ( _spriteMap.frame != 1 ) {
				acceleration.x = -MOVE_SPEED;
			} else {
				if ( !_spriteMap.flipped ) {
					_spriteMap.flipped = true;
				}
			}
		}
		
		if ( Input.check( "right" ) ) {
			if ( _spriteMap.frame != 1 ) {
				acceleration.x = MOVE_SPEED;
			} else {
				if ( _spriteMap.flipped ) {
					_spriteMap.flipped = false;
				}
			}
		}
		
		if ( onGround ) {
			if ( Input.check( "left" ) ) {
				_spriteMap.play( "run" );
			}
			
			if ( Input.check( "right" ) ) {
				_spriteMap.play( "run" );
			}
			
			if ( acceleration.x == 0 ) {
				_spriteMap.play( "idle" );
			}
			
			if ( Input.check( "down" ) ) {
				_spriteMap.play( "duck" );
			}
			
			if ( Input.pressed( "up" ) ) {
				_spriteMap.play( "jump" );
				acceleration.y = -JUMP_HEIGHT;
			}
		} else {
			if ( Input.check( "up" ) && canClimb ) {
				acceleration.y = -MOVE_SPEED;
				
				if ( velocity.y < -velocityMax.x ) {
					velocity.y = -velocityMax.x;
				}
			}
		}
		
		if ( Input.check( "space" ) && _spriteMap.currentAnim != "arrow" ) {
			_spriteMap.play( "blaster" );
			
			var posX:Int = 0;
			var posY:Int = Std.int( y + 27 );
			var emitX:Int = 0;
			var emitY:Int = posY + 5;
			var direction:Int = 15;
			var directionRange:Int = -30;
			
			if ( !_spriteMap.flipped ) {
				posX = Std.int( x + 35 );
				emitX = posX + 27;
			} else {
				posX = Std.int( x - 22 );
				emitX =  posX;
				direction = 165;
				directionRange = 30;
			}
			
			Reg.BLASTER.moveTo( posX, posY );
			Reg.BLASTER.faceRight( _spriteMap.flipped );
			Reg.BLASTER.visible = true;
			
			if ( Input.pressed( "space" ) ) {
				Reg.PARTICLES.smoke( emitX, emitY, direction );
				Reg.PARTICLES.blaster( emitX, emitY, direction + directionRange );
				Reg.LASERBEAM.beam( emitX, emitY, direction );
				_blaster.play();
			}
			
			acceleration.x = 0;
		} else {
			Reg.BLASTER.visible = false;
		}
		
		if ( Input.pressed( "c" ) ) {
			HXP.timeFlag();
		}
		
		if ( Input.check( "c" ) ) {
			_spriteMap.play( "arrow" );
			acceleration.x = 0;
			Reg.ARROW.y = y + 30;
			
			if ( _spriteMap.flipped ) {
				Reg.ARROW.x = x - 5;
			} else {
				Reg.ARROW.x = x + 20;
			}
			
			Reg.ARROW.flipped = _spriteMap.flipped;
			Reg.ARROW.visible = true;
			Reg.ARROW.damage = 5;
		}
		
		if ( Input.released( "c" ) ) {
			var sign:Int = 1;
			
			if ( _spriteMap.flipped ) {
				sign = -1;
			}
			
			Reg.ARROW.velocity.x = sign * HXP.timeFlag() * 20;
		}
		
		canClimb = false;
		
		if ( _mintTimer > 0 ) {
			_mintTimer--;
		}
		
		if ( _mintTimer == 0 ) {
			_mintTimer = -1;
			
			_spriteMap.color = 0xFFFFFF;
			velocityMax.x = VELOCITY_MAX_X;
			velocityMax.y = VELOCITY_MAX_Y;
		}
		
		super.update();
	}
	
	public function hurt( EnemyHurt:Enemy ):Bool {
		var xD:Int = -5;
		var yD:Int = -5;
		
		if ( EnemyHurt.mx < mx ) {
			xD = 5;
		}
		
		if ( EnemyHurt.my < my ) {
			yD = 5;
		}
		
		var getsHurt:Bool = true;
		
		if ( _spriteMap.currentAnim == "duck" ) {
			if ( !_spriteMap.flipped ) {
				if ( xD < 0 ) {
					getsHurt = false;
					xD = Std.int( xD / 5 );
					yD = 0;
					// play block sound
				}
			} else {
				if ( xD > 0 ) {
					getsHurt = false;
					xD = Std.int( xD / 5 );
					yD = 0;
				}
			}
		}
		
		velocity.y += xD;
		velocity.x += yD;
		
		return getsHurt;
	}
	
	public function mint( EnemyHurt:Enemy ):Void {
		_spriteMap.color = 0x88FF88;
		_mintTimer = 100;
		velocityMax.x = VELOCITY_MAX_X / 2;
		velocityMax.y = VELOCITY_MAX_Y / 2;
		hurt( EnemyHurt );
	}
	
	public function thornHurt():Void {
		velocity.y = -10;
	}
}