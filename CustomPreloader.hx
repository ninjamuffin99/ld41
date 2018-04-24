package;

import flixel.system.FlxBasePreloader;
import com.newgrounds.*;
import com.newgrounds.components.*;

/**
 * ...
 * @author ninjaMuffin
 */
class CustomPreloader extends FlxBasePreloader 
{
	/* A preloader!
	 * Does nothing except show a Newgrounds ad
	 * 
	*/

	public function new(MinDisplayTime:Float=0, ?AllowedURLs:Array<String>) 
	{
		super(MinDisplayTime, AllowedURLs);
		
	}
	
	override function create():Void 
	{
		//Connects to the Newgrounds API
		API.connect(root, "47626:Ya7ebB9t", "zg2VJflHecbmja5VCmePGk3xD9Ua7GnQ");
		
		if (API.isNewgrounds)
		{
			var ad:FlashAd = new FlashAd();
			ad.x = 30;
			ad.y = 20;
			addChild(ad);
			minDisplayTime = 8;
			
			
		}
		
		super.create();
	}
	
}