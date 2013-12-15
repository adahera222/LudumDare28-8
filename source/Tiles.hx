package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.Mask;
import com.haxepunk.masks.Grid;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxLayer;
import com.haxepunk.tmx.TmxMap;
import flash.geom.Point;

class Tiles extends Entity {
	public var playerSpawn(default, null):Point;
	public var enemyPositions(default, null):Array<Point>;
	public var vineAreas(default, null):Array<Box>;
	
	/**
	 * Create a tiled map.
	 * 
	 * @param	MapPath		The image to use for the tilemap.
	 */
	public function new( MapPath:String, TileSet:String ) {
		super( 0, 0 );
		
		playerSpawn = new Point(0, 0);
		enemyPositions = new Array<Point>();
		vineAreas = new Array<Box>();
		
		var entity:TmxEntity = new TmxEntity( MapPath );
		entity.loadGraphic( TileSet, [ "extra background", "background", "collidable", "foreground" ] );
		entity.loadMask( "collidable", "walls" );
		
		for ( object in entity.map.getObjectGroup( "objects" ).objects ) {
			if ( object.name == "player" ) {
				playerSpawn.x = object.x;
				playerSpawn.y = object.y;
			} else if ( object.name == "enemy" ) {
				enemyPositions.push( new Point( object.x, object.y ) );
			} else if ( object.name == "vine" ) {
				var b:Box = new Box( object.x, object.y, object.width, object.height );
				vineAreas.push( b );
			}
		}
		
		graphic = entity.graphic;
		mask = entity.mask;
		type = "solid";
	}
}