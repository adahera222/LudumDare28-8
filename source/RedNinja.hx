package;
import com.haxepunk.HXP;

class RedNinja extends Body {
	private var _width:Int;
	private var _height:Int;
	private var _jumpTime:Float = 0.0;
	private var _health:Float = 75;
	
	public function new( X:Float, Y:Float ) {
		super( X, Y, "images/ninja_big.png", 128, 160 );
		
		_sprite.add( "run", [ 0, 1, 2 ], 8 );
		_sprite.play( "run" );
		
		_width = 64;
		_height = 160;
		
		setHitbox( _width, _height, -32, 0 );
		
		gravity.y = 1.0;
		velocityMax.x = 4;
		velocityMax.y = 20;
		friction.x = 0.5;
		friction.y = 0.5;
		
		layer = Reg.LAYER_ENEMY;
	}
	
	public function getWidth():Int {
		return _width;
	}
	
	public function getHeight():Int {
		return _height;
	}
	
	override public function update():Void {
		moveTowards( Reg.GS.playerX(), y, 1, "solid" );
		
		for ( beam in Reg.LASERBEAM.boxes ) {
			if ( beam.fx > x ) {
				if ( beam.fy > y ) {
					if ( beam.x < fx ) {
						if ( beam.y < fy ) {
							if ( Reg.LASERBEAM.hasDamage ( beam ) ) {
								Reg.LASERBEAM.noDamage( beam );
								
								if ( beam.x < x ) {
									velocity.x += 10;
								} else {
									velocity.x -= 10;
								}
								
								velocity.y -= 5;
								
								_health -= 5;
								
								Reg.GS.playSound( "ninja" );
							}
						}
					}
				}
			}
		}
		
		super.update();
		
		if ( _jumpTime > 3 && _onGround ) {
			velocity.y = -30;
			_jumpTime = 0;
		}
		
		if ( Reg.GS.playerX() > mx ) {
			_sprite.flipped = true;
		} else {
			_sprite.flipped = false;
		}
		
		_jumpTime += HXP.elapsed;
		
		if ( _health < 0 ) {
			Reg.GS.removeNinja();
		}
	}
}