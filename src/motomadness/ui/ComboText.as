package motomadness.ui
{
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	
	public class ComboText extends FlxText
	{
		public static const SECONDS_LEFT : int = 2;
		
		public var number : Number;
		
		public var stayTimer : FlxTimer;
		
		public var isFading : Boolean = false;
		
		public function ComboText(X:Number, Y:Number, Width:uint)
		{
			super(X, Y, Width, "", true);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			size = 24;
			alignment = "center";
			visible = false;
			exists = false;
			alpha = 1;
			
			stayTimer = new FlxTimer();
		}
		
		public function create(value:Number=NaN) : void {
			alpha = 1;
			exists = true;
			visible = false;
			isFading = false;
			
			if (!isNaN(value)) {
				setCombo(value);
			}
		}
		
		public function setCombo(value:Number) : void {
			exists = true;
			visible = true;
			text = value + "x Combo!";
		}
		
		public function fadeOutText() : void {
			stayTimer.start(SECONDS_LEFT, 1, fadeText);
		}
		
		private function fadeText(timer:FlxTimer) : void {
			isFading = true;
		}
		
		public override function update():void {
			if (isFading) {
				alpha -= 0.1;
				if (alpha <= 0) {
					exists = false;
				}
			}
		}
	}
}