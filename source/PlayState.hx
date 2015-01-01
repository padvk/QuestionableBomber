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
import flixel.util.FlxRect;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	private var _mTiles:FlxTilemap;
	private var _tileSize:Float = 16.0;
	private var _grpBombs:FlxTypedGroup<Bomb>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		//Turn the mouse off
		FlxG.mouse.visible = false;
		
		_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		_mTiles = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		add(_mTiles);
		
		_player = new Player(_mTiles);
		_map.loadEntities(placeEntities, "entities");
		_player.bombs = 2;
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

	 //Function that is called once every frame.

	override public function update():Void {
		super.update();
		FlxG.collide(_player, _mTiles);
		FlxG.collide(_player, _grpBombs);
		FlxG.collide(_grpBombs, _mTiles);
		FlxG.collide(_grpBombs, _grpBombs);
		
		if (FlxG.keys.anyJustPressed(["E"])) {
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
		if (_player.bombs > 0) {
			var x:Float = Math.floor((_player.x + (_player.offset.x/2)) / _tileSize) * _tileSize;
			var y:Float = Math.floor((_player.y + (_player.offset.y / 2)) / _tileSize) * _tileSize;
			_grpBombs.add(new Bomb(x, y, _player));
			_player.bombs -= 1;
		}
	}
}