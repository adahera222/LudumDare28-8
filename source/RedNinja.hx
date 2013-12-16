package;

class RedNinja extends Body {
	private var _width:Int;
	private var _height:Int;
	
	public function new( X:Float, Y:Float ) {
		super( X, Y, "images/ninja_big.png", 128, 160 );
		
		_width = 128;
		_height = 160;
		
		setHitbox( _width, _height );
		
		gravity.y = 1.0;
		velocityMax.x = 4;
		velocityMax.y = 20;
		friction.x = 0.5;
		friction.y = 0.5;
		
		layer = Reg.LAYER_ENEMY;
	}
}