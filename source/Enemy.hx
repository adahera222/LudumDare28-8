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
	
	override public function new( X:Float, Y:Float, ImagePath:String, Width:Int, Height:Int ):Void {
		super( X, Y, ImagePath, Width, Height );
		
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
	}
	
	public function hurt( Damage:Int ):Void {
		_health -= Damage;
		
		velocity.x += Damage;
		velocity.y -= Damage;
		
		if ( _health <= 0 ) {
			Reg.GS.removeEnemy( this );
		}
	}
	
	override public function update():Void {
		acceleration.x = acceleration.y = 0;
		
		if ( _enemyType == "ghost" ) {
			moveTowards( Reg.GS.playerX(), Reg.GS.playerY(), 1 );
		} else if ( _enemyType == "spider" ) {
			
		} else if ( _enemyType == "spike" ) {
			
		}
		
		super.update();
	}
}