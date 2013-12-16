package;

import com.haxepunk.HXP;

class Bone extends Body {
	private var _width:Int;
	private var _height:Int;
	
	public function new( X:Float, Y:Float ) {
		super( X, Y, "images/bone.png", 51, 15 );
		
		_width = 51;
		_height = 15;
		
		setHitbox( _width, _height, -0, 0 );
		
		gravity.y = 0.25;
		velocityMax.x = 4;
		velocityMax.y = 20;
		friction.x = 0.5;
		friction.y = 0.5;
		
		velocity.y = -10;
		
		layer = Reg.LAYER_ITEM;
	}
	
	override public function update():Void {
		if ( visible ) {
			if ( x + _width > Reg.GS.playerX() ) {
				if ( y + _height > Reg.GS.playerY() ) {
					if ( x < Reg.GS.playerX() + 40 ) {
						if ( y < Reg.GS.playerY() + 80 ) {
							Reg.GS.gotBone();
							visible = false;
						}
					}
				}
			}
		}
		
		super.update();
	}
}