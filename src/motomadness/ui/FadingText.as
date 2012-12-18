package motomadness.ui
{
	import org.flixel.FlxText;
	
	public class FadingText extends FlxText
	{
		public var counter : int = 0;
		public const MAX_COUNTER : int = 60;
		
		public function FadingText(X:Number=0, Y:Number=0, Width:uint=60, Text:String="+1", EmbeddedFont:Boolean=true)
		{
			super(X, Y, Width, Text, EmbeddedFont);
			exists = false;
			alignment = "left";
			size = 14;
		}
		
		public function create(x:Number, y:Number, txt:String) : FadingText {
			exists = true;
			this.x = x;
			this.y = y;
			velocity.y = -80;
			alpha = 1;
			counter = 0;
			text = txt;
			
			return this;
		}
		
		public override function update():void {
			counter++;
			alpha = 1 - counter/MAX_COUNTER;
			
			if (counter == MAX_COUNTER) {
				alpha = 0;
				exists = false;
			}
		}
	}
}