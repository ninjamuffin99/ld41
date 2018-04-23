package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Enemy extends Character
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.stinker__png, false, 246, 364);

		drag.set(500, 500);
		resizeHitbox();
		ID = Character.ENEMY;
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		super.update(elapsed);
	}
	
}