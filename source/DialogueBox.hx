package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bgFade:FlxSprite;

	var sound:FlxSound;
	var backgroudMusic:FlxSound;

	var canContinue = true;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		FlxTween.tween(bgFade, {alpha: 0.7}, 1, {ease: FlxEase.linear});

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		
		hasDialog = true;
		box.frames = Paths.getSparrowAtlas('monsty/speech_bubble_talking');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);

		box.y += 300;
		box.x = 500;

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('monsty/Monsty Portrait');
		portraitLeft.animation.addByPrefix('enter', 'Monsty Portrait', 24, false);
		portraitLeft.animation.addByPrefix('enterScary', 'Monsty Scary Portrait', 24, false);
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		portraitLeft.y += 150;
		portraitLeft.x -= 25;
		
		portraitRight = new FlxSprite(0, 0);
		portraitRight.frames = Paths.getSparrowAtlas('monsty/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend Portrait enter', 24, false);
		portraitRight.animation.addByPrefix('enterScared', 'Boyfriend Portrait Scared', 24, false);
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		box.animation.play('normalOpen');

		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		if (PlayState.Stage.curStage == 'monstyBackground' || PlayState.Stage.curStage == 'monstyBackgroundFinal')
		{
			portraitLeft.x -= 350;
			box.x += 0;
			portraitLeft.y -= 20;
			portraitRight.x += 715;
			portraitRight.y += 220;
		}


		if (!talkingRight)
		{
			// box.flipX = true;
		}
		
		dropText = new FlxText(242.5, 502.5, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0x00618FFF;
			
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('monstyText'), 0.6)];
		swagDialogue.color = FlxColor.BLACK;
			
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	public function startBackgroundMusic(currentSong:String)
	{
		switch (currentSong)
		{
			case 'monsty':
				backgroudMusic = new FlxSound().loadEmbedded(Paths.music('monstyMiniSong1'), true);

				backgroudMusic.volume = 0;

				FlxG.sound.list.add(backgroudMusic);

				backgroudMusic.fadeIn(1, 0, 0.4);
			case 'alien-mop':
				backgroudMusic = new FlxSound().loadEmbedded(Paths.music('monstyMiniSong2'), true);
	
				backgroudMusic.volume = 0;
	
				FlxG.sound.list.add(backgroudMusic);
	
				backgroudMusic.fadeIn(1, 0, 0.4);
			case 'intense-fight':
				backgroudMusic = new FlxSound().loadEmbedded(Paths.music('monstyMiniSong3'), true);
		
				backgroudMusic.volume = 0;
		
				FlxG.sound.list.add(backgroudMusic);
		
				backgroudMusic.fadeIn(1, 0, 0.4);
			case 'serious-invasion':
				backgroudMusic = new FlxSound().loadEmbedded(Paths.music('monstyMiniSong4'), true);
			
				backgroudMusic.volume = 0;
			
				FlxG.sound.list.add(backgroudMusic);
			
				backgroudMusic.fadeIn(1, 0, 0.4);
		}
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (!PlayState.instance.shittyshit)
					{
						if (PlayState.SONG.song.toLowerCase() == 'alien mop' || PlayState.SONG.song.toLowerCase() == 'monsty' || PlayState.SONG.song.toLowerCase() == "intense fight" || PlayState.SONG.song.toLowerCase() == "serious invasion")
							backgroudMusic.fadeOut(1, 0);
					}
							
					FlxTween.tween(box, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(bgFade, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(portraitLeft, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(portraitRight, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(swagDialogue, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(dropText, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(swagDialogue, {alpha: 0}, 1, {ease: FlxEase.linear});

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');

					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('monstyText'), 0.6)];
				}
			case 'dad-scary':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enterScary');

					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('monstyText'), 0.6)];
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');

					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('boyfriendVoice'), 0.6)];
				}
			case 'bf-scared':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enterScared');
	
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('boyfriendVoice'), 0.6)];
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
