package;

class Treasure extends Body {
	public function new( X:Float, Y:Float ) {
		super( X, Y, "images/treasure.png", 40, 40 );
		setHitbox( 40, 40 );
		layer = Reg.LAYER_ITEM;
		gravity.y = 1.0;
	}
	
	override public function update():Void {
		acceleration.x = acceleration.y = 0;
		
		super.update();
	}
}