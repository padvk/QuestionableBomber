package ;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class BreakableWall extends FlxSprite {

	public function new(X:Float, Y:Float) {
		super(X, Y);
		loadGraphic(AssetPaths.breakableTile__png, false, 16, 16);
		setSize(16, 16);
		immovable = true;
	}
}