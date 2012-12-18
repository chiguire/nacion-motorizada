package motomadness
{
	import flash.geom.Rectangle;
	
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	
	public class Lanes extends FlxSprite
	{
		[Embed(source="/assets/game/lanes.png")]
		public var lanesSprite : Class;
		
		public function Lanes(cameraSpeed:Number, X:Number=0, Y:Number=0)
		{
			super(X, Y, lanesSprite);
			
			this.scrollFactor.x = 0;
			this.scrollFactor.y = 0;
			
			FlxScrollZone.add(this, new Rectangle(0, 0, this.width, this.height), 0, cameraSpeed, true, true);
		}
	}
}