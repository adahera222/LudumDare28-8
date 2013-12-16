package;

class FinalBoss extends Body {
	private var _width:Int;
	private var _height:Int;
	private var _droppedBone:Bool = false;
	
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
	
	override public function update():Void {
		// if killed
		if ( !_droppedBone ) {
			var bone:Bone = new Bone( x + _width / 2, y );
			Reg.GS.add( bone );
			_droppedBone = true;
		}
		
		super.update();
	}
}