package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import Controls;

class ClientPrefs {
	//TO DO: Redo ClientPrefs in a way that isn't too stupid
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = false;
	public static var lowQuality:Bool = false;
	public static var framerate:Int = 60;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = true;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var imagesPersist:Bool = false;
	public static var ghostTapping:Bool = false;
	public static var hideTime:Bool = true;
	//new settings added by me lol
	public static var strumbackground:Bool = false;
	public static var verthealthbar:Bool = false;
	public static var songbackgrounds:Bool = true;

	//this got discontinued bc im really fucking stupid
	public static var noteskin:String = 'NOTE_assets';

	public static var fullscreenxd:Bool = false;
	public static var cursongdif:String = "Hard";
	public static var curmisssound:String = "missnotetouhou";
	
	//Read https://github.com/SanicBTW/FNF-PsychEngine-0.3.2-hotfix/issues/11
	#if web
	public static var notehitsound:Bool = false;
	#else
	public static var notehitsound:Bool = true;
	#end
	public static var notehitvolume:Float = 1;
	
	//keyboard overlay stuff
	public static var showkeyboardoverlay:Bool = true;
	public static var keyboardoverlayALPHA:Float = 0.5;
	public static var keyboardoverlayPOSITION:String = "Right";
	//idk if its gonna work with flxcolor, if it doesnt then gonna use strings
	public static var keyboardoverlayIDLECOLOR:FlxColor = FlxColor.GRAY;
	public static var keyboardoverlayPRESSINGCOLOR:FlxColor = FlxColor.WHITE;

	//some songs stuff
	public static var nerfebolatimer:Bool = false;
	public static var onemisschirumiru:Bool = true;
	public static var onemissdefeat:Bool = false;

	//thought about adding 6k and that but im lazy
	public static var defaultKeys:Array<FlxKey> = [
		A, LEFT,			//Note Left
		S, DOWN,			//Note Down
		W, UP,				//Note Up
		D, RIGHT,			//Note Right

		A, LEFT,			//UI Left
		S, DOWN,			//UI Down
		W, UP,				//UI Up
		D, RIGHT,			//UI Right

		NONE, NONE,			//Reset
		SPACE, ENTER,		//Accept
		BACKSPACE, ESCAPE,	//Back
		ENTER, ESCAPE		//Pause
	];
	//Every key has two binds, these binds are defined on defaultKeys! If you want your control to be changeable, you have to add it on ControlsSubState (inside OptionsState)'s list
	public static var keyBinds:Array<Dynamic> = [
		//Key Bind, Name for ControlsSubState
		[Control.NOTE_LEFT, 'Left'],
		[Control.NOTE_DOWN, 'Down'],
		[Control.NOTE_UP, 'Up'],
		[Control.NOTE_RIGHT, 'Right'],

		[Control.UI_LEFT, 'Left '],		//Added a space for not conflicting on ControlsSubState
		[Control.UI_DOWN, 'Down '],		//Added a space for not conflicting on ControlsSubState
		[Control.UI_UP, 'Up '],			//Added a space for not conflicting on ControlsSubState
		[Control.UI_RIGHT, 'Right '],	//Added a space for not conflicting on ControlsSubState

		[Control.RESET, 'Reset'],
		[Control.ACCEPT, 'Accept'],
		[Control.BACK, 'Back'],
		[Control.PAUSE, 'Pause']
	];
	public static var lastControls:Array<FlxKey> = defaultKeys.copy();

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.cursing = cursing;
		FlxG.save.data.violence = violence;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.hideTime = hideTime;
		FlxG.save.data.strumbackground = strumbackground;
		FlxG.save.data.songbackgrounds = songbackgrounds;
		FlxG.save.data.noteskin = noteskin;
		FlxG.save.data.fullscreenxd = fullscreenxd;
		FlxG.save.data.cursongdif = cursongdif;
		FlxG.save.data.curmisssound = curmisssound;
		FlxG.save.data.notehitsound = notehitsound;
		FlxG.save.data.notehitvolume = notehitvolume;
		FlxG.save.data.nerfebolatimer = nerfebolatimer;
		FlxG.save.data.onemisschirumiru = onemisschirumiru;
		FlxG.save.data.onemissdefeat = onemissdefeat;
		FlxG.save.data.showkeyboardoverlay = showkeyboardoverlay;
		FlxG.save.data.keyboardoverlayALPHA = keyboardoverlayALPHA;
		FlxG.save.data.keyboardoverlayPOSITION = keyboardoverlayPOSITION;
		FlxG.save.data.keyboardoverlayIDLECOLOR = keyboardoverlayIDLECOLOR;
		FlxG.save.data.keyboardoverlayPRESSINGCOLOR = keyboardoverlayPRESSINGCOLOR;

