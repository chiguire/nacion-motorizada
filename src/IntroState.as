package
{
	import flash.ui.Keyboard;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTimer;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	import org.flixel.system.FlxDebugger;
	
	public class IntroState extends FlxState
	{
		private var gfx : FlxSprite;
		private var pauseTimer : FlxTimer;
		
		public function IntroState()
		{
			super();
		}
		
		public override function create():void {
			super.create();
			
			gfx = new FlxSprite(0, 0, AssetRegistry.introhelp);
			add(gfx);
		}
		
		public override function update():void {
			super.update();
			if (FlxG.keys.justPressed("SPACE")) {
				FlxG.switchState(new PlayState());
			}
		}
		
		public override function destroy():void {
			super.destroy();
		}
	}
}