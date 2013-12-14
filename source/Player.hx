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
class Player extends Body {
	inline static private var MOVE_SPEED:Float = 1.0;
	inline static private var JUMP_HEIGHT:Float = 20.0;
	
	override public function new( X:Int, Y:Int ):Void {
		super( X, Y, "images/jack.png", 40, 80 );
		
		setHitbox( 40, 80, 0, 0 );
		
		// Physics
		
		gravity.y = 1.8;
		velocityMax.y = 20;
		velocityMax.x = 4;
		friction.x = 0.75;
		friction.y = 0.90;
		
		// Input Mapping
		
		Input.define( "left", [ Key.LEFT ] );
		Input.define( "right", [ Key.RIGHT ] );
		Input.define( "up", [ Key.UP ] );
		Input.define( "down", [Key.DOWN ] );
	}
	
	override public function update():Void {
		acceleration.x = acceleration.y = 0;
		
		if ( Input.check( "left" ) ) {
			acceleration.x = -MOVE_SPEED;
		}
		
		if ( Input.check( "right" ) ) {
			acceleration.x = MOVE_SPEED;
		}
		
		if ( Input.check( "up" ) && onGround ) {
			acceleration.y = -JUMP_HEIGHT;
		}
		
		super.update();
	}
}