		var achieves:Array<String> = [];
		for (i in 0...Achievements.achievementsUnlocked.length) {
			if(Achievements.achievementsUnlocked[i][1]) {
				achieves.push(Achievements.achievementsUnlocked[i][0]);
			}
		}
		FlxG.save.data.achievementsUnlocked = achieves;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls', 'ninjamuffin99'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = lastControls;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}
		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}
		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = showFPS;
			}
		}
		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}
		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		/*if(FlxG.save.data.cursing != null) {
			cursing = FlxG.save.data.cursing;
		}
		if(FlxG.save.data.violence != null) {
			violence = FlxG.save.data.violence;
		}*/
		if(FlxG.save.data.camZooms != null) {
			camZooms = FlxG.save.data.camZooms;
		}
		if(FlxG.save.data.hideHud != null) {
			hideHud = FlxG.save.data.hideHud;
		}
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}
		if(FlxG.save.data.arrowHSV != null) {
			arrowHSV = FlxG.save.data.arrowHSV;
		}
		if(FlxG.save.data.imagesPersist != null) {
			imagesPersist = FlxG.save.data.imagesPersist;
			FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
		}
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if(FlxG.save.data.hideTime != null) {
			hideTime = FlxG.save.data.hideTime;
		}

		if (FlxG.save.data.strumbackground != null){
			strumbackground = FlxG.save.data.strumbackground;
		}

		if(FlxG.save.data.songbackgrounds != null) {
			songbackgrounds = FlxG.save.data.songbackgrounds;
		}

		if (FlxG.save.data.noteskin != null){
			noteskin = FlxG.save.data.noteskin;
		}

		if (FlxG.save.data.fullscreenxd != null){
			fullscreenxd = FlxG.save.data.fullscreenxd;
		}

		if (FlxG.save.data.cursongdif != null){
			cursongdif = FlxG.save.data.cursongdif;
		}

		if (FlxG.save.data.curmisssound != null){
			curmisssound = FlxG.save.data.curmisssound;
		}

		if (FlxG.save.data.notehitsound != null){
			notehitsound = FlxG.save.data.notehitsound;
		}

		if (FlxG.save.data.notehitvolume != null){
			notehitvolume = FlxG.save.data.notehitvolume;
		}

		if (FlxG.save.data.nerfebolatimer != null){
			nerfebolatimer = FlxG.save.data.nerfebolatimer;
		}

		if (FlxG.save.data.onemisschirumiru != null){
			onemisschirumiru = FlxG.save.data.onemisschirumiru;
		}

		if (FlxG.save.data.onemissdefeat != null){
			onemissdefeat = FlxG.save.data.onemissdefeat;
		}

		if (FlxG.save.data.showkeyboardoverlay != null){
			showkeyboardoverlay = FlxG.save.data.showkeyboardoverlay;
		}

		if (FlxG.save.data.keyboardoverlayALPHA != null){
			keyboardoverlayALPHA = FlxG.save.data.keyboardoverlayALPHA;
		}

		if (FlxG.save.data.keyboardoverlayPOSITION != null){
			keyboardoverlayPOSITION = FlxG.save.data.keyboardoverlayPOSITION;
		}

		if (FlxG.save.data.keyboardoverlayIDLECOLOR != null){
			keyboardoverlayIDLECOLOR = FlxG.save.data.keyboardoverlayIDLECOLOR;
		}

		if (FlxG.save.data.keyboardoverlayPRESSINGCOLOR != null){
			keyboardoverlayPRESSINGCOLOR = FlxG.save.data.keyboardoverlayPRESSINGCOLOR;
		}

		var save:FlxSave = new FlxSave();
		save.bind('controls', 'ninjamuffin99');
		if(save != null && save.data.customControls != null) {
			reloadControls(save.data.customControls);
		}
	}

	public static function reloadControls(newKeys:Array<FlxKey>) {
		ClientPrefs.removeControls(ClientPrefs.lastControls);
		ClientPrefs.lastControls = newKeys.copy();
		ClientPrefs.loadControls(ClientPrefs.lastControls);
	}

	private static function removeControls(controlArray:Array<FlxKey>) {
		for (i in 0...keyBinds.length) {
			var controlValue:Int = i*2;
			var controlsToRemove:Array<FlxKey> = [];
			for (j in 0...2) {
				if(controlArray[controlValue+j] != NONE) {
					controlsToRemove.push(controlArray[controlValue+j]);
				}
			}
			if(controlsToRemove.length > 0) {
				PlayerSettings.player1.controls.unbindKeys(keyBinds[i][0], controlsToRemove);
			}
		}
	}
	private static function loadControls(controlArray:Array<FlxKey>) {
		for (i in 0...keyBinds.length) {
			var controlValue:Int = i*2;
			var controlsToAdd:Array<FlxKey> = [];
			for (j in 0...2) {
				if(controlArray[controlValue+j] != NONE) {
					controlsToAdd.push(controlArray[controlValue+j]);
				}
			}
			if(controlsToAdd.length > 0) {
				PlayerSettings.player1.controls.bindKeys(keyBinds[i][0], controlsToAdd);
			}
		}
	}
}