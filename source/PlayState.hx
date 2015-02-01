package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	public static var tileMap:FlxTilemap;
	public static var tileSize:Float = 16.0;
	public static var players:Array<Player>;
	public static var grpPlayers:FlxTypedGroup<Player>;
	public static var bombTiles:Array<Bomb>;
	public static var powerUpTiles:Array<Powerups>; //0 means no powerup, then > 0 will go by the list in the powerups class
	public static var grpExplosions:FlxTypedGroup<Explosion>;
	
	//private var _player:Player;
	private var _playerID:Int = 0; //For now
	private var _playerCount:Int = 1; //For now
	private var _map:FlxOgmoLoader;
	private var _grpBombs:FlxTypedGroup<Bomb>;
	private var _grpPowerups:FlxTypedGroup<Powerups>;
	private var _playerMoving:Bool = false;
	private var _moveTime:Float = .15;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		//Turn the mouse off
		FlxG.mouse.visible = true;
		
		_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		tileMap = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		add(tileMap);
		
		//Placing breakable walls and powerups
		var floorIndices:Array<Int> = tileMap.getTileInstances(1);
		_grpPowerups = new FlxTypedGroup<Powerups>();
		powerUpTiles = new Array<Powerups>();
		placeBreakableWalls(floorIndices);
		
		//Placing the player
		players = new Array<Player>();
		grpPlayers = new FlxTypedGroup<Player>();
		placePlayers(floorIndices);
		add(grpPlayers);
		
		var breakableIndices:Array<Int> = tileMap.getTileInstances(3);
		placePowerups(breakableIndices);
		add(_grpPowerups);
		
		//Adding bombs
		_grpBombs = new FlxTypedGroup<Bomb>();
		bombTiles = new Array<Bomb>();
		add(_grpBombs);
		
		//Setting up explosions
		grpExplosions = new FlxTypedGroup<Explosion>();
		add(grpExplosions);
		
		FlxG.camera.follow(players[_playerID], FlxCamera.STYLE_LOCKON, 1);
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
		checkCollisions();
		playerMovement();
		FlxG.collide(_grpBombs, tileMap);
		FlxG.collide(_grpBombs, _grpBombs);
		
		if (FlxG.keys.anyJustPressed(["E", "SPACE"])) {
			placeBomb();
		}
	}
	
	public function placeBomb():Void {
		var p:Player = players[_playerID];
		if (p.bombs > 0) {
			trace("Player has " + p.bombs + " bombs.");
			var xTile:Int = Math.floor((p.x + (p.offset.x/2)) / tileSize);
			var yTile:Int = Math.floor((p.y + (p.offset.y / 2)) / tileSize);
			var bmb:Bomb = new Bomb(xTile, yTile, p, p.blastSize, p.blastPiercing);
			
			_grpBombs.add(bmb); //Add to render
			bombTiles[(yTile * tileMap.widthInTiles) + xTile] = bmb; //Add to bomb tile array
			p.bombs -= 1; //Decrease player bombs
		}
	}
	
	public function placePlayers(floorIndices:Array<Int>):Void {
		//Not using players.length because we havent given it values yet
		for (i in 0..._playerCount) {
			//Get tile position, set to player
			var index:Int = Std.random(floorIndices.length);
			index = floorIndices[index]; //Where to spawn the player
		
			var x:Float = (index % tileMap.widthInTiles) * tileSize;
			var y:Float = Math.floor(index / tileMap.widthInTiles) * tileSize;
			players[i] = new Player(x, y);
			grpPlayers.add(players[i]);
			
			//make tile + surrounding tiles walkable in case they where made breakable
			if (tileMap.getTileByIndex(index) == 3) {
				tileMap.setTileByIndex(index, 1, true);
			}
			if (tileMap.getTileByIndex(index - tileMap.widthInTiles) == 3) {
				tileMap.setTileByIndex(index - tileMap.widthInTiles, 1, true);
			}
			if (tileMap.getTileByIndex(index + 1) == 3) {
				tileMap.setTileByIndex(index + 1, 1, true);
			}
			if (tileMap.getTileByIndex(index + tileMap.widthInTiles) == 3) {
				tileMap.setTileByIndex(index + tileMap.widthInTiles, 1, true);
			}
			if (tileMap.getTileByIndex(index - 1) == 3) {
				tileMap.setTileByIndex(index - 1, 1, true);
			}
		}
	}
	
	private function placeBreakableWalls(indices:Array<Int>):Void {
		var floorIndices:Array<Int> = indices.copy();
		
		var count = Math.floor((floorIndices.length - 1) * 0.8);
		trace("Placing " +  count + " breakable walls on");
		
		for (i in 0...count) {
			var index:Int = Std.random(floorIndices.length);
			tileMap.setTileByIndex(floorIndices[index], 3, true);
			floorIndices.remove(floorIndices[index]);
		}
	}
	
	private function placePowerups(indices:Array<Int>):Void {
		var breakableIndices:Array<Int> = indices.copy();
		
		var count:Int = Math.floor(breakableIndices.length * 0.5); //Half of the breakable walls to have powerups (for now)
		trace("Placing " +  count + " powerups");
		
		for (i in 0...count) {
			var index:Int = breakableIndices[Std.random(breakableIndices.length)];
			var type:Int = Std.random(3) + 1;
			var pUp = new Powerups((index % tileMap.widthInTiles), (Math.floor(index / tileMap.widthInTiles)), type);
			pUp.visible = false;
			powerUpTiles[index] = pUp;
			_grpPowerups.add(pUp);
			breakableIndices.remove(index);
		}
	}
	
	private function checkCollisions() {
		for (i in 0...players.length) {
			var p:Player = players[i];
			for (j in 0...(tileMap.widthInTiles * tileMap.heightInTiles)) {
				var pUp:Powerups = powerUpTiles[j];
				if (pUp != null && (p.yTile == pUp._yTile && p.xTile == pUp._xTile)) {
					trace("Powerup hit " + pUp._type);
					switch(pUp._type) {
						case 1:
							p.blastSize += 1;
						case 2:
							p.bombs += 1;
						case 3:
							p.blastPiercing = true;
					}
					
					powerUpTiles[j] = null;
					_grpPowerups.remove(pUp);
					pUp.destroy();
					pUp = null;
					break;
				}
			}
		}
	}
	
	private function playerMovement():Void {
		var up:Bool = FlxG.keys.anyPressed(["UP", "W"]);
		var down:Bool = FlxG.keys.anyPressed(["DOWN", "S"]);
		var left:Bool = FlxG.keys.anyPressed(["LEFT", "A"]);
		var right:Bool = FlxG.keys.anyPressed(["RIGHT", "D"]);
		
		//Setting direction of tween and facing
		if (_playerMoving == false && (up || down || left || right)) {
			//Finding coordinates of tile we need to check
			var checkTileX:Int = 0;
			var checkTileY:Int = 0;
			var checkTile:Int;
			var checkTileIndex:Int;
			if (up) {
				checkTileX = Math.round(players[_playerID].x / tileSize);
				checkTileY = Math.round((players[_playerID].y - tileSize) / tileSize);
			} else if (down) {
				checkTileX = Math.round(players[_playerID].x / tileSize);
				checkTileY = Math.round((players[_playerID].y + tileSize) / tileSize);
			} else if (left) {
				checkTileX = Math.round((players[_playerID].x - tileSize) / tileSize);
				checkTileY = Math.round(players[_playerID].y / tileSize);
			} else if (right) {
				checkTileX = Math.round((players[_playerID].x + tileSize) / tileSize);
				checkTileY = Math.round(players[_playerID].y / tileSize);
			}
			
			checkTile = tileMap.getTile(checkTileX, checkTileY);
			checkTileIndex = (checkTileY * tileMap.widthInTiles) + checkTileX;
			if (checkTile == 1 && bombTiles[checkTileIndex] == null) {
				_playerMoving = true;
				if (up) {
					FlxTween.tween(players[_playerID], { y:players[_playerID].y - tileSize, yTile:players[_playerID].yTile - 1 }, _moveTime, { complete:endMovement });
					players[_playerID].facing = FlxObject.UP;
				} else if (down) {
					FlxTween.tween(players[_playerID], { y:players[_playerID].y + tileSize, yTile:players[_playerID].yTile + 1 }, _moveTime, { complete:endMovement });
					players[_playerID].facing = FlxObject.DOWN;
				} else if (left) {
					FlxTween.tween(players[_playerID], { x:players[_playerID].x - tileSize, xTile:players[_playerID].xTile - 1 }, _moveTime, { complete:endMovement });
					players[_playerID].facing = FlxObject.LEFT;
				} else if (right) {
					FlxTween.tween(players[_playerID], { x:players[_playerID].x + tileSize, xTile:players[_playerID].xTile + 1 }, _moveTime, { complete:endMovement });
					players[_playerID].facing = FlxObject.RIGHT;
				}
				
				players[_playerID].animate();
			}
		}
	}
	
	private function endMovement(T:FlxTween):Void {
		_playerMoving = false;
	}
}