package;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import flash.geom.Point;

class Body extends Entity {
	public var acceleration:Point;
	public var friction:Point;
	public var gravity:Point;
	public var velocity:Point;
	public var velocityMax:Point;
	
	public var onGround(get, null):Bool;
	
	private function get_onGround():Bool {
		return _onGround;
	}
	
	public static var solid:String = "solid";
	
	private var _onGround:Bool = false;
	private var _sprite:Spritemap;
	
	public function new( X:Int, Y:Int, SpritePath:String, Width:Int, Height:Int ) {
		super( X, Y );
		
		_sprite = new Spritemap( SpritePath, Width, Height );
		graphic = _sprite;
		
		acceleration = new Point();
		friction = new Point();
		gravity = new Point();
		velocity = new Point();
		velocityMax = new Point();
	}
	
	override public function moveCollideY( e:Entity ):Bool {
		if ( velocity.y * HXP.sign( gravity.y ) > 0 ) {
			_onGround = true;
		}
		
		velocity.y = 0;
		
		velocity.x *= friction.x;
		
		if ( Math.abs( velocity.x ) < 0.5 ) {
			velocity.x = 0;
		}
		
		return true;
	}
	
	override public function moveCollideX( e:Entity ):Bool {
		velocity.x = 0;
		velocity.y *= friction.y;
		
		if ( Math.abs( velocity.y ) < 1 ) {
			velocity.y = 0;
		}
		
		return true;
	}
	
	override public function update():Void {
		// Velocity
		
		velocity.x += acceleration.x;
		velocity.y += acceleration.y;
		_onGround = false;
		moveBy( velocity.x, velocity.y, solid, true );
		
		// Gravity
		
		velocity.x += gravity.x;
		velocity.y += gravity.y;
		
		// Max Velocity
		
		if ( Math.abs( velocity.x ) > velocityMax.x ) {
			var sign:Int = ( velocity.x < 0 ) ? -1 : 1;
			velocity.x = velocityMax.x * sign;
		}
		
		if ( Math.abs( velocity.y ) > velocityMax.y ) {
			var sign:Int = ( velocity.y < 0 ) ? -1 : 1;
			velocity.y = velocityMax.y * sign;
		}
		
		if ( velocity.x < 0 ) {
			_sprite.flipped = true;
		} else if ( velocity.x > 0 ) {
			_sprite.flipped = false;
		}
		
		super.update();
	}
}