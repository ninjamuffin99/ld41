package;

import flixel.FlxG;
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
		
		var txt:FlxText = new FlxText(20, 0, FlxG.width - 20, "", 25);
		
		if (youWon)
		{
			txt.text = "CONGRATS YOU BECAME PROM QUEEN AND BEAT THAT STINKER GARLIC KID\nPRESS R TO RESTART THE GAME!";
		}
		else
		{
			txt.text = "OH NO GARLIC KID WON AND STOLE THE KING FROM YOU! YOU LOSE\nPRESS R TO RESTART THE GAME!";
		}
		
		txt.screenCenter();
		add(txt);
			
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetGame();
		}
			
	}
	
}