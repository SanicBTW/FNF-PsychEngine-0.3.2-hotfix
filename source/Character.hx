package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import Section.SwagSection;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import openfl.utils.Assets;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef CharacterFile = {
	var animations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;

	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;
}

typedef AnimArray = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = DEFAULT_CHARACTER;

	public var colorTween:FlxTween;
	public var holdTimer:Float = 0;
	public var heyTimer:Float = 0;
	public var specialAnim:Bool = false;
	public var animationNotes:Array<Dynamic> = [];
	public var stunned:Bool = false;
	public var singDuration:Float = 4; //Multiplier of how long a character holds the sing pose
	public var idleSuffix:String = '';
	public var danceIdle:Bool = false; //Character use "danceLeft" and "danceRight" instead of "idle"

	public var healthIcon:String = 'face';
	public var animationsArray:Array<AnimArray> = [];

	public var positionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];

	//Used on Character Editor
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var originalFlipX:Bool = false;
	public var healthColorArray:Array<Int> = [255, 0, 0];

	public static var DEFAULT_CHARACTER:String = 'bf'; //In case a character is missing, it will use BF on its place
	public function new(x:Float, y:Float, ?character:String = 'bf', ?isPlayer:Bool = false)
	{
		super(x, y);

		#if (haxe >= "4.0.0")
		animOffsets = new Map();
		#else
		animOffsets = new Map<String, Array<Dynamic>>();
		#end
		curCharacter = character;
		this.isPlayer = isPlayer;
		antialiasing = ClientPrefs.globalAntialiasing;

		var library:String = null;
		switch (curCharacter)
		{
			//case 'your character name in case you want to hardcode him instead':
			
			#if html5
			case 'bfcirno':
				healthIcon = "bf";
				flipX = true;
				healthColorArray = [49,176,209];
				cameraPosition = [190, -210];
				positionArray = [0, 260];

				var tex = Paths.getSparrowAtlas('characters/BOYFRIENDCIRNO', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);

				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);

				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('hurt', 'BF hit', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24, false);

				animation.addByPrefix('firstDeath', 'BF dies', 24, false);
				animation.addByPrefix('deathLoop', 'BF Dead Loop', 24, false);
				animation.addByPrefix('deathConfirm', 'BF Dead confirm', 24, false);

				addOffset('idle', -5, 0);
				addOffset('singLEFT', 12, -6);
				addOffset('singDOWN', -10, -50);
				addOffset('singUP', -29, 27);
				addOffset('singRIGHT', -38, -7);

				addOffset('singLEFTmiss', 12, 24);
				addOffset('singDOWNmiss', -11, -19);
				addOffset('singUPmiss', -29, 27);
				addOffset('singRIGHTmiss', -30, 21);

				addOffset('hey', -3, 5);
				addOffset('hurt', 15, 18);
				addOffset('scared', -4, 0);

				addOffset('firstDeath', 404, 444);
				addOffset('deathLoop', 176, 444);
				addOffset('deathConfirm', 176, 444);
		
				playAnim('idle');
				
			case 'black':
				healthIcon = "black";
				healthColorArray = [43, 43, 43];	
				cameraPosition = [-400, 0];

				var tex = Paths.getSparrowAtlas('characters/black', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BLACK IDLE', 24, true);
				animation.addByPrefix('singUP', 'BLACK UP', 24, false);
				animation.addByPrefix('singRIGHT', 'BLACK RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'BLACK DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'BLACK LEFT', 24, false);

				animation.addByPrefix('death', 'BLACK DEATH', 24, false);

				addOffset('idle');
				addOffset("singUP", 46, 104);
				addOffset("singRIGHT", -225, -10);
				addOffset("singLEFT", 116, 12);
				addOffset("singDOWN", -22, -20);
				addOffset("death", 252, 238);

				playAnim('idle');

			case 'tankman':
				flipX = true;
				healthIcon = "tankman";
				healthColorArray = [43, 43, 43];	
				cameraPosition = [0, 0];
				positionArray = [0, 250];
	
				var tex = Paths.getSparrowAtlas('characters/tankmanCaptain', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Tankman Idle Dance', 24, true);
				animation.addByPrefix('singUP', 'Tankman UP note', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Right Note', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Note Left', 24, false);
				animation.addByPrefix('singUP-alt', 'PRETTY GOOD', 24, false);
	
				addOffset('idle');
				addOffset('singLEFT', 100, -14);
				addOffset('singDOWN', 98, -90);
				addOffset('singUP', 24, 56);
				addOffset('singRIGHT', -1, -7);
				addOffset('singUP-alt', 98, -90);

				playAnim('idle');

			case 'zardyMyBeloved':
				healthIcon = "zardyMyBeloved";
				healthColorArray = [255, 255, 255];
				cameraPosition = [1, 140];
				positionArray = [-80, 140];

				var tex = Paths.getSparrowAtlas('characters/Zardy','shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 14);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);
	
				addOffset('idle');
				addOffset("singUP", -80, -10);
				addOffset("singRIGHT", -65, 5);
				addOffset("singLEFT", 130, 5);
				addOffset("singDOWN", -2, -26);
	
				playAnim('idle');

			case 'bfzar1':
				healthIcon = "bf";
				flipX = true;
				healthColorArray = [49,176,209];
				cameraPosition = [1, 1];
				positionArray = [80, 510];
		
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'preload');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
		
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
		
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('hurt', 'BF hit', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24, false);
		
				animation.addByPrefix('firstDeath', 'BF dies', 24, false);
				animation.addByPrefix('deathLoop', 'BF Dead Loop', 24, true);
				animation.addByPrefix('deathConfirm', 'BF Dead confirm', 24, false);
		
				addOffset('idle', -5, 0);
				addOffset('singLEFT', 12, -6);
				addOffset('singDOWN', -10, -50);
				addOffset('singUP', -29, 27);
				addOffset('singRIGHT', -38, -7);
		
				addOffset('singLEFTmiss', 12, 24);
				addOffset('singDOWNmiss', -11, -19);
				addOffset('singUPmiss', -27, 27);
				addOffset('singRIGHTmiss', -30, 21);
		
				addOffset('hey', -3, 5);
				addOffset('hurt', 15, 18);
				addOffset('scared', -4, 0);
		
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				
				playAnim('idle');
	

			case 'bfholdinggf':
				healthIcon = "bf";
				flipX = true;
				healthColorArray = [49,176,209];
				cameraPosition = [0, 0];
				positionArray = [0, 350];
	
				var tex = Paths.getSparrowAtlas('characters/bfholdinggf', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
	
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
	
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('hurt', 'BF hit', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24, false);
	
				animation.addByPrefix('firstDeath', 'BF dies', 24, false);
				animation.addByPrefix('deathLoop', 'BF Dead Loop', 24, true);
				animation.addByPrefix('deathConfirm', 'BF Dead confirm', 24, false);
	
				addOffset('idle', 0, 5);
				addOffset('singLEFT', 12, 0);
				addOffset('singDOWN', -10, -40);
				addOffset('singUP', -27, 39);
				addOffset('singRIGHT', -40, 0);
	
				addOffset('singLEFTmiss', 12, 24);
				addOffset('singDOWNmiss', -26, -15);
				addOffset('singUPmiss', -27, 39);
				addOffset('singRIGHTmiss', -40, 24);
	
				addOffset('hey', 2, 12);
				addOffset('hurt', 15, 18);
				addOffset('scared', -4, 0);
	
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
			
				playAnim('idle');

			case 'bfmii':
				healthIcon = "bf";
				flipX = true;
				healthColorArray = [49,176,209];
				cameraPosition = [0, 0];
				positionArray = [0, 350];

				var tex = Paths.getSparrowAtlas('characters/BOYFRIENDMII','shared');
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
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
		
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
		
				playAnim('idle');

		case 'bfaccelerant':
				healthIcon = "bf";
				flipX = true;
				healthColorArray = [49,176,209];
				cameraPosition = [0, 0];
				positionArray = [0, 350];

				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND','preload');
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

				animation.addByPrefix('bfdodge', 'boyfriend dodge', 24, false);
		
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
		
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);

				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);

				addOffset("bfdodge", -10, -20);

				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
		
				playAnim('idle');

				//it is really fucking bad
			case 'bfbuthanklol':
				flipX = true;
				healthIcon = "face";
				healthColorArray = [43, 43, 43];
				cameraPosition = [0, 0];
				positionArray = [0, 350];

				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND','preload');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('bfattack', 'boyfriend attack', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("bfattack", -10, -20);
	
				playAnim('idle');

			case 'matt':
				healthIcon = "bf";
				healthColorArray = [255, 165, 0];
				cameraPosition = [0, 0];
				positionArray = [0, 300];

				var tex = Paths.getSparrowAtlas('characters/matt_assets','shared');
				frames = tex;

				animation.addByPrefix('idle', "matt idle", 24);
				animation.addByPrefix('singUP', 'matt up note', 24, false);
				animation.addByPrefix('singDOWN', 'matt down note', 24, false);
				animation.addByPrefix('singLEFT', 'matt left note', 24, false);
				animation.addByPrefix('singRIGHT', 'matt right note', 24, false);

				addOffset("singUP", 0, 20);
				addOffset("singRIGHT", -15, -20);
				addOffset("singLEFT", 30, -40);
				addOffset("singDOWN", 0, -20);

				playAnim('idle');

			case 'garcello':
				healthIcon = "bf";
				healthColorArray = [0, 0, 0];
				cameraPosition = [0, 0];
				positionArray = [0, 0];

				var tex = Paths.getSparrowAtlas('characters/garcello_assets');
				frames = tex;
				animation.addByPrefix('idle', 'garcello idle dance', 24);
				animation.addByPrefix('singUP', 'garcello Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24);
	
				addOffset('idle');
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
	
				playAnim('idle');

			case 'garcellotired':
				healthIcon = "bf";
				healthColorArray = [0, 0, 0];
				cameraPosition = [0, 0];
				positionArray = [0, 0];

				var tex = Paths.getSparrowAtlas('characters/garcellotired_assets');
				frames = tex;
				animation.addByPrefix('idle', 'garcellotired idle dance', 24, false);
				animation.addByPrefix('singUP', 'garcellotired Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'garcellotired Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'garcellotired Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'garcellotired Sing Note LEFT', 24, false);
	
				animation.addByPrefix('singUP-alt', 'garcellotired Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'garcellotired Sing Note RIGHT', 24, false);
				animation.addByPrefix('singLEFT-alt', 'garcellotired Sing Note LEFT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'garcellotired cough', 24, false);
	
				addOffset('idle');
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);

				addOffset("singUP-alt", 0, 0);
				addOffset("singRIGHT-alt", 0, 0);
				addOffset("singLEFT-alt", 0, 0);
				addOffset("singDOWN-alt", 0, 0);
	
				playAnim('idle');

			case 'garcellodead':
				healthIcon = "bf";
				healthColorArray = [0, 0, 0];
				cameraPosition = [0, 0];
				positionArray = [0, 0];

				var tex = Paths.getSparrowAtlas('characters/garcellodead_assets');
				frames = tex;
				animation.addByPrefix('idle', 'garcello idle dance', 24);
				animation.addByPrefix('singUP', 'garcello Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24);
	
				animation.addByPrefix('garTightBars', 'garcello coolguy', 15);
	
				addOffset('idle');
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset("garTightBars", 0, 0);
	
				playAnim('idle');

			case 'bf-zar':
				healthIcon = "bf";
				flipX = true;
				healthColorArray = [49, 176, 209];
				cameraPosition = [0, 0];
				positionArray = [80, 490];

				var tex = Paths.getSparrowAtlas('characters/ZardyWeek2_BoyFriend','shared');
				frames = tex;
	
				animation.addByPrefix('idle', 'BF idle dance instance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP instance', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT instance', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT instance', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN instance', 24, false);

				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS instance', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS instance', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS instance', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS instance', 24, false);

				animation.addByPrefix('fall', 'bf pre attack instance', 24, false);
				animation.addByPrefix('axe', 'Holding Axe instance', 24, false);
				//animation.addByPrefix('axe', 'Holding Axe instance', Math.floor(24 * PlayState.songMultiplier), false);

				animation.addByIndices('dead', 'BF hit instance 1',[19,20,21,22,23,24],"", 24, false);
				animation.addByIndices('heldByVine', 'BF hit instance 1',[4,5,6,7,8,9,10,12,13,14,15,16,17,18],"", 24, true);
				animation.addByIndices('deadInVine', 'BF hit instance 1',[18,19,20,21,22,23,24],"", 24, false);

				animation.addByPrefix('dodge', 'boyfriend dodge instance 1', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
	
				animation.addByPrefix('firstDeath', "BF dies instance", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop instance", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm instance", 24, false);
	
				addOffset('idle', -5, 0);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
	
				playAnim('idle');
				
			case 'zardyButDARK':
				healthIcon = "zardyButDARK";
				healthColorArray = [255, 165, 0];
				cameraPosition = [1, 140];
				positionArray = [-120, 140];

				var tex = Paths.getSparrowAtlas('characters/ZardyDark','shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 14);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);
	
				addOffset('idle');
				addOffset("singUP", -80, -10);
				addOffset("singRIGHT", -65, 5);
				addOffset("singLEFT", 130, 5);
				addOffset("singDOWN", -2, -26);
	
				playAnim('idle');

			case 'cableCrowPog':
				healthIcon = "cableCrowPog";
				healthColorArray = [255, 160, 0];
				cameraPosition = [1, 140];
				positionArray = [-120, 120];

				var tex = Paths.getSparrowAtlas('characters/Cablecrow','shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 14);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);
	
				addOffset('idle', -1, 3);
				addOffset('singUP', 0, 8);
				addOffset('singRIGHT', -160, -15);
				addOffset('singLEFT', -32, 4);
				addOffset('singDOWN', -14, 5);				
			#end

			default:
				var characterPath:String = 'characters/' + curCharacter + '.json';
				#if MODS_ALLOWED
				var path:String = Paths.mods(characterPath);
				if (!FileSystem.exists(path)) {
					path = Paths.getPreloadPath(characterPath);
				}

				if (!FileSystem.exists(path))
				#else
				var path:String = Paths.getPreloadPath(characterPath);
				if (!Assets.exists(path))
				#end
				{
					path = Paths.getPreloadPath('characters/' + DEFAULT_CHARACTER + '.json'); //If a character couldn't be found, change him to BF just to prevent a crash
				}

				#if MODS_ALLOWED
				var rawJson = File.getContent(path);
				#else
				var rawJson = Assets.getText(path);
				#end

				var json:CharacterFile = cast Json.parse(rawJson);
				if(Assets.exists(Paths.getPath('images/' + json.image + '.txt', TEXT))) {
					frames = Paths.getPackerAtlas(json.image);
				} else {
					frames = Paths.getSparrowAtlas(json.image);
				}
				imageFile = json.image;

				if(json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				positionArray = json.position;
				cameraPosition = json.camera_position;

				healthIcon = json.healthicon;
				singDuration = json.sing_duration;
				flipX = !!json.flip_x;
				if(json.no_antialiasing)
					noAntialiasing = true;

				if(json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				antialiasing = !noAntialiasing;
				if(!ClientPrefs.globalAntialiasing) antialiasing = false;

				animationsArray = json.animations;
				if(animationsArray != null && animationsArray.length > 0) {
					for (anim in animationsArray) {
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; //Bruh
						var animIndices:Array<Int> = anim.indices;
						if(animIndices != null && animIndices.length > 0) {
							animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
						} else {
							animation.addByPrefix(animAnim, animName, animFps, animLoop);
						}

						if(anim.offsets != null && anim.offsets.length > 1) {
							addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
						}
					}
				} else {
					quickAnimAdd('idle', 'BF idle dance');
				}
				trace('Loaded file to character ' + curCharacter);
		}
		originalFlipX = flipX;

		recalculateDanceIdle();
		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			/*if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				if(animation.getByName('singLEFT') != null && animation.getByName('singRIGHT') != null)
				{
					var oldRight = animation.getByName('singRIGHT').frames;
					animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
					animation.getByName('singLEFT').frames = oldRight;
				}

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singLEFTmiss') != null && animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}*/
		}
	}

	override function update(elapsed:Float)
	{
		
		if(!debugMode && animation.curAnim != null)
		{
			if(heyTimer > 0)
			{
				heyTimer -= elapsed;
				if(heyTimer <= 0)
				{
					if(specialAnim && animation.curAnim.name == 'hey' || animation.curAnim.name == 'cheer')
					{
						specialAnim = false;
						dance();
					}
					heyTimer = 0;
				}
			} else if(specialAnim && animation.curAnim.finished)
			{
				specialAnim = false;
				dance();
			}

			if (!isPlayer)
			{
				if (animation.curAnim.name.startsWith('sing'))
				{
					holdTimer += elapsed;
				}

				if (holdTimer >= Conductor.stepCrochet * 0.001 * singDuration)
				{
					dance();
					holdTimer = 0;
				}
			}

			if(animation.curAnim.finished && animation.getByName(animation.curAnim.name + '-loop') != null)
			{
				playAnim(animation.curAnim.name + '-loop');
			}
		}
		super.update(elapsed);
	}

	public var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode && !specialAnim)
		{
			if(danceIdle)
			{
				danced = !danced;

				if (danced)
					playAnim('danceRight' + idleSuffix);
				else
					playAnim('danceLeft' + idleSuffix);
			}
			else if(animation.getByName('idle' + idleSuffix) != null) {
					playAnim('idle' + idleSuffix);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		specialAnim = false;
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter.startsWith('gf'))
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function recalculateDanceIdle() {
		danceIdle = (animation.getByName('danceLeft' + idleSuffix) != null && animation.getByName('danceRight' + idleSuffix) != null);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function quickAnimAdd(name:String, anim:String)
	{
		animation.addByPrefix(name, anim, 24, false);
	}
}
