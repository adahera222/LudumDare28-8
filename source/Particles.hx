package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;
import flash.display.BitmapData;
import flash.geom.Matrix;

class Particles extends Entity {
	private var _emitter:Emitter;
	
	public function new() {
		super();
		
		var emitterMap:BitmapData = new BitmapData( 6, 2, false, 0 );
		var emitterType1:BitmapData = new BitmapData( 2, 2, false, 0xff888800 );
		var emitterType2:BitmapData = new BitmapData( 2, 2, false, 0xff666666 );
		var emitterType3:BitmapData = new BitmapData( 2, 2, false, 0xff0000FF );
		emitterMap.draw( emitterType1 );
		emitterMap.draw( emitterType2, new Matrix( 1, 0, 0, 1, 2, 0 ) );
		emitterMap.draw( emitterType3, new Matrix( 1, 0, 0, 1, 4, 0 ) );
		_emitter = new Emitter( emitterMap, 2, 2 );
		_emitter.newType( "explosion", [0] );
		_emitter.setMotion( "explosion", 0, 100, 2, 360, -40, 1, Ease.quadOut );
		_emitter.setAlpha( "explosion", 1, 0.1 );
		_emitter.setGravity( "explosion", 0.5 );
		
		_emitter.newType( "smoke", [1] );
		_emitter.setMotion( "smoke", 15, 50, 5, 15, -40, 1, Ease.quadOut );
		_emitter.setAlpha( "smoke", 1, 0 );
		_emitter.setGravity( "smoke", -0.5 );
		
		_emitter.newType( "blaster", [2] );
		_emitter.setMotion( "blaster", -15, 64, 1, 30, 32, 0.25, Ease.quadOut );
		_emitter.setAlpha( "blaster", 1, 0 );
		_emitter.setGravity( "blaster", 0.25 );
		
		layer = Reg.LAYER_PARTICLE;
		graphic = _emitter;
	}
	
	public function explosion( X:Float, Y:Float, NumParticles:Int = 64 ):Void {
		for ( i in 0...NumParticles ) {
			_emitter.emit( "explosion", X, Y );
		}
	}
	
	public function smoke( X:Float, Y:Float, Direction:Int = 15, NumParticles:Int = 16 ):Void {
		_emitter.setMotion( "smoke", Direction, 50, 5, 15, -40, 1, Ease.quadOut );
		
		for ( i in 0...NumParticles ) {
			_emitter.emit( "smoke", X, Y );
		}
	}
	
	public function blaster ( X:Float, Y:Float, Direction:Int = -15, NumParticles:Int = 4 ):Void {
		if ( Direction < 0 ) {
			_emitter.setMotion( "blaster", Direction, 64, 1, 30, 32, 0.25, Ease.quadOut );
		} else {
			_emitter.setMotion( "blaster", Direction, 64, 1, -30, 32, 0.25, Ease.quadOut );
		}
		
		for ( i in 0...NumParticles ) {
			_emitter.emit( "blaster", X, Y );
		}
	}
}