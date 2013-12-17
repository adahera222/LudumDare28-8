package;
import com.haxepunk.HXP;

class FinalBoss extends Body {
	private var _width:Int;
	private var _height:Int;
	private var _droppedBone:Bool = false;
	private var _health:Float = 200;
	private var _landed:Bool = false;
	private var _init:Bool = false;
	private var _invincible:Bool = false;
	private var _invTimer:Float = 0.0;
	
	public function new( X:Float, Y:Float ) {
		super( X, Y, "images/boss.png", 297, 282 );
		
		_sprite.add( "idle", [0] );
		_sprite.add( "fire", [1,0], 1, false );
		_sprite.add( "jump", [2] );
		
		_width = 297;
		_height = 282;
		
		setHitbox( _width, _height );
		
		gravity.y = 1.0;
		velocityMax.x = 4;
		velocityMax.y = 20;
		friction.x = 0.5;
		friction.y = 0.5;
		
		layer = Reg.LAYER_ENEMY;
	}
	
	override public function update():Void {
		if ( Reg.GS.playerX() > x - 50 ) {
			_init = true;
		}
		
		if ( !_init ) {
			return;
		}
		
		if ( !_landed && onGround ) {
			_sprite.play( "idle", true );
			Reg.GS.playSound( "boss" );
			_landed = true;
		}
		
		if ( Reg.GS.playerX() < mx ) {
			_sprite.flipped = true;
		} else {
			_sprite.flipped = false;
		}
		
		var chance:Float = Math.random();
		
		if ( chance < 0.01 && onGround ) {
			_sprite.play( "jump", true );
			
			velocity.y -= 20;
			
			if ( Reg.GS.playerX() < x ) {
				velocity.x -= 20;
			} else {
				velocity.x += 20;
			}
			
			_landed = false;
		}
		
		if ( chance > 0.99 && onGround ) {
			_sprite.play( "fire", true );
			//if ( _sprite.flipped ) {
			//	Reg.GS.shootFire( x, y, true );
			//} else {
			//	Reg.GS.shootFire( x + 235, y, false );
			//}
		}
		
		if ( _invTimer > 0 ) {
			_invTimer -= HXP.elapsed;
			
			if ( _invTimer < 0 ) {
				_invincible = false;
			}
		} else if ( _invincible ) {
			_invincible = false;
		}
		
		super.update();
	}
	
	public function hurt( Damage:Float ) {
		_health -= Damage;
		
		Reg.PARTICLES.explosion( mx, my, Std.int( Damage ) );
		
		_invincible = true;
		_invTimer = 2;
		
		if ( _health <= 0 ) {
			var bone:Bone = new Bone( x + _width / 2, y );
			Reg.GS.add( bone );
			Reg.GS.removeBoss();
		}
	}
	
	public function getWidth():Int {
		return _width;
	}
	
	public function getHeight():Int {
		return _height;
	}
}