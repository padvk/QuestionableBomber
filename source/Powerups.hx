package ;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Powerups extends FlxSprite {

	//private var _type:Int;
	/**1: Fire - Increase the bomb blast radius
	 * 2: Bomb-Up - Increase the number of bombs that can be set at one time.
	 * 3: Pierce - Bomb blast will pass through as many soft blocks as the fire level will allow.
	*/
	public function new(xTile:Int, yTile:Int, type:Int) {
		super(xTile * PlayState.tileSize, yTile * PlayState.tileSize);
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
	}
}