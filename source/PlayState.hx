package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.system.FlxSound;
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
import com.newgrounds.components.*;
import com.newgrounds.*;

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
	
	private var _grpWalls:FlxTypedGroup<FlxObject>;
	
	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 2.5, true);
		FlxG.camera.zoom = 0.7;
		bg = new FlxSprite(0, 0);
		bg.loadGraphic(AssetPaths.BG_Gymnasium__png);
		bg.offset.y = 300;
		add(bg);
		
		FlxG.camera.setScrollBoundsRect(bg.x, bg.y - 300, bg.width, bg.height, true);
		
		FlxG.log.add(bg.width + " " + bg.height);
		
		FlxG.sound.playMusic("assets/music/589874_Beast-ModeREVERBED.mp3", 0.15);
		FlxG.sound.music.fadeIn(2, 0, 0.15);
		FlxG.sound.play(AssetPaths.crowdAmbient__mp3, 0.35, true);
		
		initCharacters();
		initHUD();
		
		//FlxG.worldBounds.setSize(bg.width * 3 + 10, bg.height * 3 + 10);

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
		_grpWalls = new FlxTypedGroup<FlxObject>();
		add(_grpWalls);
		
		var wall1:FlxObject = new FlxObject(0, 0, bg.width, 1);
		wall1.immovable = true;
		_grpWalls.add(wall1);
		
		var wall2:FlxObject = new FlxObject(0, 1150, bg.width, 1);
		wall2.immovable = true;
		_grpWalls.add(wall2);
		
		var wall3:FlxObject = new FlxObject(0, 0, 1, bg.height);
		wall3.immovable = true;
		_grpWalls.add(wall3);
		
		var wall4:FlxObject = new FlxObject(bg.width - 1, 0, 1, bg.height);
		wall4.immovable = true;
		_grpWalls.add(wall4);
		
		var wallStage1:FlxObject = new FlxObject(652, 62, 863, 80);
		wallStage1.immovable = true;
		_grpWalls.add(wallStage1);
		
		
		
		_camTrack = new FlxObject(0, 0, 1, 1);
		add(_camTrack);
		
		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);

		_grpCharacters = new FlxTypedGroup<Character>();
		add(_grpCharacters);
		
		_grpHearts = new FlxTypedGroup<HeartIcon>();
		add(_grpHearts);

		_player = new Player(20, 20, playerBullets);
		_grpCharacters.add(_player);

		FlxG.camera.follow(_camTrack);
		FlxG.camera.followLerp = 0.6;

		enemy = new Enemy(50, 50);
		_grpCharacters.add(enemy);
		
		
		for (i in 0...FlxG.random.int(50, 100))
		{
			var testie:Bystander = new Bystander(FlxG.random.float(100, bg.width - 60), FlxG.random.float(100, bg.height - 100));
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
		
		#if debug
			if (FlxG.keys.justPressed.R)
			{
				FlxG.switchState(new EndState(voteCounter, moawVotes));
			}
		#end
		
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
		FlxG.collide(_grpWalls, _grpCharacters);

	}
	
	private function finishGame():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
		{
			FlxG.switchState(new EndState(voteCounter, moawVotes));
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
		
		_player.onPhone = _phone.on;
		
		if (FlxG.keys.justPressed.E)
		{
			var goalY:Float = 0;
			var curEase;
			if (_phone.on)
			{
				FlxG.sound.play(AssetPaths.phoneOff__mp3, 0.7);
				goalY = FlxG.height + 160;
				curEase = FlxEase.backIn;
				
			}
			else
			{
				FlxG.sound.play(AssetPaths.phoneOn__wav, 0.7);
				goalY = 20;
				curEase = FlxEase.backOut;
				API.unlockMedal("MILLENIALS");
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
			case Character.BYSTANDER:
				if (c.x > bg.width || c.x < 0 || c.y > 1150 || c.y < -10)
				{
					c.setPosition(FlxG.random.float(100, bg.width - 100), FlxG.random.float(400, bg.height - 300));
				}
			case Character.ENEMY:
				for (i in _grpCharacters.members)
				{
					if (i.ID == Character.BYSTANDER && FlxMath.isDistanceWithin(c, i, 560) && i.currentVote != Character.ENEMY && i.y < 1060)
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
				if (c.x > bg.width || c.x < 0 || c.y > 1150 || c.y < -10)
				{
					c.setPosition(FlxG.random.float(100, bg.width - 100), FlxG.random.float(400, bg.height - 300));
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