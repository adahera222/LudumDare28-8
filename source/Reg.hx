package;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

class Reg {
	static public var level:Int = 0;
	
	static public var GS:GameScene;
	static public var BLASTER:Blaster;
	static public var ARROW:Arrow;
	static public var PARTICLES:Particles = new Particles();
	static public var LASERBEAM:Laserbeam = new Laserbeam();
	
	static public var LAYER_HUD:Int = 0;
	static public var LAYER_FOREGROUND:Int = 1;
	static public var LAYER_PLAYER:Int = 2;
	static public var LAYER_PARTICLE:Int = 3;
	static public var LAYER_ENEMY:Int = 4;
	static public var LAYER_ITEM:Int = 5;
	static public var LAYER_MAP:Int = 6;
	
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