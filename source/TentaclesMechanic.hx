package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import MonstyNote;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import PlayState;

class TentaclesMechanic extends FlxObject
{
	public var tentacle:FlxSprite;

	private var duration:Float = -1;
	private var directions:Array<String> = ["LEFT", "DOWN", "UPPY", "RIGHTY"];
	public var monstyNote:MonstyNote = null;
	private var goingToAttack:Bool = false;
	private var slapSound:FlxSound;
	private var bfMoan:FlxSound; //hehehehe 7w7
	private var canContinue:Bool = true;
	private var stopContinuing:Bool = false; //no sense lmao
	private var soundGap:Float = 0.08;
	private var e:Bool = false;

	private var playState:PlayState;

	public var tentacles:Array<FlxSprite> = [new FlxSprite(), new FlxSprite(), new FlxSprite(), new FlxSprite()];

	public var tentacleHit:FlxSprite = new FlxSprite();

	public function new(_playState:PlayState)
	{
		super();

		playState = _playState; //fuk

		FlxTween.tween(this, {y: this.y - 100}, 2, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});

		visible = false;
		active = false;

		setUpAnimations();
		setOffsets();
	}
	public function moveTentacle(direction:Int) //0 - left | 1 - up | 2 - down | 3 - right
	{
		tentacles[direction].visible = true;
		tentacles[direction].active = true;

		tentacles[direction].animation.play('appear');
	}
	public function disappearTentacle(direction:Int, isChoosen:Bool):Void
	{
		if (isChoosen)
		{
			tentacles[direction].animation.play("disappear");

			new FlxTimer().start(0.416, function (timer:FlxTimer)
			{
				tentacles[direction].visible = false;
				tentacles[direction].active = false;
			});
		}
		else
		{
			tentacles[direction].animation.play("preAttack");
			tentacles[direction].active = true;

			new FlxTimer().start(0.333, function (timer:FlxTimer)
			{
				tentacleHit.animation.play("hit", true);

				new FlxTimer().start(0.208, function (timer:FlxTimer)
				{
					tentacleHit.visible = false;
				});

				tentacleHit.visible = true;

				tentacleHit.updateHitbox();

				tentacleHit.x = PlayState.boyfriend.x - 50;
				tentacleHit.y = PlayState.boyfriend.y - 50;

				tentacles[direction].animation.play("attack", true);

				playState.endGameTheMovieLMAO();

				FlxG.sound.play(Paths.soundRandom("mechanicSFX/MonstySlap", 1, 2));
				FlxG.sound.play(Paths.soundRandom("mechanicSFX/BoyfriendHurts", 1, 2)); //laod soudns
			});
		}
	}
	public function setUpAnimations()
	{
		tentacles[0].frames = Paths.getSparrowAtlas(Std.string("monsty/tentaCULOS/tentacle" + directions[0]));

		tentacles[0].animation.addByPrefix("appear", "Tentacles Mechanic Appear", 24, false);
		tentacles[0].animation.addByPrefix("preAttack", "Tentacles Mechanic Pre Attack", 24, false);
		tentacles[0].animation.addByPrefix("attack", "Tentacles Mechanic Attack Disappear", 24, false);
		tentacles[0].animation.addByPrefix("disappear", "Tentacles Mechanic Disappear", 24, false);

		tentacles[0].animation.play("appear");

		tentacles[1].frames = Paths.getSparrowAtlas(Std.string("monsty/tentaCULOS/tentacle" + directions[1]));

		tentacles[1].animation.addByPrefix("appear", "Tentacles Mechanic Appear", 24, false);
		tentacles[1].animation.addByPrefix("preAttack", "Tentacles Mechanic Pre Attack", 24, false);
		tentacles[1].animation.addByPrefix("attack", "Tentacles Mechanic Attack Disappear", 24, false);
		tentacles[1].animation.addByPrefix("disappear", "Tentacles Mechanic Disappear", 24, false);

		tentacles[1].animation.play("appear");

		tentacles[2].frames = Paths.getSparrowAtlas(Std.string("monsty/tentaCULOS/tentacle" + directions[2]));

		tentacles[2].animation.addByPrefix("appear", "Tentacles Mechanic Appear", 24, false);
		tentacles[2].animation.addByPrefix("preAttack", "Tentacles Mechanic Pre Attack", 24, false);
		tentacles[2].animation.addByPrefix("attack", "Tentacles Mechanic Attack Disappear", 24, false);
		tentacles[2].animation.addByPrefix("disappear", "Tentacles Mechanic Disappear", 24, false);

		tentacles[2].animation.play("appear");

		tentacles[3].frames = Paths.getSparrowAtlas(Std.string("monsty/tentaCULOS/tentacle" + directions[3]));

		tentacles[3].animation.addByPrefix("appear", "Tentacles Mechanic Appear", 24, false);
		tentacles[3].animation.addByPrefix("preAttack", "Tentacles Mechanic Pre Attack", 24, false);
		tentacles[3].animation.addByPrefix("attack", "Tentacles Mechanic Attack Disappear", 24, false);
		tentacles[3].animation.addByPrefix("disappear", "Tentacles Mechanic Disappear", 24, false);

		tentacles[3].animation.play("appear");

		tentacleHit.frames = Paths.getSparrowAtlas("monsty/tentaCULOS/tentacleHIT");

		tentacleHit.animation.addByPrefix("hit", "Tentacles Hit", 24, false);

		tentacleHit.animation.play("hit");

		for (i in tentacles)
		{
			i.visible = false;
			i.active = false;
		}

		tentacleHit.visible = false;
	}
	private function setOffsets()
	{
		tentacles[0].updateHitbox();
		tentacles[1].updateHitbox();
		tentacles[2].updateHitbox();
		tentacles[3].updateHitbox();

		tentacles[0].x -= 1250;
		tentacles[0].y += 50; //left

		tentacles[1].x -= 50;
		tentacles[1].y += 500; //down

		tentacles[2].x -= 900;
		tentacles[2].y -= 275; //up

		tentacles[3].x += 125;
		tentacles[3].y -= 25; //right
	}
}