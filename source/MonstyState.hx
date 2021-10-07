package;

import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import MusicBeatState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class MonstyState extends MusicBeatState
{
    public var textt:String =
    "
    Monsty let BF and GF to escape to earth, they were the only ones who returned from the massive abductions that happened in the earth during the day.\n\n\n\nThanks for playing, you beautiful human-
    ";
    public var textt2:String =
    "
    Monsty killed BF and GF, they were turned into gummy-creatures, nobody from the massive abductions that happened in the earth during the day returned.\n\n\n\nThanks for giving up, you beautiful human-
    ";
    private var canpressenter:Bool = false;

    var pressentertocontinu:FlxText;

    var updatte:Bool = true;

    public var badendin:Bool = false;

    public override function create ()
    {
        FlxG.sound.pause();

        var swagDialog:FlxText = new FlxText(200, 175, Std.int(FlxG.width-200), "", 28);
        var bg:FlxSprite = new FlxSprite();

        pressentertocontinu = new FlxText(0, FlxG.height-75, "Press ENTER for continue...", 14);
        pressentertocontinu.font = 'Pixel Arial 11 Bold';
        pressentertocontinu.alignment = "center";

        pressentertocontinu.screenCenter(X);

        pressentertocontinu.alpha = 0;

        if (!badendin)
        {
            bg.loadGraphic(Paths.image("monsty/goodEnding"));

            swagDialog.text = textt;

            swagDialog.screenCenter(XY);

            swagDialog.color = FlxColor.WHITE;
        }
        else
        {
            bg.loadGraphic(Paths.image("monsty/badEnding"));

            swagDialog.text = textt2;

            bg.screenCenter(X);
            bg.y = 15;

            swagDialog.screenCenter(XY);

            swagDialog.color = FlxColor.BLACK;
            pressentertocontinu.color = FlxColor.BLACK;

            var redBG:FlxSprite = new FlxSprite(-250, -250);

			redBG.makeGraphic(FlxG.width+500, FlxG.height+500, FlxColor.RED);

			add(redBG);
        }

        swagDialog.font = 'Pixel Arial 11 Bold';
        swagDialog.alignment = "center";

        add(bg);
        add(swagDialog);
        add(pressentertocontinu);

        swagDialog.alpha = 0;

        FlxTween.tween(swagDialog, {alpha: 1}, 1, {ease: FlxEase.linear});

        bg.updateHitbox();

        new FlxTimer().start(6, function (timer:FlxTimer)
        {
            canpressenter = true;

            FlxTween.tween(pressentertocontinu, {alpha: 1}, 0.5, {ease: FlxEase.linear});
        });

        super.create();
    }
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (updatte)
        {
            var pressedEnter:Bool = controls.ACCEPT;

            if (pressedEnter && canpressenter)
            {
                goooo();
            }
        }
    }
    public function goooo()
    {
        FlxG.sound.playMusic(Paths.music('freakyMenu'));
		Conductor.changeBPM(102);
		FlxG.switchState(new StoryMenuState());

        clean();

        updatte = false;
    }
}