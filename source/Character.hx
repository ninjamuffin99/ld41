package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Character extends FlxSprite 
{

	public var followSpeed:Int = 150;
	public var Speed:Float = 1850;
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
	
	public static inline var PLAYER:Int = 1;
	public static inline var ENEMY:Int = 2;
	public static inline var BYSTANDER:Int = 3;
	
	public var votedPlayer:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(110, 180, FlxColor.GREEN);
		
		
		drag.x = Drag;
		drag.y = Drag;
		maxVelocity.x = maxVelocity.y = MaxVel;
		
		resizeHitbox();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		this.set_visible(this.isOnScreen());
	}
	
	private function resizeHitbox():Void
	{
		offset.set(20, height - 50);
		width = 70;
		height = 50;
	}
	
}