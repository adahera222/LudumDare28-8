package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * Influenced heavily by
 * https://github.com/HaxePunk/HaxePunk/blob/master/examples/src/platformer/entities/Player.hx
 * Because I don't know what I'm doing
 */
class Enemy extends Body {
	inline static private var MOVE_SPEED:Float = 1.0;
	inline static private var JUMP_HEIGHT:Float = 20.0;
	
	private var _health:Int = 15;
	private var _enemyType:String = "";
	private var _width:Int;
	private var _height:Int;
	
	override public function new( X:Float, Y:Float, ImagePath:String, Width:Int, Height:Int ):Void {
		super( X, Y, ImagePath, Width, Height );
		
		
		_width = Width;
		_height = Height;
		
		setHitbox( Width, Height, 0, 0 );
		layer = Reg.LAYER_ENEMY;
		var typeLen:Int = ImagePath.indexOf( "." );
		_enemyType = ImagePath.substring( 7, typeLen );
		
		// Physics
		
		if ( _enemyType == "ghost" ) {
			gravity.y = 0.0;
		} else {
			gravity.y = 1.0;
		}
		
		velocityMax.y = 20;
		velocityMax.x = 5;
		friction.x = 0.5;
		friction.y = 0.5;// 0.90;
		
		if ( _enemyType == "spike" ) {
			velocity.x = ( Math.random() < 0.5 ) ? 1 : -1;
			friction.x = 1;
		}
		
		// Animation
		
		if ( _enemyType == "ninja_sm" ) {
			_sprite.add( "run", [ 0, 1, 2 ], 8 );
			_sprite.play( "run" );
		}
	}
	
	public function getType():String {
		return _enemyType;
	}
	
	public function hurt( Damage:Int, ?HitBox:Box ):Void {
		_health -= Damage;
		
		if ( Damage > 0 ) {
			if ( HitBox == null ) {
				Reg.PARTICLES.explosion( Reg.ARROW.x + 35, Reg.ARROW.y + 5, 16 );
			} else {
				Reg.PARTICLES.explosion( HitBox.x + HitBox.width, HitBox.y + HitBox.height / 2, 16 );
			}
		}
		
		velocity.x += Damage;
		velocity.y -= Damage;
		
		if ( _health <= 0 ) {
			Reg.PARTICLES.explosion( this.x + _width / 2, this.y + _height / 2 );
			Reg.GS.removeEnemy( this );
		}
	}
	
	override public function update():Void {
		acceleration.x = acceleration.y = 0;
		
		if ( Reg.GS.playerX() > x ) {
			if ( !_sprite.flipped ) {
				_sprite.flipped = true;
			}
		} else {
			if ( _sprite.flipped ) {
				_sprite.flipped = false;
			}
		}
		
		if ( _enemyType == "ghost" ) {
			moveTowards( Reg.GS.playerX(), Reg.GS.playerY(), 1 );
		} else if ( _enemyType == "spider" ) {
			if ( Math.random() < 0.01 ) {
				velocity.x = 5 - Math.random() * 10;
				velocity.y = -10;
			}
		} else if ( _enemyType == "spike" ) {
			if ( Math.random() < 0.01 ) {
				velocity.x *= -1;
			}
		}
		
		super.update();
	}
}