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
	public static var theHud:HUD; //Not just "hud" cause "HUD" is already a class
	
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
		
		theHud = new HUD();
		add(theHud);
		
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
			var xTile:Int = Math.floor((p.x + (p.offset.x/2)) / tileSize);
			var yTile:Int = Math.floor((p.y + (p.offset.y / 2)) / tileSize);
			var bmb:Bomb = new Bomb(xTile, yTile, p, p.blastSize, p.blastPiercing);
			
			_grpBombs.add(bmb); //Add to render
			bombTiles[(yTile * tileMap.widthInTiles) + xTile] = bmb; //Add to bomb tile array
			p.bombs -= 1; //Decrease player bombs
			
			theHud.updateHUD(p.bombs, p.blastSize, false, -1, p.maxBombs);
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
		
		for (i in 0...count) {
			var index:Int = Std.random(floorIndices.length);
			tileMap.setTileByIndex(floorIndices[index], 3, true);
			floorIndices.remove(floorIndices[index]);
		}
	}
	
	private function placePowerups(indices:Array<Int>):Void {
		var breakableIndices:Array<Int> = indices.copy();
		
		var count:Int = Math.floor(breakableIndices.length * 0.5); //Half of the breakable walls to have powerups (for now)
		
		for (i in 0...count) {
			var index:Int = breakableIndices[Std.random(breakableIndices.length)];
			var type:Int = 1;
			if (i <= Math.floor(count * .3)) {
				type = 1;
			} else if (i <= Math.round(count * 0.6) && i > Math.round(count * .3)) {
				type = 2;
			} else if (i <= Math.round(count * 0.7) && i > Math.round(count * .6)) {
				type = 3;
			} else if (i > Math.round(count * 0.7)) {
				type = 4;
			}
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
				var pierce:Int = 0;
				if (pUp != null && (p.yTile == pUp._yTile && p.xTile == pUp._xTile)) {
					switch(pUp._type) {
						case 1:
							if (p.blastSize < 5) { //Maximum of 5 blast length
								p.blastSize += 1;
							}
						case 2:
							if (p.maxBombs < 5) { //Maximum of 5 bombs per player
								p.maxBombs += 1;
								p.bombs += 1;
							}
						case 3:
							p.blastPiercing = true;
						case 4:
							if (p.speedPups < 3) {
								p.moveTime -= .02;
							p.speedPups += 1;
							}
					}
					theHud.updateHUD(p.bombs, p.blastSize, p.blastPiercing, p.speedPups, p.maxBombs);
					
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
			var p:Player = players[_playerID];
			if (up) {
				checkTileX = Math.round(p.x / tileSize);
				checkTileY = Math.round((p.y - tileSize) / tileSize);
				p.facing = FlxObject.UP;
			} else if (down) {
				checkTileX = Math.round(p.x / tileSize);
				checkTileY = Math.round((p.y + tileSize) / tileSize);
				p.facing = FlxObject.DOWN;
			} else if (left) {
				checkTileX = Math.round((p.x - tileSize) / tileSize);
				checkTileY = Math.round(p.y / tileSize);
				p.facing = FlxObject.LEFT;
			} else if (right) {
				checkTileX = Math.round((p.x + tileSize) / tileSize);
				checkTileY = Math.round(p.y / tileSize);
				p.facing = FlxObject.RIGHT;
			}
			
			checkTile = tileMap.getTile(checkTileX, checkTileY);
			checkTileIndex = (checkTileY * tileMap.widthInTiles) + checkTileX;
			if (checkTile == 1 && bombTiles[checkTileIndex] == null) {
				_playerMoving = true;
				FlxTween.tween(p, { y:checkTileY * tileSize, yTile:checkTileY, x:checkTileX * tileSize, xTile:checkTileX }, p.moveTime , { complete:endMovement } );
				p.animate();
			}
		}
	}
	
	private function endMovement(T:FlxTween):Void {
		_playerMoving = false;
	}
}