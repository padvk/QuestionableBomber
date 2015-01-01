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
	private var _moveTime:Float = .25;
	private var _moving:Bool = false;
	public var bombs:Int = 0;
	private var TILES:FlxTilemap;

	public function new(objTILES:FlxTilemap, X:Float=0, Y:Float=0) {
		super(X, Y);
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		animation.add("d", [0, 1, 0, 2], 6, false);
		TILES = objTILES;
	}
	
	private function movement():Void {
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		 
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		
		//Setting direction of tween and facing
		if (_moving == false && (_up || _down || _left || _right)) {
			//Finding coordinates of tile we need to check
			var checkTileX:Int = 0;
			var checkTileY:Int = 0;
			var checkTile:Int;
			if (_up) {
				checkTileX = Math.round(x/16);
				checkTileY = Math.round((y - 16)/16);
			} else if (_down) {
				checkTileX = Math.round(x/16);
				checkTileY = Math.round((y + 16)/16);
			} else if (_left) {
				checkTileX = Math.round((x - 16)/16);
				checkTileY = Math.round(y/16);
			} else if (_right) {
				checkTileX = Math.round((x + 16)/16);
				checkTileY = Math.round(y/16);
			}
			checkTile = TILES.getTile(checkTileX, checkTileY);
			if (checkTile == 1) {
				_moving = true;
				if (_up) {
					FlxTween.tween(this, { y:y - 16 }, _moveTime, { complete:endTween });
					facing = FlxObject.UP;
				} else if (_down) {
					FlxTween.tween(this, { y:y + 16 }, _moveTime, { complete:endTween });
					facing = FlxObject.DOWN;
				} else if (_left) {
					FlxTween.tween(this, { x:x - 16 }, _moveTime, { complete:endTween });
					facing = FlxObject.LEFT;
				} else if (_right) {
					FlxTween.tween(this, { x:x + 16 }, _moveTime, { complete:endTween });
					facing = FlxObject.RIGHT;
				}
				
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
	}
	
	private function endTween(T:FlxTween):Void {
		_moving = false;
	}
	
	override public function update():Void {
		movement();
		super.update();
	}
}