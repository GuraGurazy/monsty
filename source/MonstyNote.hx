package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class MonstyNote extends FlxSprite
{
    public static var directions:Array<String> = ['Left', 'Up', 'Down', 'Right'];
	public var arrowAngles:Array<Int> = [180, 270, 90, 360]; //i had to redo da damnie angles, was pain
    public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
    public var theChoosenOne:Bool;
    public var canBePressed:Bool = true;
    public var daOffset:FlxPoint = new FlxPoint(0, 0);

    private var noteDataaa:Int = 0;

    public var forTentacle:Bool = false;
    public var forTentacle2:Bool = false;

    var centerPunto:FlxPoint = new FlxPoint();
    var preDelay:Float = 0;

    var fakeAngleLmao:Float = 0;
    var radius:Float = 175;
    var startDaUpdate:Bool = false;

    var diff:Int = 0;

    var fi:Int;
    var fu:Bool = false;

    private var STOPSPAMMINGDAMN:Bool = false;

    public function new(noteData:Int,
        choosenOne:Bool,
        preX:Float,
        preY:Float,
        preAngle:Float,
        difficultyOfTheThing:Int,
        fe:Int) //poggies
    {
        super();

        fi = fe;

        diff = difficultyOfTheThing;

        offset.set(210/2, 210/2);

        scale.set(1, 1);

        frames = Paths.getSparrowAtlas('Monsty_NOTE_ass_sets');

		crazySortingLmao(noteData);

		updateHitbox();
					
		antialiasing = FlxG.save.data.antialiasing;

        theChoosenOne = choosenOne;

        if (theChoosenOne)
            animation.play("normal", false);
		else
            animation.play("boring", false);

        x += preX;
        y += preY;

        //angle += preAngle * (noteData + 1); <------- confusing note, dumb idea, better watch below
        fakeAngleLmao = preAngle;  //circular-moving notes but they keep their direction
                                                 //so they are way more op
        centerPunto.x = preX;
        centerPunto.y = preY;

        noteDataaa = noteData;

        startDaUpdate = true;

        var radio:Float = radius;

        radius = 0;

        scale.set(0, 0);

        if (diff == 2)
            angle = Math.random()*360;

        FlxTween.tween(this, {radius: radio, "scale.y": 1, "scale.x": 1}, 0.5, {ease: FlxEase.sineOut});
    }
    override function update(elapsed:Float)
    {
        if (startDaUpdate) //basic cos sin based-movement, ez
        {
            if (diff == 0)
            {
                this.x = (centerPunto.x + Math.cos((fakeAngleLmao) * Math.PI / 180) * radius);
                this.y = (centerPunto.y + Math.sin((fakeAngleLmao) * Math.PI / 180) * radius);
    
                //fakeAngleLmao += 2.5; no rotation, so ez, BUT for make it a lil hardeR:
                angle += 1;
            }
            if (diff == 1)
            {
                this.x = (centerPunto.x + Math.cos((fakeAngleLmao) * Math.PI / 180) * radius);
                this.y = (centerPunto.y + Math.sin((fakeAngleLmao) * Math.PI / 180) * radius);

                fakeAngleLmao += 2.5;
            }
            if (diff == 2)
            {
                this.x = (centerPunto.x + Math.cos((fakeAngleLmao) * Math.PI / 180) * radius);
                this.y = (centerPunto.y + Math.sin((fakeAngleLmao) * Math.PI / 180) * radius);

                fakeAngleLmao += 5; //haha, poor try-hard ppl
                angle += 2.5;
            }
        }

        if (fi != PlayState.instance.currentmechanic && !fu)
        {
            disappear();

            fu = true;
        }
    }
    public function press()
    {
        if (!STOPSPAMMINGDAMN && canBePressed)
        {
            STOPSPAMMINGDAMN = true;

            if (theChoosenOne)
            {
                animation.play("pressed");

                forTentacle = true;

                PlayState.playBoyfriendcitoMechanic(noteDataaa);

                new FlxTimer().start(0.175, function(timer:FlxTimer)
                {
                    animation.play("boring", false);

                    FlxTween.tween(this, {"scale.x": 0, "scale.y":0}, 0.25, {ease: FlxEase.backIn, startDelay: preDelay, onComplete: function(tween:FlxTween)
                    {
                        this.visible = false;
                        this.kill();

                        tween.destroy();
                    }});
                });
            }
            else
            {
                animation.play("pressed");

                for (a in 0...PlayState.seriousGameMechanicArrows.length)
				{
					if (PlayState.seriousGameMechanicArrows[a].theChoosenOne)
						PlayState.playBoyfriendcitoMechanic(-1, a);
						
					PlayState.seriousGameMechanicArrows[a].disappear();
				}

                new FlxTimer().start(0.175, function(timer:FlxTimer)
                {
                    animation.play("boring", false);
                    
                    FlxTween.tween(this, {"scale.x": 0, "scale.y":0}, 0.25, {ease: FlxEase.backIn, startDelay: preDelay, onComplete: function(tween:FlxTween)
                    {
                        this.visible = false;
                        this.kill();

                        tween.destroy();
                    }});
                });
            }
        }
    }
    public function disappear()
    {
        FlxTween.tween(this, {alpha: 0}, 0.075, {ease: FlxEase.sineIn, startDelay: preDelay, onComplete: function(tween:FlxTween)
        {
            this.kill();
        }});
    }
    private function crazySortingLmao(code:Int)
    {
        if (code == PURP_NOTE)
        {
            animation.addByPrefix("normal", "purple alone", 24, false);
            animation.addByPrefix("pressed", "left confirm", 24, false);
            animation.addByPrefix("boring", "arrowLEFT", 24, false);
            animation.addByPrefix("you ded lmao", "left press", 24, false);

            daOffset.x = -this.width;

            preDelay = 0;
        }
        if (code == GREEN_NOTE)
        {
            animation.addByPrefix("normal", "green alone", 24, false);
            animation.addByPrefix("pressed", "up confirm", 24, false);
            animation.addByPrefix("boring", "arrowUP", 24, false);
            animation.addByPrefix("you ded lmao", "up press", 24, false);

            daOffset.y = -this.height;

            preDelay = 0.15;
        }
        if (code == BLUE_NOTE)
        {
            animation.addByPrefix("normal", "blue alone", 24, false);
            animation.addByPrefix("pressed", "down confirm", 24, false);
            animation.addByPrefix("boring", "arrowDOWN", 24, false);
            animation.addByPrefix("you ded lmao", "down press", 24, false);

            daOffset.y = this.height;

            preDelay = 0.30;
        }
        if (code == RED_NOTE)
        {
            animation.addByPrefix("normal", "red alone", 24, false);
            animation.addByPrefix("pressed", "right confirm", 24, false);
            animation.addByPrefix("boring", "arrowRIGHT", 24, false);
            animation.addByPrefix("you ded lmao", "right press", 24, false);

            daOffset.x = this.width;

            preDelay = 0.45;
        }
    }
}