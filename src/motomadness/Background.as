package motomadness
{
	import flash.geom.Rectangle;
	
	import motomadness.ui.HUD;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	
	public class Background extends FlxGroup
	{
		public var bgSprite : FlxSprite;
		
		public var leftBorde : FlxSprite;
		public var rightBorde : FlxSprite;
		public var topBorde : FlxSprite;
		public var bottomBorde : FlxSprite;
		
		public var sides : FlxGroup;
		public var topBottom : FlxGroup;
		
		private var _cameraSpeed : Number;
		
		public function Background(cameraSpd:Number)
		{
			bgSprite = new FlxSprite(0, 0, AssetRegistry.roadbgSprite);
			bgSprite.solid = false;
			FlxScrollZone.add(bgSprite, new Rectangle(0, 0, bgSprite.width, bgSprite.height), 0, cameraSpd, true, true);
			
			_cameraSpeed = cameraSpd;
			
			leftBorde = new FlxSprite(0, 0);
			leftBorde.makeGraphic(16, FlxG.height);
			leftBorde.alpha = 0;
			leftBorde.immovable = true;
			
			rightBorde = new FlxSprite(144, 0);
			rightBorde.makeGraphic(16, FlxG.height);
			rightBorde.alpha = 0;
			rightBorde.immovable = true;
			
			topBorde = new FlxSprite(0, -10);
			topBorde.makeGraphic(FlxG.width, 50);
			topBorde.alpha = 0;
			topBorde.immovable = true;
			
			bottomBorde = new FlxSprite(0, FlxG.height-HUD.HEIGHT);
			bottomBorde.makeGraphic(FlxG.width, 10);
			bottomBorde.alpha = 0;
			bottomBorde.immovable = true;
			
			add(bgSprite);
			add(leftBorde);
			add(rightBorde);
			add(topBorde);
			add(bottomBorde);
			
			sides = new FlxGroup();
			sides.add(leftBorde);
			sides.add(rightBorde);
			
			topBottom = new FlxGroup();
			topBottom.add(topBorde);
			topBottom.add(bottomBorde);
		}
		
		public function set cameraSpeed(value:Number) : void {
			_cameraSpeed = value;
			FlxScrollZone.updateY(bgSprite, value);
		}
		
		public function get cameraSpeed() : Number {
			return _cameraSpeed;
		}
	}
}