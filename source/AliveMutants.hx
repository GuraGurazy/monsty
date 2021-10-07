package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import PlayState;

using StringTools;

class AliveMutants extends FlxSprite
{
    public var aliveMutants:Array<FlxSprite> = [];
    public var mutantsOnScreen:Array<Bool> = [false, false, false, false];
    public var mutantsAbleToDance:Array<Bool> = [false, false, false, false];
    public var mutantsDancedLeft:Array<Bool> = [false, false, false, false];
    public var finalPosX:Array<Float> = [0, 0, 0, 0];
    public var finalPosY:Array<Float> = [0, 0, 0, 0];

    public var vincitoGUI:FlxSprite;
    public var vincitoGUINext:String = "";
    public var vincitoCanDance:Bool = false;
    public var vincitoDancedLeft:Bool = false;
    public var vincitoCanAppear:Bool = true;
    public var vincitoFree:Bool = true;

    public var gurazyRunning:FlxSprite;
    public var gurazyRunningFromRight:Bool = false;
    public var gurazyCanAppear:Bool = true;

    public var freeTentacle:FlxSprite;

    public function new(neartoCloseInvasion:Bool, seriousInvasion:Bool=false)
    {
        super();

        if (neartoCloseInvasion)
            drawGuiMutants(seriousInvasion);

        drawMovingMutants();
    }
    public function makeAllMutantsRun()
    {
        for (i in 0...mutantsAbleToDance.length)
            mutantsAbleToDance[i] = false;

        aliveMutants[0].animation.play("running", true);

        FlxTween.tween(aliveMutants[0], {x: aliveMutants[0].x+2500, y: aliveMutants[0].y + 800}, 3.5, {onComplete: function(tween:FlxTween)
        {
            tween.destroy();

            aliveMutants[0].visible = false;
        }, ease: FlxEase.linear});

        new FlxTimer().start(3, function(timer)
        {
            aliveMutants[2].animation.play("running", true);

            FlxTween.tween(aliveMutants[2], {x: aliveMutants[2].x-2500, y: aliveMutants[2].y + 800}, 3.5, {onComplete: function(tween:FlxTween)
            {
                tween.destroy();

                aliveMutants[2].visible = false;
            }, ease: FlxEase.linear});
        });

        new FlxTimer().start(1, function(timer)
        {
            aliveMutants[3].animation.play("running", true);

            FlxTween.tween(aliveMutants[3], {x: aliveMutants[3].x-2500, y: aliveMutants[3].y}, 3.5, {onComplete: function(tween:FlxTween)
            {
                tween.destroy();

                aliveMutants[3].visible = false;
            }, ease: FlxEase.linear});
        });
    }
    private function drawMovingMutants()
    {
        var ezframes1:Array<Int> = [];
        var ezframes2:Array<Int> = [];
        var ezframes3:Array<Int> = [];
        var current:Int = 0;

        for (a in 0...16) //0 to 15
            ezframes1.push(a);
        for (e in 17...27) //17 to 37
            ezframes2.push(e);
        for (b in 27...38) //17 to 37
            ezframes3.push(b);
        for (i in 0...4) //0 to 3
        {
            var ruta:String = "";

            if (current == 0)
                ruta = "Mutant Screen Left";
            if (current == 1)
                ruta = "Mutant Screen Left 2";

            if (current == 2)
                ruta = "Mutant Screen Right";
            if (current == 3)
                ruta = "Mutant Screen Right 2";

            current++;

            var mutant:FlxSprite = new FlxSprite();
            var rann:Int = Std.int(-4 + Math.random()*8);

            mutant.frames = Paths.getSparrowAtlas("monsty/backgroundStuff/bgMutantsAlive");

            mutant.animation.addByIndices("running", ruta, ezframes1, "", 24+rann, true);
            mutant.animation.addByIndices("dancingL", ruta, ezframes2, "", 24+rann, false);
            mutant.animation.addByIndices("dancingR", ruta, ezframes3, "", 24+rann, false);

            mutant.animation.play("running");

            mutant.animation.finish();

            aliveMutants.push(mutant);

            var randomScale:Float = 0.500 + Math.random()*0.075;

            mutant.scale.set(randomScale, randomScale);

            mutant.updateHitbox();
        }

        gurazyRunning = new FlxSprite();

        gurazyRunning.frames = Paths.getSparrowAtlas("monsty/backgroundStuff/gurazyRunning");

        gurazyRunning.animation.addByPrefix("running", "Mutant Screen Runner", 24, true);
        gurazyRunning.animation.addByPrefix("unappearfuck", "Mutant Screen Disappear", 24, false);
        gurazyRunning.animation.play("running");
        gurazyRunning.animation.pause();

        gurazyRunning.x = -1500;

        gurazyRunning.scale.set(0.775, 0.775);
    }
    public function makeGurazyRUN()
    {
        if (gurazyCanAppear)
        {
            gurazyRunning.y = 650;

            PlayState.instance.removeObject(gurazyRunning);
            PlayState.instance.addObject(gurazyRunning);

            if (gurazyRunningFromRight)
            {
                gurazyRunningFromRight = false;
                gurazyRunning.animation.resume();
                gurazyRunning.flipX = false;

                FlxTween.tween(gurazyRunning, {x: 2100}, 4, {ease: FlxEase.linear, onComplete: function(tween:FlxTween)
                {
                    gurazyRunning.animation.pause();
                }});
            }
            else if (!gurazyRunningFromRight)
            {
                gurazyRunningFromRight = true;
                gurazyRunning.animation.resume();
                gurazyRunning.flipX = true;

                FlxTween.tween(gurazyRunning, {x: -1600}, 4, {ease: FlxEase.linear, onComplete: function(tween:FlxTween)
                {
                    gurazyRunning.animation.pause();
                }});
            }
        }
    }
    public function disappearGurazy()
    {
        gurazyRunning.y = 650;

        gurazyRunning.animation.resume();

        gurazyRunningFromRight = true;
        gurazyRunning.flipX = true;
        gurazyRunning.visible = true;

        freeTentacle.x = (FlxG.width/2)+300;
        freeTentacle.visible = true;

        FlxTween.tween(gurazyRunning, {x: FlxG.width/2}, 1.25+1, {ease: FlxEase.linear, onComplete: function(tween:FlxTween)
        {
            tween.destroy();

            gurazyRunning.animation.play("unappearfuck", true);

            FlxTween.tween(gurazyRunning, {y: gurazyRunning.y-6000}, 0.5, {ease: FlxEase.sineIn, startDelay: 0.25, onComplete: function(tween:FlxTween)
            {
                tween.destroy();
            }});
            FlxTween.tween(freeTentacle, {y: freeTentacle.y-6000}, 0.5, {ease: FlxEase.sineIn, startDelay: 0.25, onComplete: function(tween:FlxTween)
            {
                tween.destroy();
            }});
        }});

        FlxTween.tween(freeTentacle, {y: gurazyRunning.y-1400}, 0.125, {ease: FlxEase.sineOut, startDelay: 1.125+1, onComplete: function(tween:FlxTween)
        {
            tween.destroy();
        }});
    }
    public function makeGummyVinRun(fast:Bool=false)
    {
        if (!fast)
        {
            mutantsAbleToDance[1] = false;

            aliveMutants[1].animation.play("running", true);

            FlxTween.tween(aliveMutants[1], {x: finalPosX[1]+2000}, 4, {ease: FlxEase.linear, onComplete: function(tween:FlxTween)
            {
                tween.destroy();

                aliveMutants[1].animation.stop();
                aliveMutants[1].visible = false;
            }});
        }
        else
        {
            mutantsAbleToDance[1] = false;

            aliveMutants[1].animation.stop();

            aliveMutants[1].x = 3500;
            aliveMutants[1].visible = false;
        }
    }
    public function manageOffsets()
    {
        finalPosX[0] += 250; //left mutants
        finalPosY[0] += 675;

        finalPosX[1] += 500;
        finalPosY[1] += 500;

        finalPosX[2] += 1250; //right mutants
        finalPosY[2] += 600;

        finalPosX[3] += 800;
        finalPosY[3] += 650;

        aliveMutants[0].x -= 1920; //left mutants
        aliveMutants[0].y += 800;
        aliveMutants[1].x -= 1920;
        aliveMutants[1].y += 500;

        aliveMutants[2].x += 1920; //right mutants
        aliveMutants[2].y += 800;
        aliveMutants[3].x += 1920;
        aliveMutants[3].y += 700;
    }
    private function drawGuiMutants(e:Bool)
    {
        vincitoGUI = new FlxSprite();

        vincitoGUI.frames = Paths.getSparrowAtlas("monsty/backgroundStuff/vincitoHUD");

        var ezFrames12:Array<Int> = [];
        var ezFrames14:Array<Int> = [];
        var ezFrames13:Array<Int> = [];

        for (i in 0...13)
            ezFrames12.push(i);
        for (e in 13...18)
            ezFrames14.push(e);
        for (a in 18...25)
            ezFrames13.push(a);

        vincitoGUI.animation.addByIndices("inOut", "Mutant Screen GUI 1", ezFrames12, "", 24, false);
        vincitoGUI.animation.addByIndices("loopFirst", "Mutant Screen GUI 1", ezFrames14, "", 24, false);
        vincitoGUI.animation.addByIndices("loopSecond", "Mutant Screen GUI 1", ezFrames13, "", 24, false);
        vincitoGUI.animation.addByIndices("inOut-alt", "Mutant Screen GUI 2", ezFrames12, "", 24, false, true);
        vincitoGUI.animation.addByIndices("loopFirst-alt", "Mutant Screen GUI 2", ezFrames14, "", 24, false, true);
        vincitoGUI.animation.addByIndices("loopSecond-alt", "Mutant Screen GUI 2", ezFrames13, "", 24, false, true);
        vincitoGUI.animation.addByIndices("inOut-alt2", "Mutant Screen GUI 3", ezFrames12, "", 24, false, false);
        vincitoGUI.animation.addByIndices("loopFirst-alt2", "Mutant Screen GUI 3", ezFrames14, "", 24, false, false);
        vincitoGUI.animation.addByIndices("loopSecond-alt2", "Mutant Screen GUI 3", ezFrames13, "", 24, false, false);
        vincitoGUI.animation.addByPrefix("disappear", "Mutant Screen GUI 4", 24, false, true);
        
        vincitoGUI.animation.play("inOut");
        vincitoGUI.visible = false;
    }
    public function disappearVinGUI()
    {
        vincitoCanAppear = false;

        vincitoGUI.x = -10;
        vincitoGUI.y = 225;

        new FlxTimer().start(0.175, function (timer:FlxTimer)
		{
            FlxG.sound.play(Paths.sound("vindisappear"), 1, false);
        });

        vincitoGUI.animation.play("disappear", true);

        new FlxTimer().start(1.5416, function (timer:FlxTimer)
        {
            vincitoGUI.visible = false;
        });

        vincitoGUI.visible = true;
    }
    public function appearVinGUI(duration:Float)
    {
        if (vincitoCanAppear && vincitoFree)
        {
            vincitoGUI.y = 315 - (Std.int(Math.random()*25));

            vincitoGUI.visible = true;

            vincitoFree = false;

            switch(vincitoGUI.animation.getByName("inOut"+vincitoGUINext).flipX)
            {
                case false:
                    vincitoGUI.x = 950-(Math.random()*300);
                case true:
                    vincitoGUI.x = 200-(Math.random()*300);
            }

            if (vincitoGUINext == "-alt2")
            {
                vincitoGUI.x += 100;
                vincitoGUI.y -= 100;
            }

            vincitoGUI.animation.play("inOut"+vincitoGUINext, true);

            new FlxTimer().start(0.5, function(timer:FlxTimer)
            {
                vincitoGUI.animation.play("loopFirst"+vincitoGUINext, true);
                vincitoGUI.animation.pause();

                vincitoCanDance = true;

                new FlxTimer().start(duration, function(timer:FlxTimer)
                {
                    vincitoCanDance = false;

                    vincitoGUI.animation.play("inOut"+vincitoGUINext, true, true);

                    new FlxTimer().start(0.5, function(timer:FlxTimer)
                    {
                       vincitoGUI.visible = false;

                       vincitoFree = true;

                        switchVincito();
                    });
                });
            });
        }
    }
    private function switchVincito()
    {
        switch(vincitoGUINext) //change vincitos sprite, now dynamic use
        {
            case "":
                vincitoGUINext = "-alt";
            case "-alt":
                vincitoGUINext = "-alt2";
            case "-alt2":
                vincitoGUINext = "";
        }
    }
    public function appearAllMutants()
    {
        for (i in 0...4)
        {
            aliveMutants[i].x = finalPosX[i];
            aliveMutants[i].y = finalPosY[i];

            aliveMutants[i].animation.play("dancingR");
            aliveMutants[i].animation.finish();

            mutantsAbleToDance[i] = true;
        }
    }
    public function appearRandomMutant()
    {
        var rand:Int = Std.int(Math.random()*4);
        var choosedMutant:FlxSprite = aliveMutants[rand];

        if (!mutantsOnScreen[rand])
        {
            mutantsOnScreen[rand] = true;

            choosedMutant.animation.play("running");

            FlxTween.tween(choosedMutant, {x: finalPosX[rand], y: finalPosY[rand]}, 3.5, {onComplete: function(tween:FlxTween)
            {
                tween.destroy();

                choosedMutant.animation.play("dancingL");
                choosedMutant.animation.pause();

                mutantsAbleToDance[rand] = true;
            }, ease: FlxEase.linear});
        }
        else
        {
            appearRandomMutant();
        }
    }
    public function danceAvailable(str:String="")
    {
        switch(str)
        {
            case "":
                for (i in 0...aliveMutants.length)
                {
                    if (mutantsAbleToDance[i])
                    {
                        if (mutantsDancedLeft[i] == false)
                        {
                            aliveMutants[i].animation.play("dancingL", true);

                            mutantsDancedLeft[i] = true;
                        }
                        else
                        {
                            aliveMutants[i].animation.play("dancingR", true);

                            mutantsDancedLeft[i] = false;
                        }
                    }
                }
            case "vincito":
                if (vincitoCanDance && vincitoCanAppear)
                {
                    if (vincitoDancedLeft)
                    {
                        vincitoDancedLeft = false;

                        vincitoGUI.animation.play("loopFirst"+vincitoGUINext, true);
                    }
                    else if (!vincitoDancedLeft)
                    {
                        vincitoDancedLeft = true;

                        vincitoGUI.animation.play("loopSecond"+vincitoGUINext, true);
                    }
                }
        }
    }
}