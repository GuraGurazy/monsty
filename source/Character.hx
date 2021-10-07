package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var canDance:Bool = true;

	public var giantMonsty:FlxSprite = null;

	public var canMonstyDance:Bool = false;

	public var danceScared:Bool = false;

	public var canPlayAnimationsWithOffsets:Bool = true;

	public var fakegf:FlxSprite;
	public var altDance:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = FlxG.save.data.antialiasing;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_assets','shared',true);
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('DADDY_DEAREST','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND','shared',true);
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-scared':
				var tex = frames = Paths.getSparrowAtlas('BoyFriend_Scared_Ass_sets', 'shared', true);

				frames = tex;
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('lookingUp', 'BF idle watching more up', 24);

				animation.addByIndices('mechanicLeft', 'BF monsty mechanic', [1, 2, 3, 4, 4], '', 24, false);
				animation.addByIndices('mechanicRight', 'BF monsty mechanic', [6, 7, 8, 9, 9], '', 24, false);
				animation.addByIndices('mechanicDown', 'BF monsty mechanic', [11, 12, 13, 14, 14], '', 24, false);
				animation.addByIndices('mechanicUp', 'BF monsty mechanic', [16, 17, 18, 19, 19], '', 24, false);

				animation.addByPrefix('getSlapped', 'BF Slap Flushed', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset('singUPmiss', 0, 0);
				addOffset("singLEFTmiss", 0, 0);
				addOffset("singRIGHTmiss", 0, 0);
				addOffset("singDOWNmiss", 0, 0);
				addOffset("singDOWN", 0, 0);

				addOffset("firstDeath", 0, 0);
				addOffset("deathLoop", 0, 0);
				addOffset("deathConfirm", 0, 0);

				addOffset("scared", 0, 0);
				addOffset("lookingUp", 0, 0);

				addOffset("mechanicLeft", 0, 0);
				addOffset("mechanicRight", 0, 0);
				addOffset("mechanicUp", 0, 0);
				addOffset("mechanicDown", 0, 0);

				addOffset("getSlapped", 0, 0);

				playAnim('idle');

				flipX = true;
			case 'monsty':
				frames = Paths.getSparrowAtlas('monsty/monsty_assets');
	
				animation.addByPrefix('idle', 'Monsty Stand', 24, false);
				animation.addByPrefix('singUP', 'Monsty Up', 24, false);
				animation.addByPrefix('singDOWN', 'Monsty Down', 24, false);
				animation.addByPrefix('singLEFT', 'Monsty Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Monsty Right', 24, false);
				animation.addByPrefix('entryAnimation', 'Monsty Entry', 24, false);
				animation.addByPrefix('hey', 'Monsty Hey', 24, false);
	
				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset('entryAnimation', 0, 0);
				addOffset('hey', 0, 0);
	
				playAnim('idle');
			case 'monsty-serious':
				frames = Paths.getSparrowAtlas('monsty/monsty_serious_ass_sets');

				animation.addByPrefix('idle', 'Monsty Serious Idle', 24, false);
				animation.addByPrefix('singUP', 'Monsty Serious Up', 24, false);
				animation.addByPrefix('singDOWN', 'Monsty Serious Down', 24, false);
				animation.addByPrefix('singLEFT', 'Monsty Serious Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Monsty Serious Right', 24, false);
				animation.addByPrefix('jump', "Monsty Serious Jump", 24, false);
	
				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset("jump", 0, 0);
	
				playAnim('idle');
			case 'gf-monsty':
				frames = Paths.getSparrowAtlas('characters/GF_ass_for_monsty');
	
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('danceLeftAlone', 'GF Dancing Beat Alone', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRightAlone', 'GF Dancing Beat Alone', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);
				animation.addByPrefix('disappearGummies', 'GF Dancing Beat Gummies Disappear', 24, false);
	
				addOffset('danceLeft',0, 0);
				addOffset('danceRight', 0, 0);

				addOffset('scared', 0, 0);
	
				playAnim('scared');
		}

		dance();

		animation.curAnim.finish();

		if (isPlayer && frames != null)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function loadOffsetFile(character:String, library:String = 'shared')
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('images/characters/' + character + "Offsets", library));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'monsty')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false, altAnim:Bool = false)
	{
		if (canDance)
		{
			if (!debugMode)
			{
				switch (curCharacter)
				{
					case 'gf':
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					case 'gf-monsty':
						if (altDance == false)
						{
							danced = !danced;

							if (danced)
								playAnim('danceRight');
							else
								playAnim('danceLeft');
						}
						else if (altDance == true)
						{
							danced = !danced;

							if (danced)
								playAnim('danceRightAlone');
							else
								playAnim('danceLeftAlone');
						}
					case 'spooky':
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					default:
						if (altAnim && animation.getByName('idle-alt') != null)
							playAnim('idle-alt', forced);
						else
							playAnim('idle', forced);
				}
			}
		}

		if (giantMonsty != null && canMonstyDance)
		{
			giantMonsty.animation.play("idle");
		}

		if (danceScared)
		{
			playAnim("lookingUp", true);
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (canPlayAnimationsWithOffsets || AnimName.startsWith("sing"))
		{
			if (giantMonsty == null)
			{
				if (AnimName.endsWith('alt') && animation.getByName(AnimName) == null)
				{
					#if debug
					FlxG.log.warn(['Such alt animation doesnt exist: ' + AnimName]);
					#end
					AnimName = AnimName.split('-')[0];
				}

				animation.play(AnimName, Force, Reversed, Frame);

				var daOffset = animOffsets.get(AnimName);
				if (animOffsets.exists(AnimName))
				{
					offset.set(daOffset[0], daOffset[1]);
				}
				else
					offset.set(0, 0);
			}
			else
			{
				giantMonsty.animation.play(AnimName, Force, Reversed, Frame);
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
