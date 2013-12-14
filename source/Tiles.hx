package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;

class Tiles extends Entity {
	/**
	 * Create a tiled map.
	 * 
	 * @param	TileImage	The image to use for the tilemap.
	 * @param	TileSize	The width and/or height of the tilemap, in pixels.
	 */
	public function new( TileImage:String, TileSize:Int ) {
		super( 0, 0 );
		
		var tilemap:Tilemap = new Tilemap( TileImage, 20 * 10, 20 * 10, 20, 20 );
		var grid:Grid = new Grid( tilemap.width, tilemap.height, tilemap.tileWidth, tilemap.tileHeight, 0, 0 );
		
		// Fill the tilemap and grid programatically
		
		var map:Array<Array<Int>> = [ 	[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
										[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
										[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
										[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
										[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
										[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
										[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
										[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
										[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
										[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] ];
		
		for ( i in 0...tilemap.columns ) {
			for ( j in 0...tilemap.rows ) {
				var tile = map[j][i];
				if (tile != 0) {
					tilemap.setTile(i, j, tile);
					grid.setTile(i, j, true);
				}
			}
		}
		
		graphic = tilemap;
		mask = grid;
		type = "solid";
	}
}