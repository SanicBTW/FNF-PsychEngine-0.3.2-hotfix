package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import flixel.input.mouse.FlxMouseEventManager;

using StringTools;

// TO DO: Redo the menu creation system for not being as dumb
class OptionsState extends MusicBeatState
{
	//var options:Array<String> = ['Notes', 'Controls', 'Preferences'];
	//var options:Array<String> = ['Controls', 'Preferences', 'Note Skins', 'Songs Difficulty', 'Miss Note Sound', 'Placeholder', 'Placeholder', 'Placeholder', 'Placeholder'];
	//var options:Array<String> = ['Controls', 'Preferences', 'Songs Difficulty', 'Miss Note Sound'];
	var options:Array<String> = ['Controls', 'Preferences', 'Songs Difficulty', 'Miss Note Sound', 'Keyboard Overlay Position', 'Keyboard Overlay Idle Color', 'Keyboard Overlay Pressing Color'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false, 1, 0.6);
			optionText.screenCenter();
			//optionText.y += (100 * (i - (options.length / 2))) + 50;
			optionText.y += (50 * (i - (options.length / 2))) + 50;
			optionText.x = 50;
			grpOptions.add(optionText);
		}
		changeSelection();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
		changeSelection();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if(FlxG.mouse.wheel != 0)
		{
			if(FlxG.mouse.wheel > 0)
			{
				changeSelection(-1);
			}
			else 
			{
				changeSelection(1);
			}
		}
		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT) {
			for (item in grpOptions.members) {
				item.alpha = 0;
			}

			switch(options[curSelected]) {
				case 'Notes':
					openSubState(new NotesSubstate());

				case 'Controls':
					openSubState(new ControlsSubstate());

				case 'Preferences':
					openSubState(new PreferencesSubstate());

				//case 'Note Skins':
					//openSubState(new NoteSkinsSubstate());

				case 'Songs Difficulty':
					openSubState(new DiffSongsSubstate(false));

				case 'Miss Note Sound':
					openSubState(new MissSoundSubstate());
				
				//new stuff
				case 'Keyboard Overlay Position':
					openSubState(new KBOLYPOSSubState());
				case 'Keyboard Overlay Idle Color':
					openSubState(new KBOLYIDLCOLORSubState());
				case 'Keyboard Overlay Pressing Color':
					openSubState(new KBOLYPRSCOLORSubState());
			}
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.4;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}
	}
}
//taken from the code below lol
class KBOLYPRSCOLORSubState extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	var leText:String;

	var nextAccept:Int = 5;

	var posX = 250;

	//literally just the uhhh
	var pressingcolors:Array<String> = [
		'Gray',
		'White',
		'Black',
		'Blue',
		'Red',
		'Green',
		'Yellow',];
	public function new() {
		super();
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...pressingcolors.length){
			var isCentered:Bool = true;

			var optionText:Alphabet = new Alphabet(0, (10 * i), pressingcolors[i], (!isCentered), false);
			optionText.isMenuItem = true;

			if(isCentered){
				optionText.screenCenter(X);
				//optionText.forceX = optionText.x;
				optionText.forceX = 10;
				//optionText.yAdd = -55;
				optionText.yAdd = -260;
			} else {
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);

		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		//this is really stupid lol
		if (ClientPrefs.keyboardoverlayPRESSINGCOLOR == FlxColor.GRAY){
			leText = "Current Keyboard Overlay Pressing Color: Gray";
		} else if (ClientPrefs.keyboardoverlayPRESSINGCOLOR == FlxColor.WHITE){
			leText = "Current Keyboard Overlay Pressing Color: White";
		} else if (ClientPrefs.keyboardoverlayPRESSINGCOLOR == FlxColor.BLACK){
			leText = "Current Keyboard Overlay Pressing Color: Black";
		} else if (ClientPrefs.keyboardoverlayPRESSINGCOLOR == FlxColor.BLUE){
			leText = "Current Keyboard Overlay Pressing Color: Blue";
		} else if (ClientPrefs.keyboardoverlayPRESSINGCOLOR == FlxColor.RED){
			leText = "Current Keyboard Overlay Pressing Color: Red";
		} else if (ClientPrefs.keyboardoverlayPRESSINGCOLOR == FlxColor.GREEN){
			leText = "Current Keyboard Overlay Pressing Color: Green";
		} else if (ClientPrefs.keyboardoverlayPRESSINGCOLOR == FlxColor.YELLOW){
			leText = "Current Keyboard Overlay Pressing Color: Yellow";
		}

		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		changeSelection();
	}

	override function update(elapsed:Float) {
		if(controls.UI_UP_P){
			changeSelection(-1);
		}
		if(controls.UI_DOWN_P){
			changeSelection(1);
		}

		if (controls.BACK) {
			grpOptions.forEachAlive(function(spr:Alphabet) {
				spr.alpha = 0;
			});
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(controls.ACCEPT && nextAccept <= 0){
			switch(curSelected){
				//this is really stupid too lol
				case 0:
					ClientPrefs.keyboardoverlayPRESSINGCOLOR = FlxColor.GRAY;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 1:
					ClientPrefs.keyboardoverlayPRESSINGCOLOR = FlxColor.WHITE;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 2:
					ClientPrefs.keyboardoverlayPRESSINGCOLOR = FlxColor.BLACK;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 3:
					ClientPrefs.keyboardoverlayPRESSINGCOLOR = FlxColor.BLUE;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 4:
					ClientPrefs.keyboardoverlayPRESSINGCOLOR = FlxColor.RED;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 5:
					ClientPrefs.keyboardoverlayPRESSINGCOLOR = FlxColor.GREEN;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 6:
					ClientPrefs.keyboardoverlayPRESSINGCOLOR = FlxColor.YELLOW;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
			}
		}
		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0){
		curSelected += change;
		if (curSelected < 0){
			curSelected = pressingcolors.length - 1;
		} 
		if (curSelected >= pressingcolors.length){
			curSelected = 0;
		}

		for(i in 0...grpOptions.length){
			var item = grpOptions.members[i];
			item.alpha = 0.4;
			item.scale.set(1, 1);
			if(curSelected == i){
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}

class KBOLYIDLCOLORSubState extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	var leText:String;

	var nextAccept:Int = 5;

	var posX = 250;

	var idlecolors:Array<String> = [
		'Gray',
		'White',
		'Black',
		'Blue',
		'Red',
		'Green',
		'Yellow',];
	public function new() {
		super();
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...idlecolors.length){
			var isCentered:Bool = true;

			var optionText:Alphabet = new Alphabet(0, (10 * i), idlecolors[i], (!isCentered), false);
			optionText.isMenuItem = true;

			if(isCentered){
				optionText.screenCenter(X);
				//optionText.forceX = optionText.x;
				optionText.forceX = 10;
				//optionText.yAdd = -55;
				//this took me 30 min to figure out the position of the thingy :skull:
				optionText.yAdd = -260;
			} else {
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);

		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		//this is really stupid lol
		if (ClientPrefs.keyboardoverlayIDLECOLOR == FlxColor.GRAY){
			leText = "Current Keyboard Overlay Idle Color: Gray";
		} else if (ClientPrefs.keyboardoverlayIDLECOLOR == FlxColor.WHITE){
			leText = "Current Keyboard Overlay Idle Color: White";
		} else if (ClientPrefs.keyboardoverlayIDLECOLOR == FlxColor.BLACK){
			leText = "Current Keyboard Overlay Idle Color: Black";
		} else if (ClientPrefs.keyboardoverlayIDLECOLOR == FlxColor.BLUE){
			leText = "Current Keyboard Overlay Idle Color: Blue";
		} else if (ClientPrefs.keyboardoverlayIDLECOLOR == FlxColor.RED){
			leText = "Current Keyboard Overlay Idle Color: Red";
		} else if (ClientPrefs.keyboardoverlayIDLECOLOR == FlxColor.GREEN){
			leText = "Current Keyboard Overlay Idle Color: Green";
		} else if (ClientPrefs.keyboardoverlayIDLECOLOR == FlxColor.YELLOW){
			leText = "Current Keyboard Overlay Idle Color: Yellow";
		}

		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		changeSelection();
	}

	override function update(elapsed:Float) {
		if(controls.UI_UP_P){
			changeSelection(-1);
		}
		if(controls.UI_DOWN_P){
			changeSelection(1);
		}

		if (controls.BACK) {
			grpOptions.forEachAlive(function(spr:Alphabet) {
				spr.alpha = 0;
			});
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(controls.ACCEPT && nextAccept <= 0){
			switch(curSelected){
				//this is really stupid too lol
				case 0:
					ClientPrefs.keyboardoverlayIDLECOLOR = FlxColor.GRAY;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 1:
					ClientPrefs.keyboardoverlayIDLECOLOR = FlxColor.WHITE;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 2:
					ClientPrefs.keyboardoverlayIDLECOLOR = FlxColor.BLACK;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 3:
					ClientPrefs.keyboardoverlayIDLECOLOR = FlxColor.BLUE;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 4:
					ClientPrefs.keyboardoverlayIDLECOLOR = FlxColor.RED;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 5:
					ClientPrefs.keyboardoverlayIDLECOLOR = FlxColor.GREEN;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 6:
					ClientPrefs.keyboardoverlayIDLECOLOR = FlxColor.YELLOW;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
			}
		}
		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0){
		curSelected += change;
		if (curSelected < 0){
			curSelected = idlecolors.length - 1;
		} 
		if (curSelected >= idlecolors.length){
			curSelected = 0;
		}

		for(i in 0...grpOptions.length){
			var item = grpOptions.members[i];
			item.alpha = 0.4;
			item.scale.set(1, 1);
			if(curSelected == i){
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}

class KBOLYPOSSubState extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	var leText:String;

	var nextAccept:Int = 5;

	var posX = 250;

	var keybooverpos:Array<String> = [
		'Left',
		'Right'];
	public function new() {
		super();
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...keybooverpos.length){
			var isCentered:Bool = true;

			var optionText:Alphabet = new Alphabet(0, (10 * i), keybooverpos[i], (!isCentered), false);
			optionText.isMenuItem = true;

			if(isCentered){
				optionText.screenCenter(X);
				//optionText.forceX = optionText.x;
				optionText.forceX = 10;
				optionText.yAdd = -55;
			} else {
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);

		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		leText = "Current Keyboard Overlay Position: " + ClientPrefs.keyboardoverlayPOSITION;
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		changeSelection();
	}

	override function update(elapsed:Float) {
		if(controls.UI_UP_P){
			changeSelection(-1);
		}
		if(controls.UI_DOWN_P){
			changeSelection(1);
		}

		if (controls.BACK) {
			grpOptions.forEachAlive(function(spr:Alphabet) {
				spr.alpha = 0;
			});
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(controls.ACCEPT && nextAccept <= 0){
			switch(curSelected){
				case 0:
					ClientPrefs.keyboardoverlayPOSITION = "Left";
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 1:
					ClientPrefs.keyboardoverlayPOSITION = "Right";
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
			}
		}
		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0){
		curSelected += change;
		if (curSelected < 0){
			curSelected = keybooverpos.length - 1;
		} 
		if (curSelected >= keybooverpos.length){
			curSelected = 0;
		}

		for(i in 0...grpOptions.length){
			var item = grpOptions.members[i];
			item.alpha = 0.4;
			item.scale.set(1, 1);
			if(curSelected == i){
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}

class MissSoundSubstate extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	var leText:String;

	var nextAccept:Int = 5;

	var posX = 250;

	var availmisssound:Array<String> = [
		'Default Miss Note Sound',
		'Touhou Miss Note Sound'];
	public function new() {
		super();
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...availmisssound.length){
			var isCentered:Bool = true;

			var optionText:Alphabet = new Alphabet(0, (10 * i), availmisssound[i], (!isCentered), false);
			optionText.isMenuItem = true;

			if(isCentered){
				optionText.screenCenter(X);
				//optionText.forceX = optionText.x;
				optionText.forceX = 10;
				optionText.yAdd = -55;
			} else {
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);

		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		if (ClientPrefs.curmisssound == "missnotetouhou"){
			leText = "Current miss sound: Touhou Miss Note Sound";
		} else if (ClientPrefs.curmisssound == "missnote"){
			leText = "Current miss sound: Default Miss Note Sound";
		}
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		changeSelection();
	}

	override function update(elapsed:Float) {
		if(controls.UI_UP_P){
			changeSelection(-1);
		}
		if(controls.UI_DOWN_P){
			changeSelection(1);
		}

		if (controls.BACK) {
			grpOptions.forEachAlive(function(spr:Alphabet) {
				spr.alpha = 0;
			});
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(controls.ACCEPT && nextAccept <= 0){
			switch(curSelected){
				case 0:
					ClientPrefs.curmisssound = "missnote";
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 1:
					ClientPrefs.curmisssound = "missnotetouhou";
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
			}
		}
		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0){
		curSelected += change;
		if (curSelected < 0){
			curSelected = availmisssound.length - 1;
		} 
		if (curSelected >= availmisssound.length){
			curSelected = 0;
		}

		for(i in 0...grpOptions.length){
			var item = grpOptions.members[i];
			item.alpha = 0.4;
			item.scale.set(1, 1);
			if(curSelected == i){
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}

class DiffSongsSubstate extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var infreeplay:Bool;
	var leText:String;
	var optionText:Alphabet; //tryin to add more funky clicky stuff
	private static var menuBG:FlxSprite;

	var nextAccept:Int = 5;

	var posX = 250;

	var availdiff:Array<String> = [
		'Hard',
		'Easy'];
	public function new(infreeplay:Bool) {
		super();
		this.infreeplay = infreeplay;

		if(infreeplay) {
			menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
			menuBG.color = 0xFFea71fd;
			menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
			menuBG.updateHitbox();
			menuBG.screenCenter();
			menuBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(menuBG);
		}

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);
		
		for (i in 0...availdiff.length){
			var isCentered:Bool = true;

			optionText = new Alphabet(0, (10 * i), availdiff[i], (!isCentered), false);
			optionText.isMenuItem = true;

			if(isCentered){
				optionText.screenCenter(X);
				//optionText.forceX = optionText.x;
				optionText.forceX = 10;
				optionText.yAdd = -55;
			} else {
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);

		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		if (ClientPrefs.cursongdif == "Hard"){
			leText = "Current difficulty: Hard";
		} else if (ClientPrefs.cursongdif == "Easy"){
			leText = "Current difficulty: Easy";
		}
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		changeSelection();
	}

	override function update(elapsed:Float) {
		if(controls.UI_UP_P){
			changeSelection(-1);
		}
		if(controls.UI_DOWN_P){
			changeSelection(1);
		}

		if (controls.BACK) {
			grpOptions.forEachAlive(function(spr:Alphabet) {
				spr.alpha = 0;
			});
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(controls.ACCEPT && nextAccept <= 0){
			switch(curSelected){
				case 0:
					ClientPrefs.cursongdif = "Hard";
					FlxG.sound.play(Paths.sound('cancelMenu'));
					if(infreeplay){
						FreeplayState.RestartFreeplay();
						FlxTween.tween(FlxG.sound, {volume: 1.0}, 0.5);
					}
					close();
				case 1:
					ClientPrefs.cursongdif = "Easy";
					FlxG.sound.play(Paths.sound('cancelMenu'));
					if(infreeplay){
						FreeplayState.RestartFreeplay();
						FlxTween.tween(FlxG.sound, {volume: 1.0}, 0.5);
					}
					close();
			}
		}
		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0){
		curSelected += change;
		if (curSelected < 0){
			curSelected = availdiff.length - 1;
		} 
		if (curSelected >= availdiff.length){
			curSelected = 0;
		}

		for(i in 0...grpOptions.length){
			var item = grpOptions.members[i];
			item.alpha = 0.4;
			item.scale.set(1, 1);
			if(curSelected == i){
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}

class NoteSkinsSubstate extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	var leText:String;

	var nextAccept:Int = 5;

	var posX = 250;

	var noteskins:Array<String> = [
		'Default',
		'Circle Notes',
		'StepMania Animated Notes',
		'Rectangle Notes aka Bar Notes'];
	public function new() {
		super();
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...noteskins.length){
			var isCentered:Bool = true;

			var optionText:Alphabet = new Alphabet(0, (10 * i), noteskins[i], (!isCentered), false);
			optionText.isMenuItem = true;

			if(isCentered){
				optionText.screenCenter(X);
				//optionText.forceX = optionText.x;
				optionText.forceX = 10;
				optionText.yAdd = -100;
			} else {
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);
		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		if (ClientPrefs.noteskin == "NOTECIRCLE_assets") leText = "Currently selected: Circle Notes";
		else if (ClientPrefs.noteskin == "NOTE_assets") leText = "Currently selected: Default";
		else if (ClientPrefs.noteskin == "NOTESM_assets") leText = "Currently selected: StepMania Animated Notes";
		else if (ClientPrefs.noteskin == "NOTERECTANGLE_assets") leText = "Currently selected: Rectangle Notes aka Bar Notes";
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		changeSelection();
	}

	override function update(elapsed:Float) {
		if(controls.UI_UP_P){
			changeSelection(-1);
		}
		if(controls.UI_DOWN_P){
			changeSelection(1);
		}

		if (controls.BACK) {
			grpOptions.forEachAlive(function(spr:Alphabet) {
				spr.alpha = 0;
			});
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(controls.ACCEPT && nextAccept <= 0){
			switch(curSelected){
				case 0:
					ClientPrefs.noteskin = 'NOTE_assets';
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 1:
					ClientPrefs.noteskin = "NOTECIRCLE_assets";
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 2:
					ClientPrefs.noteskin = "NOTESM_assets";
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
				case 3:
					ClientPrefs.noteskin = "NOTERECTANGLE_assets";
					FlxG.sound.play(Paths.sound('cancelMenu'));
					close();
			}
		}
		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0){

		curSelected += change;
		if (curSelected < 0){
			curSelected = noteskins.length - 1;
		} 
		if (curSelected >= noteskins.length){
			curSelected = 0;
		}

		for(i in 0...grpOptions.length){
			var item = grpOptions.members[i];
			item.alpha = 0.4;
			item.scale.set(1, 1);
			if(curSelected == i){
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
				trace("Curselected int: " + i + " Curitem:" + item);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}

class NotesSubstate extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	private static var typeSelected:Int = 0;
	private var grpNumbers:FlxTypedGroup<Alphabet>;
	private var grpNotes:FlxTypedGroup<FlxSprite>;
	private var shaderArray:Array<ColorSwap> = [];
	var curValue:Float = 0;
	var holdTime:Float = 0;
	var hsvText:Alphabet;
	var nextAccept:Int = 5;

	var posX = 250;
	public function new() {
		super();

		grpNotes = new FlxTypedGroup<FlxSprite>();
		add(grpNotes);
		grpNumbers = new FlxTypedGroup<Alphabet>();
		add(grpNumbers);

		for (i in 0...ClientPrefs.arrowHSV.length) {
			var yPos:Float = (165 * i) + 35;
			for (j in 0...3) {
				var optionText:Alphabet = new Alphabet(0, yPos, Std.string(ClientPrefs.arrowHSV[i][j]));
				optionText.x = posX + (225 * j) + 100 - ((optionText.lettersArray.length * 90) / 2);
				grpNumbers.add(optionText);
			}

			var note:FlxSprite = new FlxSprite(posX - 70, yPos);
			note.frames = Paths.getSparrowAtlas(ClientPrefs.noteskin);
			switch(i) {
				case 0:
					note.animation.addByPrefix('idle', 'purple0');
				case 1:
					note.animation.addByPrefix('idle', 'blue0');
				case 2:
					note.animation.addByPrefix('idle', 'green0');
				case 3:
					note.animation.addByPrefix('idle', 'red0');
			}
			note.animation.play('idle');
			note.antialiasing = ClientPrefs.globalAntialiasing;
			grpNotes.add(note);

			var newShader:ColorSwap = new ColorSwap();
			note.shader = newShader.shader;
			newShader.hue = ClientPrefs.arrowHSV[i][0] / 360;
			newShader.saturation = ClientPrefs.arrowHSV[i][1] / 100;
			newShader.brightness = ClientPrefs.arrowHSV[i][2] / 100;
			shaderArray.push(newShader);
		}
		hsvText = new Alphabet(0, 0, "Hue    Saturation  Brightness", false, false, 0, 0.65);
		add(hsvText);
		changeSelection();
	}

	var changingNote:Bool = false;
	var hsvTextOffsets:Array<Float> = [240, 90];
	override function update(elapsed:Float) {
		if(changingNote) {
			if(holdTime < 0.5) {
				if(controls.UI_LEFT_P) {
					updateValue(-1);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				} else if(controls.UI_RIGHT_P) {
					updateValue(1);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				} else if(controls.RESET) {
					resetValue(curSelected, typeSelected);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
				if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					holdTime = 0;
				} else if(controls.UI_LEFT || controls.UI_RIGHT) {
					holdTime += elapsed;
				}
			} else {
				var add:Float = 90;
				switch(typeSelected) {
					case 1 | 2: add = 50;
				}
				if(controls.UI_LEFT) {
					updateValue(elapsed * -add);
				} else if(controls.UI_RIGHT) {
					updateValue(elapsed * add);
				}
				if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					holdTime = 0;
				}
			}
		} else {
			if (controls.UI_UP_P) {
				changeSelection(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_LEFT_P) {
				changeType(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_RIGHT_P) {
				changeType(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if(controls.RESET) {
				for (i in 0...3) {
					resetValue(curSelected, i);
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.ACCEPT && nextAccept <= 0) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changingNote = true;
				holdTime = 0;
				for (i in 0...grpNumbers.length) {
					var item = grpNumbers.members[i];
					item.alpha = 0;
					if ((curSelected * 3) + typeSelected == i) {
						item.alpha = 1;
					}
				}
				for (i in 0...grpNotes.length) {
					var item = grpNotes.members[i];
					item.alpha = 0;
					if (curSelected == i) {
						item.alpha = 1;
					}
				}
				super.update(elapsed);
				return;
			}
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
		for (i in 0...grpNotes.length) {
			var item = grpNotes.members[i];
			var intendedPos:Float = posX - 70;
			if (curSelected == i) {
				item.x = FlxMath.lerp(item.x, intendedPos + 100, lerpVal);
			} else {
				item.x = FlxMath.lerp(item.x, intendedPos, lerpVal);
			}
			for (j in 0...3) {
				var item2 = grpNumbers.members[(i * 3) + j];
				item2.x = item.x + 265 + (225 * (j % 3)) - (30 * item2.lettersArray.length) / 2;
				if(ClientPrefs.arrowHSV[i][j] < 0) {
					item2.x -= 20;
				}
			}

			if(curSelected == i) {
				hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}

		if (controls.BACK || (changingNote && controls.ACCEPT)) {
			changeSelection();
			if(!changingNote) {
				grpNumbers.forEachAlive(function(spr:Alphabet) {
					spr.alpha = 0;
				});
				grpNotes.forEachAlive(function(spr:FlxSprite) {
					spr.alpha = 0;
				});
				close();
			}
			changingNote = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = ClientPrefs.arrowHSV.length-1;
		if (curSelected >= ClientPrefs.arrowHSV.length)
			curSelected = 0;

		curValue = ClientPrefs.arrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i) {
				item.alpha = 1;
			}
		}
		for (i in 0...grpNotes.length) {
			var item = grpNotes.members[i];
			item.alpha = 0.6;
			item.scale.set(1, 1);
			if (curSelected == i) {
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
				hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeType(change:Int = 0) {
		typeSelected += change;
		if (typeSelected < 0)
			typeSelected = 2;
		if (typeSelected > 2)
			typeSelected = 0;

		curValue = ClientPrefs.arrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i) {
				item.alpha = 1;
			}
		}
	}

	function resetValue(selected:Int, type:Int) {
		curValue = 0;
		ClientPrefs.arrowHSV[selected][type] = 0;
		switch(type) {
			case 0: shaderArray[selected].hue = 0;
			case 1: shaderArray[selected].saturation = 0;
			case 2: shaderArray[selected].brightness = 0;
		}
		grpNumbers.members[(selected * 3) + type].changeText('0');
	}
	function updateValue(change:Float = 0) {
		curValue += change;
		var roundedValue:Int = Math.round(curValue);
		var max:Float = 180;
		switch(typeSelected) {
			case 1 | 2: max = 100;
		}

		if(roundedValue < -max) {
			curValue = -max;
		} else if(roundedValue > max) {
			curValue = max;
		}
		roundedValue = Math.round(curValue);
		ClientPrefs.arrowHSV[curSelected][typeSelected] = roundedValue;

		switch(typeSelected) {
			case 0: shaderArray[curSelected].hue = roundedValue / 360;
			case 1: shaderArray[curSelected].saturation = roundedValue / 100;
			case 2: shaderArray[curSelected].brightness = roundedValue / 100;
		}
		grpNumbers.members[(curSelected * 3) + typeSelected].changeText(Std.string(roundedValue));
	}
}

class ControlsSubstate extends MusicBeatSubstate {
	private static var curSelected:Int = 1;
	private static var curAlt:Bool = false;

	private static var defaultKey:String = 'Reset to default keys';

	var optionShit:Array<String> = [
		'Notes',
		ClientPrefs.keyBinds[0][1],
		ClientPrefs.keyBinds[1][1],
		ClientPrefs.keyBinds[2][1],
		ClientPrefs.keyBinds[3][1],
		'',
		'UI',
		ClientPrefs.keyBinds[4][1],
		ClientPrefs.keyBinds[5][1],
		ClientPrefs.keyBinds[6][1],
		ClientPrefs.keyBinds[7][1],
		'',
		ClientPrefs.keyBinds[8][1],
		ClientPrefs.keyBinds[9][1],
		ClientPrefs.keyBinds[10][1],
		ClientPrefs.keyBinds[11][1],
		'',
		defaultKey];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var grpInputs:Array<AttachedText> = [];
	private var controlArray:Array<FlxKey> = [];
	var rebindingKey:Int = -1;
	var nextAccept:Int = 5;

	public function new() {
		super();
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		controlArray = ClientPrefs.lastControls.copy();
		for (i in 0...optionShit.length) {
			var isCentered:Bool = false;
			var isDefaultKey:Bool = (optionShit[i] == defaultKey);
			if(unselectableCheck(i, true)) {
				isCentered = true;
			}

			var optionText:Alphabet = new Alphabet(0, (10 * i), optionShit[i], (!isCentered || isDefaultKey), false);
			optionText.isMenuItem = true;
			if(isCentered) {
				optionText.screenCenter(X);
				//optionText.forceX = optionText.x;
				optionText.forceX = 10;
				optionText.yAdd = -55;
			} else {
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(!isCentered) {
				addBindTexts(optionText);
			}
		}
		changeSelection();
	}

	var leaving:Bool = false;
	var bindingTime:Float = 0;
	override function update(elapsed:Float) {
		if(rebindingKey < 0) {
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
				changeAlt();
			}

			if (controls.BACK) {
				ClientPrefs.reloadControls(controlArray);
				grpOptions.forEachAlive(function(spr:Alphabet) {
					spr.alpha = 0;
				});
				for (i in 0...grpInputs.length) {
					var spr:AttachedText = grpInputs[i];
					if(spr != null) {
						spr.alpha = 0;
					}
				}
				close();
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}

			if(controls.ACCEPT && nextAccept <= 0) {
				if(optionShit[curSelected] == defaultKey) {
					controlArray = ClientPrefs.defaultKeys.copy();
					reloadKeys();
					changeSelection();
					FlxG.sound.play(Paths.sound('confirmMenu'));
				} else {
					bindingTime = 0;
					rebindingKey = getSelectedKey();
					if(rebindingKey > -1) {
						grpInputs[rebindingKey].visible = false;
						FlxG.sound.play(Paths.sound('scrollMenu'));
					} else {
						FlxG.log.warn('Error! No input found/badly configured');
						FlxG.sound.play(Paths.sound('cancelMenu'));
					}
				}
			}
		} else {
			var keyPressed:Int = FlxG.keys.firstJustPressed();
			if (keyPressed > -1) {
				controlArray[rebindingKey] = keyPressed;
				var opposite:Int = rebindingKey + (rebindingKey % 2 == 1 ? -1 : 1);
				trace('Rebinded key with ID: ' + rebindingKey + ', Opposite is: ' + opposite);
				if(controlArray[opposite] == controlArray[rebindingKey]) {
					controlArray[opposite] = NONE;
				}

				reloadKeys();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				rebindingKey = -1;
			}

			bindingTime += elapsed;
			if(bindingTime > 5) {
				grpInputs[rebindingKey].visible = true;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				rebindingKey = -1;
				bindingTime = 0;
			}
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}
	
	function changeSelection(change:Int = 0) {
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = optionShit.length - 1;
			if (curSelected >= optionShit.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					for (i in 0...grpInputs.length) {
						if(grpInputs[i].sprTracker == item && grpInputs[i].isAlt == curAlt) {
							grpInputs[i].alpha = 1;
						}
					}
				}
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeAlt() {
		curAlt = !curAlt;
		for (i in 0...grpInputs.length) {
			if(grpInputs[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputs[i].alpha = 0.6;
				if(grpInputs[i].isAlt == curAlt) {
					grpInputs[i].alpha = 1;
				}
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	private function unselectableCheck(num:Int, ?checkDefaultKey:Bool = false):Bool {
		if(optionShit[num] == defaultKey) {
			return checkDefaultKey;
		}

		for (i in 0...ClientPrefs.keyBinds.length) {
			if(ClientPrefs.keyBinds[i][1] == optionShit[num]) {
				return false;
			}
		}
		return true;
	}

	private function getSelectedKey():Int {
		var altValue:Int = (curAlt ? 1 : 0);
		for (i in 0...ClientPrefs.keyBinds.length) {
			if(ClientPrefs.keyBinds[i][1] == optionShit[curSelected]) {
				return i*2 + altValue;
			}
		}
		return -1;
	}

	private function addBindTexts(optionText:Alphabet) {
		var text1 = new AttachedText(InputFormatter.getKeyName(controlArray[grpInputs.length]), 400, -55);
		text1.setPosition(optionText.x + 400, optionText.y - 55);
		text1.sprTracker = optionText;
		grpInputs.push(text1);
		add(text1);

		var text2 = new AttachedText(InputFormatter.getKeyName(controlArray[grpInputs.length]), 650, -55);
		text2.setPosition(optionText.x + 650, optionText.y - 55);
		text2.sprTracker = optionText;
		text2.isAlt = true;
		grpInputs.push(text2);
		add(text2);
	}

	function reloadKeys() {
		while(grpInputs.length > 0) {
			var item:AttachedText = grpInputs[0];
			grpInputs.remove(item);
			remove(item);
		}

		for (i in 0...grpOptions.length) {
			if(!unselectableCheck(i, true)) {
				addBindTexts(grpOptions.members[i]);
			}
		}


		var bullShit:Int = 0;
		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					for (i in 0...grpInputs.length) {
						if(grpInputs[i].sprTracker == item && grpInputs[i].isAlt == curAlt) {
							grpInputs[i].alpha = 1;
						}
					}
				}
			}
		}
	}
}

class PreferencesSubstate extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	static var unselectableOptions:Array<String> = [
		'Graphics',
		'Gameplay',
		'Songs',
	];
	static var noCheckbox:Array<String> = [
		'Framerate',
		'Note Delay',
		'Note Hit Volume',
		'Keyboard Overlay Alpha'
	];

	static var options:Array<String> = [
		'Graphics',
		'Low Quality',
		'Anti-Aliasing',
		//'Persistent Cached Data',
		//'Vertical Health Bar',
		'Song Backgrounds',
		//'Fullscreen',
		'Strum Background',
		#if !html5
		'Framerate', //Apparently 120FPS isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		#end
		'Gameplay',
		'Downscroll',
		'Middlescroll',
		'Note Hit Sound',
		'Note Hit Volume',
		'Show Keyboard Overlay',
		'Keyboard Overlay Alpha',
		'Ghost Tapping',
		'Note Delay',
		'Note Splashes',
		'Hide HUD',
		'Hide Song Length',
		//'Flashing Lights',
		'Camera Zooms',
		#if !mobile
		'FPS Counter',
		#end
		'Songs',
		'Pause Ebola Timer',
		'One Miss Chirumiru',
		'One Miss Defeat',
	];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var checkboxArray:Array<CheckboxThingie> = [];
	private var checkboxNumber:Array<Int> = [];
	private var grpTexts:FlxTypedGroup<AttachedText>;
	private var textNumber:Array<Int> = [];

	private var characterLayer:FlxTypedGroup<Character>;
	private var showCharacter:Character = null;
	private var descText:FlxText;

	public function new()
	{
		super();
		characterLayer = new FlxTypedGroup<Character>();
		add(characterLayer);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedText>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var isCentered:Bool = unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, options[i], false, false);
			optionText.isMenuItem = true;
			if(isCentered) {
				optionText.screenCenter(X);
				//optionText.forceX = optionText.x;
				optionText.forceX = 10;
			} else {
				optionText.x += 300;
				optionText.forceX = 300;
			}
			optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(!isCentered) {
				var useCheckbox:Bool = true;
				for (j in 0...noCheckbox.length) {
					if(options[i] == noCheckbox[j]) {
						useCheckbox = false;
						break;
					}
				}

				if(useCheckbox) {
					var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, false);
					checkbox.sprTracker = optionText;
					checkboxArray.push(checkbox);
					checkboxNumber.push(i);
					add(checkbox);
				} else {
					var valueText:AttachedText = new AttachedText('0', optionText.width + 80);
					valueText.sprTracker = optionText;
					grpTexts.add(valueText);
					textNumber.push(i);
				}
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		for (i in 0...options.length) {
			if(!unselectableCheck(i)) {
				curSelected = i;
				break;
			}
		}
		changeSelection();
		reloadValues();
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK) {
			grpOptions.forEachAlive(function(spr:Alphabet) {
				spr.alpha = 0;
			});
			grpTexts.forEachAlive(function(spr:AttachedText) {
				spr.alpha = 0;
			});
			for (i in 0...checkboxArray.length) {
				var spr:CheckboxThingie = checkboxArray[i];
				if(spr != null) {
					spr.alpha = 0;
				}
			}
			if(showCharacter != null) {
				showCharacter.alpha = 0;
			}
			descText.alpha = 0;
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		var usesCheckbox = true;
		for (i in 0...noCheckbox.length) {
			if(options[curSelected] == noCheckbox[i]) {
				usesCheckbox = false;
				break;
			}
		}

		if(usesCheckbox) {
			if(controls.ACCEPT && nextAccept <= 0) {
				switch(options[curSelected]) {
					case 'FPS Counter':
						ClientPrefs.showFPS = !ClientPrefs.showFPS;
						if(Main.fpsVar != null)
							Main.fpsVar.visible = ClientPrefs.showFPS;

					case 'Low Quality':
						ClientPrefs.lowQuality = !ClientPrefs.lowQuality;

					case 'Anti-Aliasing':
						ClientPrefs.globalAntialiasing = !ClientPrefs.globalAntialiasing;
						showCharacter.antialiasing = ClientPrefs.globalAntialiasing;
						for (item in grpOptions) {
							item.antialiasing = ClientPrefs.globalAntialiasing;
						}
						for (i in 0...checkboxArray.length) {
							var spr:CheckboxThingie = checkboxArray[i];
							if(spr != null) {
								spr.antialiasing = ClientPrefs.globalAntialiasing;
							}
						}
						OptionsState.menuBG.antialiasing = ClientPrefs.globalAntialiasing;

					case 'Note Splashes':
						ClientPrefs.noteSplashes = !ClientPrefs.noteSplashes;

					case 'Flashing Lights':
						ClientPrefs.flashing = !ClientPrefs.flashing;

					case 'Violence':
						ClientPrefs.violence = !ClientPrefs.violence;

					case 'Swearing':
						ClientPrefs.cursing = !ClientPrefs.cursing;

					case 'Downscroll':
						ClientPrefs.downScroll = !ClientPrefs.downScroll;

					case 'Middlescroll':
						ClientPrefs.middleScroll = !ClientPrefs.middleScroll;

					case 'Ghost Tapping':
						ClientPrefs.ghostTapping = !ClientPrefs.ghostTapping;

					case 'Camera Zooms':
						ClientPrefs.camZooms = !ClientPrefs.camZooms;

					//case 'Hide HUD':
						//ClientPrefs.hideHud = !ClientPrefs.hideHud;

					case 'Persistent Cached Data':
						ClientPrefs.imagesPersist = !ClientPrefs.imagesPersist;
						FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;

					//case 'Hide Song Length':
						//ClientPrefs.hideTime = !ClientPrefs.hideTime;


					//case 'Vertical Health Bar':
						//ClientPrefs.verthealthbar = !ClientPrefs.verthealthbar;

					case 'Song Backgrounds':
						ClientPrefs.songbackgrounds = !ClientPrefs.songbackgrounds;
					case 'Strum Background':
						ClientPrefs.strumbackground = !ClientPrefs.strumbackground;
					
					/*
					case 'Fullscreen':
						ClientPrefs.fullscreenxd = !ClientPrefs.fullscreenxd;
						FlxG.fullscreen = ClientPrefs.fullscreenxd;
						if(FlxG.fullscreen){
							ClientPrefs.fullscreenxd = true;
						} else {
							ClientPrefs.fullscreenxd = false;
						}*/

					case 'Note Hit Sound':
						ClientPrefs.notehitsound = !ClientPrefs.notehitsound;

					case 'Pause Ebola Timer':
						ClientPrefs.nerfebolatimer = !ClientPrefs.nerfebolatimer;

					case 'One Miss Chirumiru':
						ClientPrefs.onemisschirumiru = !ClientPrefs.onemisschirumiru;

					case 'One Miss Defeat':
						ClientPrefs.onemissdefeat = !ClientPrefs.onemissdefeat;

					case 'Show Keyboard Overlay':
						ClientPrefs.showkeyboardoverlay = !ClientPrefs.showkeyboardoverlay;
					
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
				reloadValues();
			}
		} else {
			if(controls.UI_LEFT || controls.UI_RIGHT) {
				var add:Int = controls.UI_LEFT ? -1 : 1;
				if(holdTime > 0.5 || controls.UI_LEFT_P || controls.UI_RIGHT_P)
				switch(options[curSelected]) {
					case 'Framerate':
						ClientPrefs.framerate += add;
						if(ClientPrefs.framerate < 60) ClientPrefs.framerate = 60;
						else if(ClientPrefs.framerate > 240) ClientPrefs.framerate = 240;

						if(ClientPrefs.framerate > FlxG.drawFramerate) {
							FlxG.updateFramerate = ClientPrefs.framerate;
							FlxG.drawFramerate = ClientPrefs.framerate;
						} else {
							FlxG.drawFramerate = ClientPrefs.framerate;
							FlxG.updateFramerate = ClientPrefs.framerate;
						}
					case 'Note Delay':
						var mult:Int = 1;
						if(holdTime > 1.5) { //Double speed after 1.5 seconds holding
							mult = 2;
						}
						ClientPrefs.noteOffset += add * mult;
						if(ClientPrefs.noteOffset < 0) ClientPrefs.noteOffset = 0;
						else if(ClientPrefs.noteOffset > 500) ClientPrefs.noteOffset = 500;

					case 'Note Hit Volume':
						var custmadd:Float = controls.UI_LEFT ? -0.1 : 0.1;
						ClientPrefs.notehitvolume += custmadd;
						if(ClientPrefs.notehitvolume < 0.1) ClientPrefs.notehitvolume = 0.1;
						else if (ClientPrefs.notehitvolume > 1) ClientPrefs.notehitvolume = 1;
					case 'Keyboard Overlay Alpha':
						var custmadd:Float = controls.UI_LEFT ? -0.1 : 0.1;
						ClientPrefs.keyboardoverlayALPHA += custmadd;
						if(ClientPrefs.keyboardoverlayALPHA < 0) ClientPrefs.keyboardoverlayALPHA = 0;
						else if(ClientPrefs.keyboardoverlayALPHA > 1) ClientPrefs.keyboardoverlayALPHA = 1;
				}
				reloadValues();

				if(holdTime <= 0) FlxG.sound.play(Paths.sound('scrollMenu'));
				holdTime += elapsed;
			} else {
				holdTime = 0;
			}
		}

		if(showCharacter != null && showCharacter.animation.curAnim.finished) {
			showCharacter.dance();
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}
	
	function changeSelection(change:Int = 0)
	{
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = options.length - 1;
			if (curSelected >= options.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var daText:String = '';
		switch(options[curSelected]) {
			case 'Framerate':
				daText = "Pretty self explanatory, isn't it?\nDefault value is 60.";
			case 'Note Delay':
				daText = "Changes how late a note is spawned.\nUseful for preventing audio lag from wireless earphones.";
			case 'OSU! Back Alpha':
				daText = "The alpha value of the OSU! Backgrounds";
			case 'FPS Counter':
				daText = "If unchecked, hides FPS Counter.";
			case 'Low Quality':
				daText = "If checked, disables some background details,\ndecreases loading times and improves performance.";
			case 'Persistent Cached Data':
				daText = "If checked, images loaded will stay in memory\nuntil the game is closed, this increases memory usage,\nbut basically makes reloading times instant.";
			case 'Vertical Health Bar':
				daText = "The name says it all, vertical health bar";
			case 'Song Backgrounds':
				daText = "If unchecked no backgrounds or players will be displayed\nOnly song, strum line and health bar\nDOESN'T WORK ATM";
			case 'Strum Background':
				daText = "If checked, a grey smth background will appear under the player strums\nto give it more an osu! look i guess";
			case 'Anti-Aliasing':
				daText = "If unchecked, disables anti-aliasing, increases performance\nat the cost of the graphics not looking as smooth.";
			case 'Downscroll':
				daText = "If checked, notes go Down instead of Up, simple enough.";
			case 'Middlescroll':
				daText = "If checked, hides Opponent's notes and your notes get centered.\nForced in some songs";
			case 'Ghost Tapping':
				daText = "If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.";
			case 'Swearing':
				daText = "If unchecked, your mom won't be angry at you.";
			case 'Violence':
				daText = "If unchecked, you won't get disgusted as frequently.";
			case 'Note Splashes':
				daText = "If unchecked, hitting \"Sick!\" notes won't show particles.";
			case 'Flashing Lights':
				daText = "Uncheck this if you're sensitive to flashing lights!";
			case 'Camera Zooms':
				daText = "If unchecked, the camera won't zoom in on a beat hit.";
			//case 'Hide HUD':
				//daText = "If checked, hides most HUD elements.";
			//case 'Hide Song Length':
				//daText = "If checked, the bar showing how much time is left\nwill be hidden.";
			case 'Fullscreen':
				daText = "The name says it all, fullscreen xd";
			case 'Note Hit Sound':
				daText = "Plays a hit sound when hitting a note";
			case 'Note Hit Volume':
				daText = "Literally the note hit volume";
			case 'Pause Ebola Timer':
				daText = "It pauses the ebola timer from infinigger when pausing the game";
			case 'One Miss Chirumiru':
				daText = "Literally what the name says";
			case 'One Miss Defeat':
				daText = "Literally what the name says";
			case 'Show Keyboard Overlay':
				daText = "Shows a lil keyboard overlay at the right corner of the screen\ngonna add an option to change the pos of it";
			case 'Keyboard Overlay Alpha':
				daText = "Changes the alpha value of the keyboard overlay";
		}
		descText.text = daText;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}

				for (j in 0...checkboxArray.length) {
					var tracker:FlxSprite = checkboxArray[j].sprTracker;
					if(tracker == item) {
						checkboxArray[j].alpha = item.alpha;
						break;
					}
				}
			}
		}
		for (i in 0...grpTexts.members.length) {
			var text:AttachedText = grpTexts.members[i];
			if(text != null) {
				text.alpha = 0.6;
				if(textNumber[i] == curSelected) {
					text.alpha = 1;
				}
			}
		}

		if(options[curSelected] == 'Anti-Aliasing') {
			if(showCharacter == null) {
				showCharacter = new Character(840, 170, 'bf', true);
				showCharacter.setGraphicSize(Std.int(showCharacter.width * 0.8));
				showCharacter.updateHitbox();
				showCharacter.dance();
				characterLayer.add(showCharacter);
			}
		} else if(showCharacter != null) {
			characterLayer.clear();
			showCharacter = null;
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function reloadValues() {
		for (i in 0...checkboxArray.length) {
			var checkbox:CheckboxThingie = checkboxArray[i];
			if(checkbox != null) {
				var daValue:Bool = false;
				switch(options[checkboxNumber[i]]) {
					case 'FPS Counter':
						daValue = ClientPrefs.showFPS;
					case 'Low Quality':
						daValue = ClientPrefs.lowQuality;
					case 'Anti-Aliasing':
						daValue = ClientPrefs.globalAntialiasing;
					case 'Note Splashes':
						daValue = ClientPrefs.noteSplashes;
					case 'Flashing Lights':
						daValue = ClientPrefs.flashing;
					case 'Downscroll':
						daValue = ClientPrefs.downScroll;
					case 'Middlescroll':
						daValue = ClientPrefs.middleScroll;
					case 'Ghost Tapping':
						daValue = ClientPrefs.ghostTapping;
					case 'Swearing':
						daValue = ClientPrefs.cursing;
					case 'Violence':
						daValue = ClientPrefs.violence;
					case 'Camera Zooms':
						daValue = ClientPrefs.camZooms;
					case 'Hide HUD':
						daValue = ClientPrefs.hideHud;
					case 'Persistent Cached Data':
						daValue = ClientPrefs.imagesPersist;
					case 'Vertical Health Bar':
						daValue = ClientPrefs.verthealthbar;
					case 'Song Backgrounds':
						daValue = ClientPrefs.songbackgrounds;
					case 'Fullscreen':
						daValue = ClientPrefs.fullscreenxd;
					case 'Strum Background':
						daValue = ClientPrefs.strumbackground;
					//case 'Hide Song Length':
						//daValue = ClientPrefs.hideTime;
					case 'Note Hit Sound':
						daValue = ClientPrefs.notehitsound;
					case 'Pause Ebola Timer':
						daValue = ClientPrefs.nerfebolatimer;
					case 'One Miss Chirumiru':
						daValue = ClientPrefs.onemisschirumiru;
					case 'One Miss Defeat':
						daValue = ClientPrefs.onemissdefeat;
					case 'Show Keyboard Overlay':
						daValue = ClientPrefs.showkeyboardoverlay;
				}
				checkbox.daValue = daValue;
			}
		}
		for (i in 0...grpTexts.members.length) {
			var text:AttachedText = grpTexts.members[i];
			if(text != null) {
				var daText:String = '';
				switch(options[textNumber[i]]) {
					case 'Framerate':
						daText = '' + ClientPrefs.framerate;
					case 'Note Delay':
						daText = ClientPrefs.noteOffset + 'ms';
					case 'Note Hit Volume':
						daText = '' + ClientPrefs.notehitvolume;
					case 'Keyboard Overlay Alpha':
						daText = '' + ClientPrefs.keyboardoverlayALPHA;
				}
				var lastTracker:FlxSprite = text.sprTracker;
				text.sprTracker = null;
				text.changeText(daText);
				text.sprTracker = lastTracker;
			}
		}
	}

	private function unselectableCheck(num:Int):Bool {
		for (i in 0...unselectableOptions.length) {
			if(options[num] == unselectableOptions[i]) {
				return true;
			}
		}
		return options[num] == '';
	}
}
