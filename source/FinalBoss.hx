package;

class FinalBoss extends Body {
	private var _width:Int;
	private var _height:Int;
	
	public function new( X:Float, Y:Float ) {
		super( X, Y, "images/boss.png", 297, 282 );
		
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
}