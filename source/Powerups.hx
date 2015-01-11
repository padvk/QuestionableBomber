package ;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Powerups extends FlxSprite {

	private var _type:Int;
	private var _player:Player;
	private var _index:Int;
	private var _xTile:Int;
	private var _yTile:Int;
	/**1: Fire - Increase the bomb blast radius
	 * 2: Bomb-Up - Increase the number of bombs that can be set at one time.
	 * 3: Pierce - Bomb blast will pass through as many soft blocks as the fire level will allow.
	*/
	public function new(xTile:Int, yTile:Int, type:Int, player:Player) {
		super(xTile * PlayState.tileSize, yTile * PlayState.tileSize);
		_type = type;
		_player = player;
		_xTile = xTile;
		_yTile = yTile;
		_index = (yTile * PlayState.tileMap.widthInTiles) + xTile;
		if (type == 1) {
			p1();
		} else if (type == 2) {
			p2();
		} else if (type == 3) {
			p3();
		}
	}
	
	private function p1():Void {
		loadGraphic(AssetPaths.p1__png, true, 16, 16);
	}
	
	private function p2():Void {
		loadGraphic(AssetPaths.p2__png, true, 16, 16);
	}
	
	private function p3():Void {
		loadGraphic(AssetPaths.p3__png, true, 16, 16);
	}
	
	override public function update():Void {
		super.update();
		if (((_player.playerTileY * PlayState.tileSize) + _player.playerTileX) == ((_yTile * PlayState.tileSize) + _xTile)) {
			destroy();
		}
	}
	
	override public function destroy():Void {
		switch(_type) {
        case 1:
            _player.blastSize += 1;
        case 2:
            _player.bombs += 1;
        case 3:
            _player.blastPiercing = true;
		}
		PlayState.powerUp[_index] = 0;
		super.destroy();
	}
}