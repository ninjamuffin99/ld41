package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	private var _camTrack:FlxObject;
	private var _player:Player;
	private var playerBullets:FlxTypedGroup<Bullet>;
	
	private var enemy:Enemy;
	
	override public function create():Void
	{
		_camTrack = new FlxObject(0, 0, 1, 1);
		add(_camTrack);
		
		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);
		
		_player = new Player(20, 20, playerBullets);
		add(_player);
		
		FlxG.camera.follow(_camTrack);
		FlxG.camera.followLerp = 0.6;
		
		enemy = new Enemy();
		add(enemy);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		cameraHandle();
	}
	
	private function cameraHandle():Void
	{
		//SHOUTOUT TO MIKE, AND ALSO BOMTOONS
		var dx = _player.x - FlxG.mouse.x;
		var dy = _player.y - FlxG.mouse.y;
		//var length = Math.sqrt(dx * dx + dy * dy);
		var camOffset = 0.4;
		dx *= camOffset;
		dy *= camOffset;
		
		if (FlxG.keys.pressed.SHIFT)
		{
			var shiftChange = 1.35;
			dx *= shiftChange;
			dy *= shiftChange;
		}
		_camTrack.x = _player.x - dx;
		_camTrack.y = _player.y - dy;
	}
}