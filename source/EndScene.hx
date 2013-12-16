package;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

class EndScene extends Scene {
	private var _spaceOnce:Bool = false;
	
	override public function begin() {
		Reg.FADE = new Fade();
		add( Reg.FADE );
		Reg.FADE.add();
		
		addGraphic( new Image( "images/end.png" ) );
		
		var text:TextEntity = new TextEntity( "Thank you for the bone and I need to sleep.", 16 );
		text.x = 10;
		text.y = 222;
		
		var shadow:TextEntity = new TextEntity( "Thank you for the bone and I need to sleep.", 16 );
		shadow.x = text.x + 1;
		shadow.y = text.y + 1;
		shadow.color = 0xff000000;
		
		add( shadow );
		add( text );
		
		Reg.FADE.fadeIn( 1 );
		super.begin();
	}
	
	override public function update():Void {
		if ( Input.pressed( Key.SPACE ) ) {
			if ( _spaceOnce ) {
				Reg.FADE.fadeOut( 2, function() { HXP.scene = new TheEndScene(); } );
			} else {
				var t:TextEntity = new TextEntity( "Press space again to end", 16 );
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