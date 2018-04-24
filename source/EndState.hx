package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
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
		
		var bg:FlxSprite = new FlxSprite( -900, -40).loadGraphic(AssetPaths.BG_Gymnasium__png);
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		add(bg);
		var txt:FlxText = new FlxText(20, FlxG.height - 48, FlxG.width - 20, "", 16);
		
		var jeff:FlxSprite = new FlxSprite(360, 180).loadGraphic(AssetPaths.PG_Johny_win__png);
		add(jeff);
		
		if (youWon)
		{
			txt.text = "CONGRATS YOU BECAME PROM QUEEN AND BEAT THAT STINKER GARLIC KID\nPRESS R TO RESTART THE GAME!";
			
			var sofi:FlxSprite = new FlxSprite(200, 200);
			var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.goblinSheetAll__png, AssetPaths.goblinSheetAll__txt);
			sofi.frames = tex;
			sofi.animation.add("dAttack1", [27, 28, 29, 30, 31, 32, 33, 34], 9, true);
			sofi.animation.play("dAttack1");
			add(sofi);
		}
		else
		{
			txt.text = "OH NO GARLIC KID WON AND STOLE THE KING FROM YOU! YOU LOSE\nPRESS R TO RESTART THE GAME!";
			var garlic:FlxSprite = new FlxSprite(200, 200).loadGraphic(AssetPaths.stinker__png);
			garlic.angularVelocity = 60;
			add(garlic);
		}
		
		txt.screenCenter(X);
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