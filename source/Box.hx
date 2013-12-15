package;

class Box {
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	
	public function new( X:Float, Y:Float, Width:Float, Height:Float ) {
		x = Std.int( X );
		y = Std.int( Y );
		width = Std.int( Width );
		height = Std.int( Height );
	}
	
	public function collideWith( Object:Body ):Bool {
		var colliding:Bool = false;
		
		if ( Object.fx > x ) {
			if ( Object.fy > y ) {
				if ( Object.x < x + width ) {
					if ( Object.y < y + height ) {
						colliding = true;
					}
				}
			}
		}
		
		
		return colliding;
	}
}