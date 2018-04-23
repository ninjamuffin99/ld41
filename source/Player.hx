package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author 
 */
class Player extends Character 
{
	
	private var moving:Bool = false;
	private var attacking:Bool = false;
	public var onPhone:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, playerBulletArray:FlxTypedGroup<Bullet>) 
	{
		super(X, Y);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.DOWN, false, false);
		setFacingFlip(FlxObject.UP, false, false);
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.goblinSheetAll__png, AssetPaths.goblinSheetAll__txt);
		
		//exactly 69 unique animation frames nice
		frames = tex;
		
		resizeHitbox();
		//Idle
		animation.add("lr", [2]);
		animation.add("u", [1]);
		animation.add("d", [0]);
		animation.play("d");
		
		//Idle Phone
		animation.add("uPhone", [52]);
		animation.add("dPhone", [55]);
		animation.add("lrPhone", [58]);
		
		var frameRate:Int = 12;
		//attacks
		animation.add("uWalkAttack1", [3, 4, 5, 6], frameRate, false);
		animation.add("uWalkAttack2", [7, 8, 9, 10], frameRate, false);
		animation.add("uAttack1", [11, 12, 13, 14], frameRate, false);
		animation.add("uAttack2", [15, 16, 17, 18], frameRate, false);
		animation.add("dWalkAttack1", [19, 20, 21], frameRate, false);
		animation.add("dWalkAttack2", [23, 24, 25], frameRate, false);
		animation.add("dAttack1", [27, 28, 29, 30], frameRate, false);
		animation.add("dAttack2", [31, 32, 33, 34], frameRate, false);
		animation.add("lrWalkAttack1", [35, 36, 37], frameRate, false);
		animation.add("lrWalkAttack2", [39, 40, 41], frameRate, false);
		animation.add("lrAttack1", [43, 44, 45, 46], frameRate, false);
		animation.add("lrAttack2", [47, 48, 49, 50], frameRate, false);
		animation.add("lrAttack2", [47, 48, 49, 50], frameRate, false);
		//Phone
		animation.add("uWalkPhone", [51, 52, 53, 52], frameRate, false);
		animation.add("dWalkPhone", [54, 55, 56, 55], frameRate, false);
		animation.add("lrWalkPhone", [57, 58, 59, 58], frameRate, false);
		//Walking
		animation.add("uWalk", [60, 61, 62, 61], frameRate, false);
		animation.add("dWalk", [63, 64, 65, 64], frameRate, false);
		animation.add("lrWalk", [66, 67, 68, 67], frameRate, false);
		
		
		
		
		bulletArray = playerBulletArray;
		
		ID = Character.PLAYER;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		controls();
		rotation();
		firingHandling();
	}
	
	private function controls():Void
	{
		var _left:Bool = FlxG.keys.anyPressed(["A"]);
		var _right:Bool = FlxG.keys.anyPressed(["D"]);
		var _down:Bool = FlxG.keys.anyPressed(["S"]);
		var _up:Bool = FlxG.keys.anyPressed(["W"]);
		
		if (_left && _right)
		{
			_left = _right = false;
		}
		
		if (_up && _down)
		{
			_up = _down = false;
		}
		
		if (_left || _right || _up || _down)
		{
			moving = true;
			if (FlxG.keys.pressed.SHIFT)
			{
				maxVelocity.set(MaxVel * 1.4, MaxVel * 1.4);
			}
			else
			{
				maxVelocity.set(MaxVel, MaxVel);
			}
			
			if (_up)
			{
				acceleration.y = -Speed;
				facing = FlxObject.UP;
			}
			else if (_down)
			{
				acceleration.y = Speed;
				facing = FlxObject.DOWN;
			}
			else
				acceleration.y = 0;
			
			if (_left)
			{
				facing = FlxObject.LEFT;
				acceleration.x = -Speed;
			}
			else if (_right)
			{
				facing = FlxObject.RIGHT;
				acceleration.x = Speed;
			}
			else
				acceleration.x = 0;
			
			//acceleration.set(_playerSpeed, 0);
			//acceleration.rotate(FlxPoint.weak(0, 0), mA);
		}
		else
		{
			acceleration.x = acceleration.y = 0;
			
			moving = false;
		}
		
		if (!attacking)
		{
			if ((velocity.y != 0 || velocity.x != 0) && touching == FlxObject.NONE && moving)
			{
				switch(facing)
				{
					case FlxObject.LEFT:
						animation.play("lrWalk");
					case FlxObject.RIGHT:
						animation.play("lrWalk");
					case FlxObject.UP:
						animation.play("uWalk");
					case FlxObject.DOWN:
						animation.play("dWalk");
				}
				
				if (onPhone)
				{
					switch(facing)
					{
						case FlxObject.LEFT:
							animation.play("lrWalkPhone");
						case FlxObject.RIGHT:
							animation.play("lrWalkPhone");
						case FlxObject.UP:
							animation.play("uWalkPhone");
						case FlxObject.DOWN:
							animation.play("dWalkPhone");
					}
					
				}
				
			}
			else
			{
				switch(facing)
				{
					case FlxObject.LEFT:
						animation.play("lr");
					case FlxObject.RIGHT:
						animation.play("lr");
					case FlxObject.UP:
						animation.play("u");
					case FlxObject.DOWN:
						animation.play("d");
				}
				
				if (onPhone)
				{
					switch(facing)
					{
						case FlxObject.LEFT:
							animation.play("lrPhone");
						case FlxObject.RIGHT:
							animation.play("lrPhone");
						case FlxObject.UP:
							animation.play("uPhone");
						case FlxObject.DOWN:
							animation.play("dPhone");
					}
				
				}
			}
		}
		else
		{
			if (animation.curAnim.finished)
			{
				attacking = false;
			}
		}
		
	}
	
	private function rotation():Void
	{
		var rads:Float = Math.atan2(FlxG.mouse.y - (getMidpoint().y - 80), FlxG.mouse.x - getMidpoint().x);
		curRads = rads;
	}
	
	private function firingHandling():Void
	{
		if (!canFire)
		{
			curFirtime += 1;
		}
		
		if (curFirtime >= firerate)
		{
			canFire = true;
			curFirtime = 0;
		}
		
		var mClicked:Bool = FlxG.mouse.justPressed;
		var rmClicked:Bool = FlxG.mouse.justPressedRight;
		
		if (mClicked)
		{
			FlxG.camera.shake(0.01, 0.08);
			attack("Player");
			kissAnims("Left");
		}
		else if (rmClicked)
		{
			FlxG.camera.shake(0.01, 0.08);
			attack("PlayerRight");
			kissAnims("Right");
		}
	}
	
	private function kissAnims(direction:String):Void
	{
		attacking = true;
		if (direction == "Left")
		{
			switch(facing)
			{
				case FlxObject.LEFT:
					animation.play("lrAttack1");
				case FlxObject.RIGHT:
					animation.play("lrAttack2");
				case FlxObject.UP:
					animation.play("uAttack1");
				case FlxObject.DOWN:
					animation.play("dAttack2");
			}
		}
		else
		{
			switch(facing)
			{
				case FlxObject.LEFT:
					animation.play("lrAttack2");
				case FlxObject.RIGHT:
					animation.play("lrAttack1");
				case FlxObject.UP:
					animation.play("uAttack2");
				case FlxObject.DOWN:
					animation.play("dAttack1");
			}
		}
		
	}
	
	public function attack(bullType:String):Void
	{
		if (canFire)
		{
			
			var newBullet = new Bullet(getMidpoint().x, getMidpoint().y - 80, 1000, 60, curRads);
			newBullet.accuracy = accuracy;
			newBullet.bType = bullType;
			newBullet.velocity.x += velocity.x * 0.2;
			newBullet.velocity.y += velocity.y * 0.2;
			bulletArray.add(newBullet);
			canFire = false;
			
			velocity.x -= newBullet.velocity.x * 0.1;
			velocity.y -= newBullet.velocity.y * 0.1;
			
			/*
			var muzzFlash = new BulletStuff(getMidpoint().x - (32 / 2), getMidpoint().y - (20 / 2));
			var xdir = Math.cos(curRads);
			var ydir = Math.sin(curRads);
			muzzFlash.x += xdir * 35;
			muzzFlash.y += ydir * 35;
			muzzFlash.velocity.set(velocity.x * 0.15, velocity.y * 0.15);
			muzzFlash.angle = FlxAngle.asDegrees(curRads);
			
			FlxG.state.add(muzzFlash);
			*/
		}
		
	}
	
}