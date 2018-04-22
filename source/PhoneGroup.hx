package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class PhoneGroup extends FlxSpriteGroup 
{
	private var _bg:FlxSprite;

	private var txtTimer:FlxText;
	private var txtVotes:FlxText;
	
	public var votes:Int = 0;
	public var totVotes:Int = 0;
	public var countTimer:Float = 0;
	public var votesMoaw:Int = 0;
	public var on:Bool = false;
	
	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) 
	{
		super(X, Y, MaxSize);
		
		_bg = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.45), Std.int(FlxG.height * 1.1), FlxColor.BLUE);
		add(_bg);
		
		txtVotes = new FlxText(10, 10, 0, "", 24);
		add(txtVotes);
		
		txtTimer = new FlxText(10, 260, 0, "", 24);
		add(txtTimer);
		
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		timerHandling();
		
		txtVotes.text = "Your Votes: " + votes + " / " + totVotes;
		txtVotes.text += "\nGarlic Kid's Votes: " + votesMoaw + " / " + totVotes;
		
		
	}
	
		
	private function timerHandling():Void
	{

		var countMin = Std.int(countTimer / 60);
		var countSec = Std.int(countTimer % 60);
		
		if (countSec >= 10)
		{
			txtTimer.text = "Time Left: " + countMin + ":" + countSec;
		}
		else
			txtTimer.text = "Time Left: " + countMin + ":0" + countSec;
		
		
	}
	
	
}