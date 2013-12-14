package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * Influenced heavily by
 * https://github.com/HaxePunk/HaxePunk/blob/master/examples/src/platformer/entities/Player.hx
 * Because I don't know what I'm doing
 */
class Player extends Body {
	inline static private var MOVE_SPEED:Float = 1.0;
	inline static private var JUMP_HEIGHT:Float = 10.0;
	inline static private var GRAVITY:Float = 0.5;
	inline static private var VELOCITY_MAX_X:Float = 4;
	inline static private var VELOCITY_MAX_Y:Float = 20;
	inline static private var FRICTION_X:Float = 0.75;
	inline static private var FRICTION_Y:Float = 0.0;
	
	override public function new( X:Int, Y:Int ):Void {
		super( X, Y, "images/jack.png", 40, 80 );
		
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
	}
	
	override public function update():Void {
		acceleration.x = acceleration.y = 0;
		
		if ( Input.check( "left" ) ) {
			acceleration.x = -MOVE_SPEED;
		}
		
		if ( Input.check( "right" ) ) {
			acceleration.x = MOVE_SPEED;
		}
		
		if ( Input.pressed( "up" ) && onGround ) {
			acceleration.y = -JUMP_HEIGHT;
		}
		
		if ( Input.pressed( "space" ) ) {
			Reg.PARTICLES.smoke( x, y );
			Reg.PARTICLES.blaster( x, y );
		}
		
		super.update();
	}
}