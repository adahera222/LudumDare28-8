package;

import com.haxepunk.HXP;
import com.haxepunk.Entity;

class Arrow extends Body {
	private var _damage:Int = 5;
	private var _width:Int = 35;
	private  var _height:Int = 10;
	
	public function new() {
		super( 0, 0, "images/arrow.png", 35, 10 );
		setHitbox( 35, 10 );
		layer = Reg.LAYER_ENEMY;
		gravity.y = 0.1;
		velocityMax.y = 2;
		velocityMax.x = 200;
		friction.x = 0;
		friction.y = 1.0;
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
	
	override public function update():Void {
		acceleration.x = acceleration.y = 0;
		
		super.update();
	}
	
	public var damage(get, set):Int;
	
	private function get_damage():Int {
		var temp:Int = _damage;
		_damage = 0;
		return temp;
	}
	
	private function set_damage( NewDamage:Int ):Int {
		_damage = NewDamage;
		
		return _damage;
	}
	
	public function getBox():Box {
		return new Box( x, y, _width, _height );
	}
}