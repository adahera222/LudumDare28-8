package;

class Treasure extends Body {
	private var _opened:Bool = false;
	
	public function new( X:Float, Y:Float ) {
		super( X, Y, "images/treasure.png", 40, 40 );
		_sprite.add( "close", [0] );
		_sprite.add( "open", [1] );
		setHitbox( 40, 40 );
		layer = Reg.LAYER_ITEM;
		gravity.y = 1.0;
		velocityMax.y = 20;
		velocityMax.x = 4;
		friction.x = 0.75;
		friction.y = 0;
	}
	
	public function open():Bool {
		var giveItem:Bool = false;
		
		if ( !_opened ) {
			_sprite.play( "open" );
			Reg.GS.playSound( "treasure" );
			_opened = true;
			giveItem = true;
		}
		
		return giveItem;
	}
	
	override public function update():Void {
		acceleration.x = acceleration.y = 0;
		
		super.update();
	}
}