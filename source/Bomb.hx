package ;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Bomb extends FlxSprite {

	public function new(X:Float, Y:Float) {
		super(X, Y);
		loadGraphic(AssetPaths.bomb__png, false, 14, 14);
		
	}
	
	override public function update():Void {
		
		super.update();
	}
}