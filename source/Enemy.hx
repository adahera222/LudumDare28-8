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
	
	override public function new( X:Float, Y:Float, ImagePath:String ):Void {
		super( X, Y, ImagePath, 40, 40 );
		
		setHitbox( 40, 40, 0, 0 );
		
		// Physics
		
		gravity.y = 1.0;
		velocityMax.y = 20;
		velocityMax.x = 4;
		friction.x = 0.75;
		friction.y = 0;// 0.90;
	}
	
	override public function update():Void {
		acceleration.x = acceleration.y = 0;
		
		super.update();
	}
}