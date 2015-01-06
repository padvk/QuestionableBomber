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
import flixel.tweens.FlxTween;
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
	private var _playerMoving:Bool = false;
	private var _moveTime:Float = .25;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		//Turn the mouse off
		FlxG.mouse.visible = false;
		
		_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		_mTiles = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		add(_mTiles);
		
		var tileIsFloor:Array<Int> = _mTiles.getTileInstances(1);
		placeBreakableWalls(tileIsFloor.copy());
		
		placePlayer(tileIsFloor);
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
		playerMovement();
		FlxG.collide(_grpBombs, _mTiles);
		FlxG.collide(_grpBombs, _grpBombs);
		
		if (FlxG.keys.anyJustPressed(["E", "SPACE"])) {
			placeBomb();
		}
	}
	
	public function placeBomb():Void {
		if (_player.bombs > 0) {
			var x:Float = (Math.floor((_player.x + (_player.offset.x/2)) / _tileSize) * _tileSize);
			var y:Float = (Math.floor((_player.y + (_player.offset.y / 2)) / _tileSize) * _tileSize);
			_grpBombs.add(new Bomb(x, y, _player, _mTiles, _tileSize));
			_player.bombs -= 1;
		}
	}
	
	public function placePlayer(tileIsFloor:Array<Int>):Void {
		var index:Int = Std.random(tileIsFloor.length);
		index = tileIsFloor[index]; //Where to spawn the player
		//Get tile position, set to player
		var x:Float = 0;
		var indexCopy:Int = index;
		while (indexCopy > _mTiles.widthInTiles) {
			indexCopy -= _mTiles.widthInTiles;
		}
		x = indexCopy * _tileSize;
		var y:Float = Math.floor(index / _mTiles.widthInTiles) * _tileSize; //NOT WORKING RIGHT NOW
		_player = new Player(x, y);
		
		//make tile + surrounding tiles walkable in case they where made breakable
		if (_mTiles.getTileByIndex(index) == 3) {
			_mTiles.setTileByIndex(index, 1, true);
		}
		if (_mTiles.getTileByIndex(index - _mTiles.widthInTiles) == 3) {
			_mTiles.setTileByIndex(index - _mTiles.widthInTiles, 1, true);
		}
		if (_mTiles.getTileByIndex(index + 1) == 3) {
			_mTiles.setTileByIndex(index + 1, 1, true);
		}
		if (_mTiles.getTileByIndex(index + _mTiles.widthInTiles) == 3) {
			_mTiles.setTileByIndex(index + _mTiles.widthInTiles, 1, true);
		}
		if (_mTiles.getTileByIndex(index - 1) == 3) {
			_mTiles.setTileByIndex(index - 1, 1, true);
		}
	}
	
	private function placeBreakableWalls(tileIsFloor:Array<Int>):Void {
		var count = Math.floor((tileIsFloor.length - 1) * 0.8);
		
		for (i in 0...count) {
			var index:Int = Std.random(tileIsFloor.length);
			_mTiles.setTileByIndex(tileIsFloor[index], 3, true);
			tileIsFloor.remove(tileIsFloor[index]);
		}
	}
	
	private function playerMovement():Void {
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		 
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		
		//Setting direction of tween and facing
		if (_playerMoving == false && (_up || _down || _left || _right)) {
			//Finding coordinates of tile we need to check
			var checkTileX:Int = 0;
			var checkTileY:Int = 0;
			var checkTile:Int;
			if (_up) {
				checkTileX = Math.round(_player.x/16);
				checkTileY = Math.round((_player.y - 16)/16);
			} else if (_down) {
				checkTileX = Math.round(_player.x/16);
				checkTileY = Math.round((_player.y + 16)/16);
			} else if (_left) {
				checkTileX = Math.round((_player.x - 16)/16);
				checkTileY = Math.round(_player.y/16);
			} else if (_right) {
				checkTileX = Math.round((_player.x + 16)/16);
				checkTileY = Math.round(_player.y/16);
			}
			checkTile = _mTiles.getTile(checkTileX, checkTileY);
			if (checkTile == 1) {
				_playerMoving = true;
				if (_up) {
					FlxTween.tween(_player, { y:_player.y - 16 }, _moveTime, { complete:endMovement });
					_player.facing = FlxObject.UP;
				} else if (_down) {
					FlxTween.tween(_player, { y:_player.y + 16 }, _moveTime, { complete:endMovement });
					_player.facing = FlxObject.DOWN;
				} else if (_left) {
					FlxTween.tween(_player, { x:_player.x - 16 }, _moveTime, { complete:endMovement });
					_player.facing = FlxObject.LEFT;
				} else if (_right) {
					FlxTween.tween(_player, { x:_player.x + 16 }, _moveTime, { complete:endMovement });
					_player.facing = FlxObject.RIGHT;
				}
				
				//Play animations
				switch(_player.facing) {
					case FlxObject.LEFT, FlxObject.RIGHT:
						_player.animation.play("lr");
					case FlxObject.UP:
						_player.animation.play("u");
					case FlxObject.DOWN:
						_player.animation.play("d");
				}
			}
		}
	}
	
	private function endMovement(T:FlxTween):Void {
		_playerMoving = false;
	}
}