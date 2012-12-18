package motomadness.ui
{
	import motomadness.Carro;
	import motomadness.StringUtils;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.plugin.photonstorm.FlxBar;
	
	public class HUD extends FlxGroup
	{
		public var bgSpr : FlxSprite;

		public var healthBar : FlxBar;
		public var scoreText : FlxText;
		public var highestComboText : FlxText;
		public var levelText : FlxText;
		
		public var comboText : ComboText;
		
		public var targetLock : TargetLockUI;
		
		public static const HEIGHT : Number = 44;
		public static const X : Number = 0;
		public static const Y : Number = 320-HEIGHT;
		
		public function HUD(carro:Carro)
		{
			super(10);
			
			bgSpr = new FlxSprite(X, Y, AssetRegistry.hudBackgroundSpr);
			bgSpr.scrollFactor.x = 0;
			bgSpr.scrollFactor.y = 0;
			bgSpr.solid = false;
			add(bgSpr);
			
			targetLock = new TargetLockUI(0, FlxG.height-75);
			add(targetLock);
			
			healthBar = new FlxBar(X+20, Y+5, FlxBar.FILL_LEFT_TO_RIGHT, 64, 10, carro, "health", 0, 100, false);
			healthBar.createFilledBar(0, 0xff66ff33, true);
			healthBar.scrollFactor.x = 0;
			healthBar.scrollFactor.y = 0;
			healthBar.solid = false;
			add(healthBar);
			
			scoreText = new FlxText(X+115, Y+2, 50, "00000", true);
			scoreText.scrollFactor.x = 0;
			scoreText.scrollFactor.y = 0;
			scoreText.size = 11;
			scoreText.solid = false;
			add(scoreText);
			
			highestComboText = new FlxText(X+64, Y+17, 50, "00", true);
			highestComboText.scrollFactor.x = 0;
			highestComboText.scrollFactor.y = 0;
			highestComboText.size = 11;
			highestComboText.solid = false;
			add(highestComboText);
			
			levelText = new FlxText(X+115, Y+17,50, "01", true);
			levelText.scrollFactor.x = 0;
			levelText.scrollFactor.y = 0;
			levelText.size = 11;
			levelText.solid = false;
			add(levelText);
			
			comboText = new ComboText(0, FlxG.height/2, FlxG.width);
			add(comboText);
			
		}
		
		public function set score(value:Number) : void {
			scoreText.text = StringUtils.trailZeroes(value, 5);
		}
		
		public function set highestCombo(value:Number) : void {
			highestComboText.text = StringUtils.trailZeroes(value, 2);
		}
		
		public function set level(value:Number) : void {
			levelText.text = StringUtils.trailZeroes(value, 2);
		}
		
		public function setCombo(value:Number) : void {
			comboText.create(value);
		}
		
		public function fadeCombo() : void {
			comboText.fadeOutText();
		}
	}
}