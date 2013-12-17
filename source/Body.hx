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
	
	public var fx(get, null):Int;
	
	private function get_fx():Int {
		return Std.int( x + width );
	}
	
	public var fy(get, null):Int;
	
	private function get_fy():Int {
		return Std.int( y + height );
	}
	
	public var mx(get, null):Int;
	
	private function get_mx():Int {
		return Std.int( x + width / 2 );
	}
	
	public var my(get, null):Int;
	
	private function get_my():Int {
		return Std.int( y + height / 2 );
	}
	
	public static var solid:String = "solid";
	
	private var _onGround:Bool = false;
	private var _sprite:Spritemap;
	
	public function new( X:Float, Y:Float, Graphic:Dynamic, Width:Int, Height:Int ) {
		super( Std.int( X ), Std.int( Y ) );
		
		if ( Std.is( Graphic, String ) ) {
			_sprite = new Spritemap( Graphic, Width, Height );
		} else if ( Std.is( Graphic, Spritemap ) ) {
			_sprite = Graphic;
		}
		
		graphic = _sprite;
		
		acceleration = new Point();
		friction = new Point();
		gravity = new Point();
		velocity = new Point();
		velocityMax = new Point();
	}
	
	public var flipped(get, set):Bool;
	
	private function get_flipped():Bool {
		return _sprite.flipped;
	}
	
	private function set_flipped( f:Bool ):Bool {
		_sprite.flipped = f;
		
		return _sprite.flipped;
	}
	
	override public function moveCollideY( e:Entity ):Bool {
		if ( velocity.y * HXP.sign( gravity.y ) > 0 ) {
			_onGround = true;
		}
		
		velocity.y = 0;
		
		velocity.x *= friction.x;
		
		if ( Math.abs( velocity.x ) < 0.5 ) {
			//velocity.x = 0;
		}
		
		return true;
	}
	
	override public function moveCollideX( e:Entity ):Bool {
		//velocity.x = 0;
		//velocity.y *= friction.y;
		
		if ( Math.abs( velocity.y ) < 1 ) {
			//velocity.y = 0;
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