package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Ease;
import flash.display.BitmapData;
import flash.geom.Matrix;

class Laserbeam extends Entity {
	public var boxes:Array<Box>;
	
	private var _beams:Array<Entity>;
	private var _thisBeamRight:Array<Bool>;
	private var _beamHasDamage:Array<Bool>;
	private var _lastBeamEmitted:Int = 0;
	
	public function new() {
		super();
		
		boxes = new Array<Box>();
		_beams = new Array<Entity>();
		_thisBeamRight = new Array<Bool>();
		_beamHasDamage = [ false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false ];
		
		for ( i in 0...20 ) {
			_beams.push( new Entity( 0, 0, new Image( new BitmapData( 10, 3, false, 0xffFF0000 ) ) ) );
			_beams[i].visible = false;
		}
		
		layer = Reg.LAYER_PARTICLE;
	}
	
	public function beam( X:Float, Y:Float, Direction:Int = 0, NumParticles:Int = 1 ):Void {
		if ( _lastBeamEmitted > _beams.length - 1 ) {
			_lastBeamEmitted = 0;
		}
		
		var beamToEmit:Entity = _beams[ _lastBeamEmitted ];
		_lastBeamEmitted++;
		beamToEmit.layer = Reg.LAYER_PARTICLE;
		
		Reg.GS.add( beamToEmit );
		
		beamToEmit.x = X;
		beamToEmit.y = Y;
		_thisBeamRight[ _lastBeamEmitted - 1 ] = ( Direction < 90 ) ? true : false;
		_beamHasDamage[ _lastBeamEmitted - 1 ] = true;
		
		beamToEmit.visible = true;
		
		if ( boxes.length < _beams.length ) {
			boxes.push( new Box( X, Y, 10, 3 ) );
		} else {
			boxes[ _lastBeamEmitted - 1 ] = new Box( X, Y, 10, 3 );
		}
	}
	
	public function hasDamage( BeamBox:Box ):Bool {
		var i:Int = Lambda.indexOf( boxes, BeamBox );
		
		return _beamHasDamage[i];
	}
	
	public function noDamage( BeamBox:Box ):Void {
		var i:Int = Lambda.indexOf( boxes, BeamBox );
		_beamHasDamage[i] = false;
		Reg.GS.remove( _beams[i] );
		_beams[i].visible = false;
	}
	
	override public function update():Void {
		for ( i in 0...boxes.length ) {
			var direction:Int = 5;
			
			if ( !_thisBeamRight[i] ) {
				direction = -5;
			}
			
			if ( _beams[i].visible ) {
				_beams[i].x += direction;
				boxes[i].x = Std.int( _beams[i].x );
				
				if ( !_beams[i].onCamera ) {
					noDamage( boxes[i] );
				}
			}
		}
		
		super.update();
	}
}