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
		makeGraphic(40, 40);
		
		tarBystander = bystander;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		x = tarBystander.x + 75;
		y = tarBystander.y - 125;
		
		if (tarBystander.currentVote == Character.PLAYER)
		{
			color = FlxColor.PURPLE;
		}
		else if (tarBystander.currentVote == Character.ENEMY)
		{
			color = FlxColor.RED;
		}
		else
		{
			color = FlxColor.MAGENTA;
		}
		
		if (alpha > 0)
		{
			alpha -= FlxG.elapsed;
		}
		
	}
	
}