package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	
	[SWF(width="320", height="640", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	public class Motorizado extends FlxGame
	{
		public var _mochiads_game_id:String = "a6074e7fc07c2005";
		
		public function Motorizado() {
			super(160,320,MenuState,2);
			FlxG.debug = false;
			
			//	If the FlxScrollZone Plugin isn't already in use, we add it here
			if (FlxG.getPlugin(FlxScrollZone) == null)
			{
				FlxG.addPlugin(new FlxScrollZone);
			}
		}
	}
}