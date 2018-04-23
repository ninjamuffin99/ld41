package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.util.FlxSort;
import openfl.Lib;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

class PlayState extends FlxState
{
	private var bg:FlxSprite;
	
	private var _camTrack:FlxObject;
	private var _player:Player;
	private var playerBullets:FlxTypedGroup<Bullet>;
	private var enemy:Enemy;

	private var _grpCharacters:FlxTypedGroup<Character>;
	private var _grpHearts:FlxTypedGroup<HeartIcon>;
	
	private var _phone:PhoneGroup;
	
	
	private var voteCounter:Int = 0;
	private var totalVotes:Int = 0;
	private var moawVotes:Int = 0;
	private var countdown:Float = 120;

	private var finished:Bool = false;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 0.7;
		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.GRAY);
		add(bg);
		
		initCharacters();
		initHUD();
		
		FlxG.worldBounds.set(0, 0, bg.width, bg.height);

		//playMovie();
		super.create();
	}
	
	private function playMovie():Void
	{
		//LMAO I came across this bullshit, here's how to load mp4's from the web, LMAOOO
		var screen = new Video();
		var connection = new NetConnection();
		connection.connect(null);
		var stream = new NetStream(connection);
		screen = new Video();
		FlxG.stage.addChild(screen);
		screen.attachNetStream(stream);
		trace(" Now playing movie1.flv ");
		stream.play("https://uploads.ungrounded.net/alternate/1211000/1211677_alternate_58915.720p.mp4?f1523935941");
	}
	
	private function initCharacters():Void
	{
		
		_camTrack = new FlxObject(0, 0, 1, 1);
		add(_camTrack);

		_grpCharacters = new FlxTypedGroup<Character>();
		add(_grpCharacters);
		_grpHearts = new FlxTypedGroup<HeartIcon>();
		add(_grpHearts);

		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);

		_player = new Player(20, 20, playerBullets);
		_grpCharacters.add(_player);

		FlxG.camera.follow(_camTrack);
		FlxG.camera.followLerp = 0.6;

		enemy = new Enemy(50, 50);
		_grpCharacters.add(enemy);
		
		for (i in 0...FlxG.random.int(30, 100))
		{
			var testie:Bystander = new Bystander(FlxG.random.float(0, bg.width), FlxG.random.float(0, bg.height));
			_grpCharacters.add(testie);
			totalVotes += 1;
			
			var heart:HeartIcon = new HeartIcon(0, 0, testie);
			_grpHearts.add(heart);
			
			testie.heart = heart;
			
		}
	}
	
	private function initHUD():Void
	{
		_phone = new PhoneGroup(10, FlxG.height);
		_phone.scrollFactor.set();
		add(_phone);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		phoneHandling();
		
		if (countdown > 0)
		{
			countdown -= FlxG.elapsed;
		}
		else if (!finished)
		{
			finishGame();
			finished = true;
		}

		moawVotes = 0;
		voteCounter = 0;
		_grpCharacters.forEach(characterLogic);
		
		_grpCharacters.sort(FlxSort.byY);
		
		playerBullets.forEachAlive(checkBulletOverlap);
		
		FlxG.collide(_grpCharacters, _grpCharacters);

	}
	
	private function finishGame():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
		{
			//send all the people to near the stage facing up, and turn off their AI
			FlxG.camera.fade(FlxColor.BLACK, 1, true, function()
			{
				//text shit
			});
		});
	}
	
	private function phoneHandling():Void
	{	
		_phone.countTimer = countdown;
		_phone.votes = voteCounter;
		_phone.totVotes = totalVotes;
		_phone.votesMoaw = moawVotes;
		
		if (FlxG.keys.justPressed.E)
		{
			var goalY:Float = 0;
			var curEase;
			if (_phone.on)
			{
				goalY = FlxG.height + 160;
				curEase = FlxEase.backIn;
			}
			else
			{
				goalY = 20;
				curEase = FlxEase.backOut;
			}
			
			_phone.on = !_phone.on;
			
			FlxTween.tween(_phone, {y: goalY}, 0.4, {ease:curEase});
		}
		
		
		if (_phone.on)
		{
			FlxG.camera.followLerp = 0.04;
			_camTrack.setPosition(_player.x - 150, _player.y - 50);
			if (_camTrack.ID != 1)
			{
				FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.3, {ease:FlxEase.quadInOut});
				_camTrack.ID = 1;
			}
		}
		else
		{
			if (_camTrack.ID != 0)
			{
				FlxTween.tween(FlxG.camera, {zoom: 0.7}, 0.3, {ease:FlxEase.quadInOut});
				_camTrack.ID = 0;
			}
			
			FlxG.camera.followLerp = 0.45;
			cameraHandle();
		}
	}

	private function characterLogic(c:Character):Void
	{
		switch(c.currentVote)
		{
			case Character.PLAYER:
				voteCounter += 1;
			case Character.ENEMY:
				moawVotes += 1;
		}
		
		switch(c.ID)
		{
			case Character.ENEMY:
				for (i in _grpCharacters.members)
				{
					if (i.ID == Character.BYSTANDER && FlxMath.isDistanceWithin(c, i, 560) && i.currentVote != Character.ENEMY)
					{
						FlxVelocity.moveTowardsObject(c, i, 130);
					}
					
					if (FlxMath.isDistanceWithin(c, i, 100))
					{
						i.currentVote = Character.ENEMY;
					}
				}
			case Character.CHAPERONE:
				if (c.anger > 0)
				{
					FlxVelocity.moveTowardsObject(c, _player, 320);
					if (FlxMath.isDistanceWithin(c, _player, 90))
					{
						FlxG.resetGame();
					}
				}
		}
	}
	
	private function checkBulletOverlap(b:Bullet):Void
	{
		
		for (c in _grpCharacters.members)
		{
			if (FlxCollision.pixelPerfectCheck(c, b))
			{
				switch(c.ID)
				{
					case Character.ENEMY:
						/*enemy.velocity.x += b.velocity.x * 0.1;
						enemy.velocity.y += b.velocity.y * 0.1;*/
						FlxG.log.add("B Overlap");
						b.kill();
					case Character.BYSTANDER:
						if (b.bType == "Player")
						{
							if (c.currentVote == Character.PLAYER || c.currentVote == Character.ENEMY)
							{
								c.currentVote = Character.NONE;
							}
							else if (c.currentVote == Character.NONE)
							{
								c.currentVote = Character.PLAYER;
							}
						}
						else if (c.heart != null)
						{
							c.heart.alpha = 1;
						}
						
						b.kill();
					case Character.CHAPERONE:
						if (b.bType == "Player")
						{
							c.anger += FlxG.random.float(1, 4);
						}
						b.kill();
				}
				
			}	
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
		_camTrack.x = _player.x - dx;
		_camTrack.y = _player.y - dy;
	}
}