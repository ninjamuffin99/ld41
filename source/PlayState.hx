package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	private var _camTrack:FlxObject;
	private var _player:Player;
	private var playerBullets:FlxTypedGroup<Bullet>;

	private var enemy:Enemy;

	private var _grpCharacters:FlxTypedGroup<Character>;
	
	private var voteCounter:Int = 0;

	override public function create():Void
	{
		FlxG.camera.zoom = 0.5;

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.GRAY);
		add(bg);

		_camTrack = new FlxObject(0, 0, 1, 1);
		add(_camTrack);

		_grpCharacters = new FlxTypedGroup<Character>();
		add(_grpCharacters);

		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);

		_player = new Player(20, 20, playerBullets);
		_grpCharacters.add(_player);

		FlxG.camera.follow(_camTrack);
		FlxG.camera.followLerp = 0.6;

		enemy = new Enemy(50, 50);
		_grpCharacters.add(enemy);
		
		FlxG.worldBounds.set(0, 0, bg.width, bg.height);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_grpCharacters.sort(FlxSort.byY);
		cameraHandle();

		playerBullets.forEachAlive(checkBulletOverlap);

		FlxG.collide(_grpCharacters, _grpCharacters);

	}

	private function checkBulletOverlap(b:Bullet):Void
	{
		if (FlxCollision.pixelPerfectCheck(enemy, b))
		{
			/*enemy.velocity.x += b.velocity.x * 0.1;
			enemy.velocity.y += b.velocity.y * 0.1;*/
			FlxG.log.add("B Overlap");
			b.kill();
		}
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