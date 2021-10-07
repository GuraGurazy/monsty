package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.Stage.curStage;
		var daBf:String = '';
		switch (PlayState.boyfriend.curCharacter)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			default:
				daBf = 'bf';
		}

		if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == "serious-invasion")
		{
			daBf = 'bf-scared';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

		if (PlayState.SONG.song == "Serious Invasion")
		{
			FlxG.camera.zoom = 1;

			var redBG:FlxSprite = new FlxSprite(-1200, -1200);

			redBG.makeGraphic(FlxG.width+2400, FlxG.height+2400, FlxColor.RED);

			FlxTween.tween(FlxG.camera, {zoom: 100}, 120, {ease: FlxEase.sineIn});
			
			add(redBG);
			add(bf);
		}
		else
		{
			add(bf);
		}
	}

	var startVibin:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if(FlxG.save.data.InstantRespawn)
		{
			if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() != "serious-invasion")
				LoadingState.loadAndSwitchState(new PlayState());
			else
				if (!PlayState.isStoryMode)
					LoadingState.loadAndSwitchState(new PlayState());
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() != "serious-invasion")
				{
					FlxG.switchState(new StoryMenuState());
				}
				else
				{
					var mss:MonstyState = new MonstyState();

					mss.badendin = true;

					FlxG.switchState(mss);
				}
			else
				FlxG.switchState(new FreeplayState());

			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() != "serious-invasion")
			{
				FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));

				startVibin = true;
			}
			else
			{
				FlxG.sound.playMusic(Paths.music("gamerOverMonsty"));
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (startVibin && !isEnding)
		{
			bf.playAnim('deathLoop', true);
		}
		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			PlayState.startTime = 0;
			isEnding = true;
			FlxG.sound.music.stop();
			if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() != "serious-invasion")
				FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			else
				FlxG.sound.play(Paths.music('gamerOverMonstyEndie'));

			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
