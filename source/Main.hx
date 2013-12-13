package;

import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine {
	override public function init() {
		#if debug
		HXP.console.enable();
		#end
		HXP.scene = new GameScene();
	}
	
	static public function main() { new Main(); }
}