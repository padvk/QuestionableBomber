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
	private var _timer = 60 * 3;
	private var _mTiles:FlxTilemap;
	private var _tileSize:Float;
	
	public function new(X:Float, Y:Float, Owner:Player, objTILES:FlxTilemap, ts:Float) {
		super(X, Y);
		loadGraphic(AssetPaths.bomb__png, false, 14, 14);
		setSize(16, 16);
		immovable = true; //For now ;)
		
		_player = Owner;
		_mTiles = objTILES;
		_tileSize = ts;
		
	}
	
	override public function update():Void {
		super.update();
		
		_timer -= 1;
		
		if (_timer <= 0) {
			destroy();
			_player.bombs += 1;
			
			if (_mTiles.getTile(Math.round(x), Math.round(y - _tileSize)) == 3) {
				_mTiles.setTile(Math.round(x), Math.round(y - _tileSize), 1, true);
			}
			if (_mTiles.getTile(Math.round(x), Math.round(y + _tileSize)) == 3) {
				_mTiles.setTile(Math.round(x), Math.round(y + _tileSize), 1, true);
			}
			if (_mTiles.getTile(Math.round(x - _tileSize), Math.round(y)) == 3) {
				_mTiles.setTile(Math.round(x - _tileSize), Math.round(y), 1, true);
			}
			if (_mTiles.getTile(Math.round(x + _tileSize), Math.round(y)) == 3) {
				_mTiles.setTile(Math.round(x + _tileSize), Math.round(y), 1, true);
			}
		}
	}
}