package;

import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine {
	override public function init() {
		#if debug
		HXP.console.enable();
		HXP.scene = new GameScene();
		#else
		HXP.scene = new MenuScene();
		#end
	}
	
	static public function main() { new Main(); }
}