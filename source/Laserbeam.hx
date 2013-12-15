package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;
import flash.display.BitmapData;
import flash.geom.Matrix;

class Laserbeam extends Entity {
	private var _emitter:Emitter;
	
	public function new() {
		super();
		
		var beam:BitmapData = new BitmapData( 10, 3, false, 0xff0000DD );
		_emitter = new Emitter( beam, 10, 3 );
		_emitter.newType( "beam", [0] );
		_emitter.setMotion( "beam", 0, 512, 2, 0, 0, 0 );
		_emitter.setAlpha( "beam", 1, 0.5 );
		_emitter.setGravity( "beam", 0 );
		
		graphic = _emitter;
	}
	
	public function beam( X:Float, Y:Float, NumParticles:Int = 1 ):Void {
		for ( i in 0...NumParticles ) {
			_emitter.emit( "beam", X, Y );
		}
	}
}