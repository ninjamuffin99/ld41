package;

import flixel.FlxState;

class PlayState extends FlxState
{
	private var _player:Player;
	override public function create():Void
	{
		super.create();
		
		_player = new Player(20, 20);
		add(_player);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}