package ;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author ...
 */
class Explosion  extends FlxSprite {
	public var xTile:Int;
	public var yTile:Int;
	
	private var _timer:Int = 15;

	public function new(xT:Int, yT:Int) {
		super(xT * PlayState.tileSize, yT * PlayState.tileSize);
		loadGraphic(AssetPaths.explosion__png, false, 16, 16);
		setSize(16, 16);
		immovable = true;
		
		xTile = xT;
		yTile = yT;
	}
	
	override public function update():Void {
		super.update();
		_timer -= 1;
		if ( _timer <= 0 ) {
			FlxTween.tween(this, { alpha:0 }, .2, { complete:endTween });
		}
	}
	
	private function endTween(T:FlxTween):Void {
		destroy();
	}
	
	override public function destroy():Void {
		super.destroy();
	}
}