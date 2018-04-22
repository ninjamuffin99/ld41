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
	public function new(?X:Float=0, ?Y:Float=0, playerBulletArray:FlxTypedGroup<Bullet>) 
	{
		super(X, Y);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.DOWN, false, false);
		setFacingFlip(FlxObject.UP, false, false);
		
		var tex = FlxAtlasFrames.fromSpriteSheetPacker(AssetPaths.goblinSheet__png, AssetPaths.goblinSheet__txt);
		
		frames = tex;
		
		resizeHitbox();
		
		animation.add("lr", [2]);
		animation.add("u", [1]);
		animation.add("d", [0]);
		animation.play("d");
		
		
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
		}
		
		
		if ((velocity.y != 0 || velocity.x != 0) && touching == FlxObject.NONE)
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
		}
		else if (rmClicked)
		{
			FlxG.camera.shake(0.01, 0.08);
			attack("PlayerRight");
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