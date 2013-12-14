package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.Mask;
import com.haxepunk.masks.Grid;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

class Tiles extends Entity {
	/**
	 * Create a tiled map.
	 * 
	 * @param	MapPath		The image to use for the tilemap.
	 */
	public function new( MapPath:String, TileSet:String ) {
		super( 0, 0 );
		
		var entity:TmxEntity = new TmxEntity( MapPath );
		entity.loadGraphic( TileSet, [ "collision" ] );
		entity.loadMask( "collision", "walls" );
		
		graphic = entity.graphic;
		mask = entity.mask;
		type = "solid";
	}
}