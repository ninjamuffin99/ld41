package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Bystander extends Character 
{

	private var _brain:FSM;
	private var _idleTmr:Float = 0;
	private var _moveDir:Float;

	public var byType:Int = 0;

	
	public static inline var NONE:Int = 0;
	public static inline var CHAPERONE:Int = 1;
	public static inline var KID:Int = 2;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		ID = Character.BYSTANDER;
		
		loadGraphic("assets/images/npc" + FlxG.random.int(1, 5) + ".png");
		resizeHitbox();
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
		byType = KID;
		
		if (FlxG.random.bool(10))
		{
			ID = Character.CHAPERONE;
			
			var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.chaperoneSheet__png, AssetPaths.chaperoneSheet__txt);
			
			//exactly 69 unique animation frames nice
			frames = tex;
			animation.add("idle", [0]);
			animation.add("run", [1, 2, 3, 2], 12);
			animation.play("idle");
			
			resizeHitbox();
			width += 15;
		}
		
		_brain = new FSM(idle);
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		super.update(elapsed);
		
				
		if (anger > 0)
		{
			animation.play("run");
		}
		else if (ID == Character.CHAPERONE)
		{
			animation.play("idle", true);
		}
		
		
		if (velocity.x > 0)
		{
			facing = FlxObject.RIGHT;
		}
		else if (velocity.x < 0)
		{
			facing = FlxObject.LEFT;
		}
		
		if (anger > 0)
		{
			anger -= FlxG.elapsed;
		}
		else
		{
			_brain.update();
		}
	}
	
	public function idle():Void
	{
		if (_idleTmr <= 0)
		{
			if (FlxG.random.bool(1))
			{
				_moveDir = -1;
				velocity.x = velocity.y = 0;
			}
			else
			{
				_moveDir = FlxG.random.int(0, 8) * 45;
				
				velocity.set(Speed * 0.5, 0);
				velocity.rotate(FlxPoint.weak(), _moveDir);
			}
			_idleTmr = FlxG.random.float(1, 5);
		}
		else
			_idleTmr -= FlxG.elapsed;
	}
	
}