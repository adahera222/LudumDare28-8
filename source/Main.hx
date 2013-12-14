package;

import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine {
	override public function init() {
		#if debug
		HXP.console.enable();
		#end
		//HXP.resize( 320, 240 );
		HXP.scene = new GameScene();
	}
	
	static public function main() { new Main(); }
}