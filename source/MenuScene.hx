package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.geom.Rectangle;

#if !js
import com.haxepunk.Sfx;
#end

class MenuScene extends Scene {
	#if !js
	private var _title:Sfx;
	#end
	
	override public function begin():Void {
		Reg.FADE = new Fade();
		add( Reg.FADE );
		Reg.FADE.add();
		
		var title:TextEntity = new TextEntity( "The Game of Fun", 64 );
		title.x = 40;
		title.y = 60;
		
		var start:TextEntity = new TextEntity( "Press Space to Begin", 32 );
		start.x = ( HXP.width - 368 ) / 2;
		start.y = ( HXP.height - 36 ) / 2 - 50;
		
		var block:Rect = new Rect( 368 + 16, 36 + 16, 0x888888 );
		block.x = ( HXP.width - ( 368 + 16 ) ) / 2;
		block.y = ( HXP.height - ( 36 + 16 ) ) / 2 - 50;
		
		var jack:Image = new Image( "images/jack.png", new Rectangle( 0, 0, 40, 80 ) );
		jack.x = 170;
		jack.y = start.y + 80;
		
		var instruction:TextEntity = new TextEntity( "Controls:\nLeft and Right - Move\nUp - Jump or Climb Vines\nDown - Duck and Block\nSpace - Shoot Blaster\nC - Shoot Arrow\nX - Open Treasure Chest\nP - Pause Game", 16 );
		instruction.x = jack.x + 100;
		instruction.y = jack.y - 20;
		instruction.color = 0xff222222;
		
		var credits:TextEntity = new TextEntity( "A game for Ludum Dare 28.\n\nArt, concept, and design by Burning Tiger\nand Burning Wheels, age 8 and 4, respectively.\n\nProgramming by Steve Richey, their dad.", 16 );
		credits.x = 120;
		credits.y = 380;
		
		add( title );
		addGraphic( block );
		add( start );
		addGraphic( jack );
		add( instruction );
		add( credits );
		
		#if !js
		_title = new Sfx( "title" );
		_title.play();
		#end
		
		Reg.FADE.fadeIn( 0.5 );
		super.begin();
	}
	
	override public function update():Void {
		if ( Input.pressed( Key.SPACE ) ) {
			Reg.FADE.fadeOut( 0.5, function() { HXP.scene = new StoryScene(); } );
		}
		
		super.update();
	}
	
	override public function end():Void {
		#if !js
		_title.stop();
		_title = null;
		#end
		
		super.end();
	}
}