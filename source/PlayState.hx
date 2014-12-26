package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	
	private var _grpBombs:FlxTypedGroup<Bomb>;
	var _e:Bool = false;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		_mWalls.setTileProperties(3, FlxObject.ANY);
		add(_mWalls);
		
		_player = new Player();
		_map.loadEntities(placeEntities, "entities");
		_player.bombs = 10;
		add(_player);
		
		_grpBombs = new FlxTypedGroup<Bomb>();
		add(_grpBombs);
		
		FlxG.camera.follow(_player, FlxCamera.STYLE_LOCKON, 1);
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		
		super.update();
		FlxG.collide(_player, _mWalls);
		FlxG.collide(_player, _grpBombs);
		FlxG.collide(_grpBombs, _mWalls);
		
		_e = FlxG.keys.anyPressed(["E"]);
		if (_e) {
			placeBomb();
		}
	}
	
	private function  placeEntities(entityName:String, entityData:Xml):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player") {
			_player.x = x;
			_player.y = y;
		}
	}
	
	public function placeBomb():Void {
		if (_player.bombs != 0 ) {
			var x:Float = _player.x;
			var y:Float = _player.y;
			_grpBombs.add(new Bomb(x, y));
			_player.bombs -= 1;
		}
		
	}
}