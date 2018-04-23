package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class HeartIcon extends FlxSprite 
{
	public var tarBystander:Character;

	
	public function new(?X:Float=0, ?Y:Float=0, bystander:Character) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.smallIconSheet__png, true, 45, 45);
		animation.add("x", [0]);
		animation.add("garlic", [1]);
		animation.add("goblin", [2]);
		
		tarBystander = bystander;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		x = tarBystander.x + 75;
		y = tarBystander.y - 125;
		
		if (tarBystander.currentVote == Character.PLAYER)
		{
			animation.play("goblin");
		}
		else if (tarBystander.currentVote == Character.ENEMY)
		{
			animation.play("garlic");
		}
		else
		{
			animation.play("x");
		}
		
		if (alpha > 0)
		{
			alpha -= FlxG.elapsed;
		}
		
	}
	
}