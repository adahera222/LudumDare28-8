package;

class Blaster extends Body {
	public function new() {
		super( 0, 0, "images/blaster.png", 27, 18 );
	}
	
	public function faceRight( ShouldFaceRight:Bool ) {
		_sprite.flipped = ShouldFaceRight;
	}
}