package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
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
	
	private var gobHead:FlxSprite;
	private var stinkerHead:FlxSprite;
	
	private var tooltip1:FlxText;
	
	private var bg:FlxSprite;
	private var info:FlxText;
	
	private var txtE:FlxText;
	
	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) 
	{
		super(X, Y, MaxSize);
		
		_bg = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.45), Std.int(FlxG.height * 1.1), FlxColor.BLUE);
		FlxG.log.add(_bg.width + " " + _bg.height);
		add(_bg);
		
		txtE = new FlxText(24, -36, 0, "Press E", 24);
		add(txtE);
		
		gobHead = new FlxSprite(15, 15).loadGraphic(AssetPaths.goblinHead__png);
		gobHead.angle = 15;
		add(gobHead);
		
		stinkerHead = new FlxSprite(15, gobHead.height + 5).loadGraphic(AssetPaths.stinkerHead__png);
		stinkerHead.angle = -20;
		add(stinkerHead);
				
		txtVotes = new FlxText(20 + gobHead.width, 60, 0, "", 36);
		add(txtVotes);
		
		txtTimer = new FlxText(20, 235, 0, "", 24);
		add(txtTimer);
		
		var tipX = _bg.width / 2 - 64;
		var tipY = _bg.height * 0.7 - 64;
		/*
		tooltip1 = new FlxText(tipX - 16, tipY, 0, "Hover for info", 16);
		add(tooltip1);
		*/
		bg = new FlxSprite(16, tipY + 30).makeGraphic(Std.int(FlxG.width * 0.45) - 32, 245, FlxColor.GRAY);
		//add(bg);
		
		info = new FlxText(32, tipY -8, bg.width - 32, "Left Click to blow kiss\nRight Click to check who they voted for\nE to open and close phone\nMade by\nninjamuffin99 and FuShark\nAdditional art by\nBrandyBuizel and Digimin\nFor Ludum Dare 41", 14);
		add(info);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.E)
		{
			txtE.visible = false;
		}
		
		timerHandling();
		
		txtVotes.text = "" + votes + " / " + totVotes;
		txtVotes.text += "\n\n" + votesMoaw + " / " + totVotes;
		
		//bg.visible = FlxG.mouse.overlaps(tooltip1);
		//info.visible = FlxG.mouse.overlaps(tooltip1);
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