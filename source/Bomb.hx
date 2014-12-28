package ;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Bomb extends FlxSprite {

	private var _player:Player = null;
	private var _timer = 60 * 3;
	
	public function new(X:Float, Y:Float, Owner:Player) {
		super(X, Y);
		loadGraphic(AssetPaths.bomb__png, false, 14, 14);
		setSize(16, 16);
		immovable = true; //For now ;)
		
		_player = Owner;
	}
	
	override public function update():Void {
		super.update();
		
		_timer -= 1;
		
		if (_timer <= 0) {
			destroy();
			_player.bombs += 1;
		}
	}
}