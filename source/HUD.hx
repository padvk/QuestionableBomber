package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite> {

    private var _sprBackBomb:FlxSprite;
    private var _txtBombs:FlxText;
    private var _txtBlast:FlxText;
    private var _sprBomb:FlxSprite;
    private var _sprBlast:FlxSprite;
	private var _txtPierce:FlxText;
	private var _sprSpeed:FlxSprite;
	private var _txtSpeed:FlxText;

    public function new() {
        super();
        _txtBombs = new FlxText(18, 2, 0, "1 / 5", 8);
        _txtBombs.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		_sprBomb = new FlxSprite(4, _txtBombs.y + (_txtBombs.height / 2)  - 6, AssetPaths.bomb__png);
		_sprBackBomb = new FlxSprite().makeGraphic(50, 20, FlxColor.GREEN);
		
        _txtBlast = new FlxText(0, 2, 0, "1 / 5", 8);
        _txtBlast.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
        _sprBlast = new FlxSprite(FlxG.width - 18, _txtBlast.y + (_txtBlast.height/2)  - 8, AssetPaths.pFire__png);
        _txtBlast.alignment = "right";
        _txtBlast.x = _sprBlast.x - _txtBlast.width - 4;
		_txtBlast.y = _sprBlast.y = FlxG.height - _sprBlast.height - 2;
		
		_txtPierce = new FlxText(0, 4, 0, "Bomb piercing: Off", 8);
        _txtPierce.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
        _txtPierce.alignment = "center";
		_txtPierce.x = (FlxG.width / 2) - (_txtPierce.width / 2);
		_txtPierce.y = FlxG.height - _txtPierce.height - 2;
		
		_txtSpeed = new FlxText(0, FlxG.height - 20, 0, "0 / 3", 8);
        _txtSpeed.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
        _sprSpeed = new FlxSprite(4, FlxG.height - 20, AssetPaths.pSpeed__png);
        _txtSpeed.alignment = "left";
        _txtSpeed.x = _sprSpeed.x + _txtSpeed.width;
		_txtSpeed.y = _sprSpeed.y = FlxG.height - _sprSpeed.height - 2;
		
		add(_sprBackBomb);
        add(_txtBlast);
        add(_sprBlast);
        add(_txtBombs);
        add(_sprBomb);
		add(_txtPierce);
		add(_sprSpeed);
		add(_txtSpeed);
		
        forEach(function(spr:FlxSprite) {
            spr.scrollFactor.set();
        });
    }

    public function updateHUD(Bombs:Int, Blast:Int, Pierce:Bool = false, Speed:Int = -1):Void {
        _txtBombs.text = Std.string(Bombs) + " / 5";
        _txtBlast.text = Std.string(Blast) + " / 5";
        _txtBlast.x = _sprBlast.x - _txtBlast.width - 4;
		if (Speed != -1) {
			_txtSpeed.text = Std.string(Speed) + " / 3";
		}
		if (Pierce == true) {
			_txtPierce.text = "Bomb piercing: On";
		}
    }
}