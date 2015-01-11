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
			fire();
		} else if (type == 2) {
			bombUp();
		} else if (type == 3) {
			pierce();
		}
	}
	
	private function fire():Void {
		loadGraphic(AssetPaths.pFire__png, true, 16, 16);
	}
	
	private function bombUp():Void {
		loadGraphic(AssetPaths.pBomb__png, true, 16, 16);
	}
	
	private function pierce():Void {
		loadGraphic(AssetPaths.pPierce__png, true, 16, 16);
	}
	
	override public function update():Void {
		super.update();
		if (((_player.yTile * PlayState.tileSize) + _player.xTile) == ((_yTile * PlayState.tileSize) + _xTile)) {
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