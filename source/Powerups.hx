package ;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Powerups extends FlxSprite {
	public var _xTile:Int;
	public var _yTile:Int;
	public var _type:Int;
	
	private var _index:Int;
	
	public var drawn:Bool = false;
	/**1: Fire - Increase the bomb blast radius
	 * 2: Bomb-Up - Increase the number of bombs that can be set at one time.
	 * 3: Pierce - Bomb blast will pass through as many soft blocks as the fire level will allow.
	 * 4: Speed - Increase the speed of the player.
	*/
	public function new(xTile:Int, yTile:Int, type:Int) {
		super(xTile * PlayState.tileSize, yTile * PlayState.tileSize);
		_type = type;
		_xTile = xTile;
		_yTile = yTile;
		_index = (yTile * PlayState.tileMap.widthInTiles) + xTile;
		if (type == 1) {
			fire();
		} else if (type == 2) {
			bombUp();
		} else if (type == 3) {
			pierce();
		} else if (type == 4) {
			speed();
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
	
	private function speed():Void {
		loadGraphic(AssetPaths.pSpeed__png, true, 16, 16);
	}
	
	override public function update():Void {
		super.update();
	}
	
	override public function destroy():Void {
		super.destroy();
	}
}