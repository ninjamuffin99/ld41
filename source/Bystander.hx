package;
import flixel.FlxG;
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
		
		
		byType = KID;
		
		if (FlxG.random.bool(10))
		{
			ID = Character.CHAPERONE;
			color = FlxColor.BLUE;
		}
		
		_brain = new FSM(idle);
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		super.update(elapsed);
		
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