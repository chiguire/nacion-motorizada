package motomadness.ui
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	
	public class FadingTextManager extends FlxGroup
	{
		public function FadingTextManager(MaxSize:uint=0) {
			super(MaxSize);
		
			for (var i:int = 0; i < 50; i++) {
				add(new FadingText());
			}
		}
			
		public function create(x:Number, y:Number, txt:String) : FlxText {
			var t : FlxText;
			
			if (getFirstAvailable()) {
				t = FadingText(getFirstAvailable()).create(x, y, txt);
			}
			
			return t;
		}
	}
}