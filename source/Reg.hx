package;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

class Reg {
	static public var GS:GameScene;
	static public var BLASTER:Entity = new Entity();
	static public var PARTICLES:Particles = new Particles();
	static public var LASERBEAM:Laserbeam = new Laserbeam();
	
	static public function centerX( Object:Entity ) {
		Object.moveTo( Std.int( ( HXP.width - Object.width ) / 2 ), Object.y );
	}
	
	static public function centerY( Object:Entity ) {
		Object.moveTo( Object.x, Std.int( ( HXP.height - Object.height ) / 2 ) );
	}
	
	static public function centerBoth( Object:Entity ) {
		Object.moveTo( Std.int( ( HXP.width - Object.width ) / 2 ), Std.int( ( HXP.height - Object.width ) / 2 ) );
	}
}