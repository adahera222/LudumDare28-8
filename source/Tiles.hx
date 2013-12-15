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
	// The Player
	
	public var playerSpawn(default, null):Point;
	
	// Enemies
	
	public var spikePositions(default, null):Array<Point>;
	public var spiderPositions(default, null):Array<Point>;
	public var ghostPositions(default, null):Array<Point>;
	
	// Vines
	
	public var vineAreas(default, null):Array<Box>;
	
	// Treasures
	
	public var treasurePositions(default, null):Array<Point>;
	
	// The level exit
	
	public var exit(default, null):Box;
	
	/**
	 * Create a tiled map.
	 * 
	 * @param	MapPath		The image to use for the tilemap.
	 */
	public function new( MapPath:String, TileSet:String ) {
		super( 0, 0 );
		
		layer = Reg.LAYER_MAP;
		
		playerSpawn = new Point(0, 0);
		spikePositions = new Array<Point>();
		spiderPositions = new Array<Point>();
		ghostPositions = new Array<Point>();
		vineAreas = new Array<Box>();
		treasurePositions = new Array<Point>();
		
		var entity:TmxEntity = new TmxEntity( MapPath );
		entity.loadGraphic( TileSet, [ "extra background", "background", "collidable", "foreground" ] );
		entity.loadMask( "collidable", "walls" );
		
		for ( object in entity.map.getObjectGroup( "objects" ).objects ) {
			switch ( object.name ) {
				case "player":
					playerSpawn.x = object.x;
					playerSpawn.y = object.y;
				case "spike":
					spikePositions.push( new Point( object.x, object.y ) );
				case "spider":
					spiderPositions.push( new Point( object.x, object.y ) );
				case "ghost":
					ghostPositions.push( new Point( object.x, object.y ) );
				case "vine":
					var b:Box = new Box( object.x, object.y, object.width, object.height );
					vineAreas.push( b );
				case "treasure":
					treasurePositions.push( new Point( object.x, object.y ) );
				case "exit":
					exit = new Box( object.x, object.y, object.width, object.height ); 
			}
		}
		
		graphic = entity.graphic;
		mask = entity.mask;
		type = "solid";
	}
}