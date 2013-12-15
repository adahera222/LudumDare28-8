package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class MenuScene extends Scene {
	private var _title:Sfx;
	
	override public function begin():Void {
		var title:TextEntity = new TextEntity( "The Game of Fun", 64 );
		title.x = 40;
		title.y = 60;
		
		var start:TextEntity = new TextEntity( "Press Space to Begin", 32 );
		start.x = ( HXP.width - 368 ) / 2;
		start.y = ( HXP.height - 36 ) / 2;
		
		var credits:TextEntity = new TextEntity( "A game for Ludum Dare 28.\nArt and concept by Burning Tiger and Burning Wheels,\nage 8 and 4, respectively.\nProgramming by Steve Richey, their dad.", 16 );
		credits.x = 10;
		credits.y = 400;
		
		add( title );
		add( start );
		add( credits );
		
		_title = new Sfx( "title" );
		_title.play();
		
		super.begin();
	}
	
	override public function update():Void {
		if ( Input.released( Key.SPACE ) ) {
			HXP.scene = new StoryScene();
		}
		
		super.update();
	}
	
	override public function end():Void {
		_title.stop();
		_title = null;
		
		super.end();
	}
}