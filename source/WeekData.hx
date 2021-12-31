package;

class WeekData {
	//Song names, used on both Story Mode and Freplay
	//Go to FreeplayState.hx and add the head icons
	//Go to StoryMenuState.hx and add the characters/backgrounds

	//Made a new branch that will contain only the osu songs, the master branch will only have mod songs 
	//Its to make the loading times shorter ig
	//Theres only like a couple of songs that has scores working wtf :skull:
	public static var songsNames:Array<Dynamic> = [
		['Tutorial'],

		['chirumiru', 'defeat', 'split'],
		['foolhardy', 'bushwhack', 'accelerant'],
		['infinigger', 'target-practice', 'sporting'],
		['termination', 'bullet-note-tst', 'monochrome'],
		['8-28-63', 'expurgation', 'erect-dadbattle'],
		['erect-south']
	];

	public static var easysongNames:Array<Dynamic> = [
		['Tutorial'],
		
		[],
		[],
		[],
		[],
		[],
		[],

		['guns', 'stress', 'headache' ],
		['nerves', 'release'],
	];

	// Custom week number, used for your week's score not being overwritten by a new vanilla week when the game updates
	// I'd recommend setting your week as -99 or something that new vanilla weeks will probably never ever use
	// null = Don't change week number, it follows the vanilla weeks number order

	//Really sorry trying to fix week scores but literally doin nothing
	public static var weekNumber:Array<Dynamic> = [
		null,	//Tutorial
		-99,	//Week 1
		-98,	//Week 2
		-97,	//Week 3
		-96,	//Week 4
		-95,	//Week 5
		-94,	//Week 6

		-93,	//Week 7 ig
		-92,	//Week 8 ig
		-91,	//Week 9 ig
		-90,	//Week 10 ig
	];

	//Tells which assets directory should it load
	//Reminder that you have to add the directories on Project.xml too or they won't be compiled!!!
	//Just copy week6/week6_high mentions and rename it to whatever your week will be named
	//It ain't that hard, i guess

	//Oh yeah, quick reminder that files inside the folder that ends with _high are only loaded
	//if you have the Low Quality option disabled on "Preferences"
	public static var loadDirectory:Array<String> = [
		null, //Tutorial loads "tutorial" folder on assets/
		null,	//Week 1
		null,	//Week 2
		null,	//Week 3
		null,	//Week 4
		null,	//Week 5
		null	//Week 6
	];

	//The only use for this is to display a different name for the Week when you're on the score reset menu.
	//Set it to null to make the Week be automatically called "Week (Number)"

	//Edit: This now also messes with Discord Rich Presence, so it's kind of relevant.
	public static var weekResetName:Array<String> = [
		null,
		null,	//Week 1
		null,	//Week 2
		null,	//Week 3
		null,	//Week 4
		null,	//Week 5
		null	//Week 6
	];


	//   FUNCTIONS YOU WILL PROBABLY NEVER NEED TO USE

	//To use on PlayState.hx or Highscore stuff
	public static function getCurrentWeekNumber():Int {
		return getWeekNumber(PlayState.storyWeek);
	}

	public static function getWeekNumber(num:Int):Int {
		var value:Int = 0;
		if(num < weekNumber.length) {
			value = num;
			if(weekNumber[num] != null) {
				value = weekNumber[num];
				//trace('Cur value: ' + value);
			}
		}
		return value;
	}

	//Used on LoadingState, nothing really too relevant
	public static function getWeekDirectory():String {
		var value:String = loadDirectory[PlayState.storyWeek];
		if(value == null) {
			value = "week" + getCurrentWeekNumber();
		}
		return value;
	}
}
