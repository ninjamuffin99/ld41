package;

import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author 
 */
class EndState extends FlxState 
{

	private var youWon:Bool = false;
	
	public function new(votes:Int, moawVotes:Int) 
	{
		super();
		
		if (votes > moawVotes)
		{
			youWon = true;
		}
		else
		{
			youWon = false;
		}
	}
	
	override public function create():Void 
	{
		super.create();
		
		var txt:FlxText = new FlxText(0, 0, 0, "", 32);
		txt.screenCenter();
		add(txt);
			
	}
	
}