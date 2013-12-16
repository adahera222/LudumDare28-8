package;

import com.haxepunk.HXP;

class ArrowsPlus extends Body {
	private var _width:Int;
	private var _height:Int;
	private var _timer:Float;
	
	public function new( X:Float, Y:Float ) {
		super( X, Y, "images/arrowbundle.png", 35, 10 );
		
		_width = 35;
		_height = 10;
		
		setHitbox( _width, _height, -32, 0 );
		
		gravity.y = 1.0;
		velocityMax.x = 4;
		velocityMax.y = 20;
		friction.x = 0.5;
		friction.y = 0.5;
		
		velocity.x = 5;
		velocity.y = -5;
		
		_timer = 1;
		
		layer = Reg.LAYER_ITEM;
	}
	
	override public function update():Void {
		if ( _timer >= 0 ) {
			_timer -= HXP.elapsed;
		}
		
		if ( _timer < 0 ) {
			if ( visible ) {
				if ( x + _width > Reg.GS.playerX() ) {
					if ( y + _height > Reg.GS.playerY() ) {
						if ( x < Reg.GS.playerX() + 40 ) {
							if ( y < Reg.GS.playerY() + 80 ) {
								Reg.GS.addArrows( 20 );
								visible = false;
							}
						}
					}
				}
			}
		}
		
		super.update();
	}
}