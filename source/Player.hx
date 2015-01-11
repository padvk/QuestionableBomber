package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite {
	public var playerTileX:Int;
	public var playerTileY:Int;
	
	public var bombs:Int = 1;
	public var blastSize:Int = 1;
	public var blastPiercing:Bool = false;

	public function new(X:Float=0, Y:Float=0) {
		super(X, Y);
		playerTileX = Math.floor(X / PlayState.tileSize);
		playerTileY = Math.floor(Y / PlayState.tileSize);
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
	
	public function animate():Void {
		//Play animations
		switch(facing) {
			case FlxObject.LEFT, FlxObject.RIGHT:
				animation.play("lr");
			case FlxObject.UP:
				animation.play("u");
			case FlxObject.DOWN:
				animation.play("d");
		}
	}
}