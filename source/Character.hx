package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Character extends FlxSprite 
{

	public var followSpeed:Int = 150;
	public var Speed:Float = 2700;
	private var Drag:Float = 900;
	private var MaxVel:Float = 350;
	private var curRads:Float = 0;
	public var accuracy:Float = 1;

	public var tartgetLook:FlxPoint = FlxPoint.get();
	public var firerate:Int = 0;
	private var curFirtime:Int = 0;
	public var canFire:Bool = false;
	public var isDead:Bool = false;
	public var maxHealth:Float = 10;
	
	public var bulletArray:FlxTypedGroup<Bullet>;
	
	private var hitBox:FlxObject;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
	}
	
	private function resizeHitbox():Void
	{
		offset.set(78, height - 50);
		width = 100;
		height = 50;
	}
	
}