package;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Tween;
import com.haxepunk.tweens.motion.LinearPath;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class StoryScene extends Scene {
	private var _white:TextEntity;
	private var _black:TextEntity;
	private var _spaceOnce:Bool;
	
	inline static private var STORY_TEXT:String = "When you are playing your name is Jack.\n\nYou start in his village.\n\nYour goal is to go to a cave and in the cave there is a monster\nyou have to fight and get this mysterious bone that is made of\ngold and diamond and get it to your grandfather. Because he is\nan archaeologist.\n\nAnd there is hidden treasure chests. And traps.\n\nYou start out with a bow with 20 arrows and\na blaster with unlimited ammo.";
	
	override public function begin():Void {
		Reg.FADE = new Fade();
		add( Reg.FADE );
		Reg.FADE.add();
		
		_black = new TextEntity( STORY_TEXT, 16 );
		_black.color = 0x000000;
		_white = new TextEntity( STORY_TEXT, 16 );
		
		_white.x = 20;
		_black.x = 22;
		_white.y = 480;// 480;
		_black.y = 482;// 482;
		
		add( _black );
		add( _white );
		
		super.begin();
		
		Reg.FADE.fadeIn( 2 );
	}
	
	override public function update():Void {
		_white.y -= 0.25;
		_black.y = _white.y + 2;
		
		if ( _black.y < -210 ) {
			Reg.FADE.fadeOut( 2, function() { HXP.scene = new GameScene(); } );
		}
		
		if ( Input.pressed( Key.SPACE ) ) {
			if ( _spaceOnce ) {
				Reg.FADE.fadeOut( 2, function() { HXP.scene = new GameScene(); } );
			} else {
				var t:TextEntity = new TextEntity( "Press space again to skip", 16 );
				t.x = 300;
				t.y = 10;
				t.color = 0xCCDDCC;
				add( t );
				_spaceOnce = true;
			}
		}
		
		super.update();
	}
}