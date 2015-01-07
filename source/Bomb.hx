package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author ...
 */
class Bomb extends FlxSprite {

	private var _player:Player = null;
	private var _blastSize:Int = 5;
	private var _blastPiercing:Bool = true;
	private var _xTile:Int = 0;
	private var _yTile:Int = 0;
	private var _tileIsBomb:Array<Bool>;
	
	private var _timer = 60 * 3; //60 fps, so 3 seconds
	private var _mTiles:FlxTilemap;
	private var _tileSize:Float;
	
	public function new(XTile:Int, YTile:Int, Owner:Player, Tiles:FlxTilemap, TileSize:Float, tileIsBomb:Array<Bool>) {
		super(XTile * TileSize, YTile * TileSize);
		loadGraphic(AssetPaths.bomb__png, false, 14, 14);
		setSize(16, 16);
		immovable = true; //For now ;)
		
		_xTile = XTile;
		_yTile = YTile;
		
		_player = Owner;
		_mTiles = Tiles;
		_tileSize = TileSize;
		
		_tileIsBomb = tileIsBomb;
		
	}
	
	override public function update():Void {
		super.update();
		
		_timer -= 1;
		
		//Timer 0? Explode!
		if (_timer <= 0) {
			//Destroy own sprite
			destroy();
			//Allow player to spawn a new bomb
			_player.bombs += 1;
			_tileIsBomb[(_yTile * _mTiles.widthInTiles) + _xTile] = false;
			
			//Destroy surrounding blocks
			var checks:Array<Array<Int>> = [
				[0, -1],
				[0, 1],
				[-1, 0],
				[1, 0],
			];
			
			for (i in 0 ... checks.length) {
				for (l in 0 ... _blastSize) {
					var offset:Array<Int> = checks[i];
					var xt:Int = _xTile + (offset[0] * l);
					var yt:Int = _yTile + (offset[1] * l);
					var type:Int = _mTiles.getTile(xt, yt);
					if (type == 3) { //Breakable, break
						_mTiles.setTile(xt, yt, 1, true);
						if (_blastPiercing == false) {
							break; //No piercing, exit length loop
						}
					} else if (type == 2) { //Unwalkable
						break; //Cant pierce this or break this, exit length loop
					}
				}
			}
		}
	}
}