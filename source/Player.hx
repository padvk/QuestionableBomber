package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxMath;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite {
	public var bombs:Int = 0;

	public function new(X:Float=0, Y:Float=0) {
		super(X, Y);
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		animation.add("d", [0, 1, 0, 2], 6, false);
	}
	
	override public function update():Void {
		super.update();
	}
}