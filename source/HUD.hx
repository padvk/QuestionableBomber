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

    private var _sprBack:FlxSprite;
    private var _txtBombs:FlxText;
    private var _txtBlast:FlxText;
    private var _sprBomb:FlxSprite;
    private var _sprBlast:FlxSprite;

    public function new() {
        super();
        _sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.GREEN);
        _sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
        _txtBombs = new FlxText(18, 2, 0, "1 / 5", 8);
        _txtBombs.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
        _txtBlast = new FlxText(0, 2, 0, "1 / 5", 8);
        _txtBlast.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
        _sprBomb = new FlxSprite(4, _txtBombs.y + (_txtBombs.height/2)  - 6, AssetPaths.bomb__png);
        _sprBlast = new FlxSprite(FlxG.width - 18, _txtBlast.y + (_txtBlast.height/2)  - 8, AssetPaths.pFire__png);
        _txtBlast.alignment = "right";
        _txtBlast.x = _sprBlast.x - _txtBlast.width - 4;
        add(_sprBack);
        add(_txtBlast);
        add(_sprBlast);
        add(_txtBombs);
        add(_sprBomb);
        forEach(function(spr:FlxSprite) {
            spr.scrollFactor.set();
        });
		trace("Screen width is " + FlxG.width);
		trace("txtBlast.x = " + _txtBlast.x);
		trace("txtBlast.y  " +_txtBlast.y);
    }

    public function updateHUD(Bombs:Int, Blast:Int):Void {
        _txtBombs.text = Std.string(Bombs) + " / 5";
        _txtBlast.text = Std.string(Blast) + " / 5";
        _txtBlast.x = _sprBlast.x - _txtBlast.width - 4;
    }
}