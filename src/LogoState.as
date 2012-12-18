package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTimer;
	import org.flixel.system.FlxDebugger;
	
	public class LogoState extends FlxState
	{
		[Embed(source="/assets/logo.png")]
		public var logo : Class;
		
		private var gfx : FlxSprite;
		private var pauseTimer : FlxTimer;
		
		private var firstTime : Boolean = true;
		
		public function LogoState()
		{
			super();
		}
		
		public override function create():void {
			super.create();
			
			pauseTimer = new FlxTimer();
			
			gfx = new FlxSprite(0, 0, logo);
			add(gfx);
		}
		
		public override function update():void {
			super.update();
			if (firstTime) {
				firstTime = false;
				FlxG.flash(0, 1, goNext);
			}
		}
		
		private function goNext() : void {
			pauseTimer.start(4, 1, goNext2);
		}
		
		private function goNext2(t:FlxTimer) : void {
			FlxG.fade(0, 1, goNext3);
		}
		
		private function goNext3() : void {
			FlxG.switchState(new MenuState());
		}
		
		public override function destroy():void {
			super.destroy();
			pauseTimer.destroy();
		}
	}
}