package motomadness
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class CarroTrafico extends FlxSprite
	{
		public static const PUSH_DURATION : uint = 15;
		public var driveable : Boolean = true;
		public var pushAngle : Number = 0;
		public var pushDuration : Number = 0;
		
		public function CarroTrafico(X:Number=0, Y:Number=0, color:Number=1)
		{
			super(X, Y);
			
			loadRotatedGraphic(AssetRegistry["carroTrafico"+color+"Sprite"], 64, -1, true, true);
			
			exists = false;
		}
		
		public function create(X:Number, Y:Number) : CarroTrafico {
			x = X;
			y = Y;
			velocity.y = 20;
			exists = true;
			
			return this;
		}
		public function push(angle:Number, pushDuration : Number = PUSH_DURATION, force:Number = 100) : void {
			if (!driveable) return;
			driveable = false;
			pushDuration = pushDuration;
			pushAngle = angle;
			velocity.x = force*Math.cos(pushAngle);
			velocity.y = force*Math.sin(pushAngle);
		}
		
		public override function update() : void {
			if (driveable) {
				angle = 0;
				velocity.y = 20;
			} else {
				if (pushDuration <= 0) {
					driveable = true;
					pushDuration = 0;
				} else {
					pushDuration--;
				}
			}
			
			if (y > FlxG.height +5) {
				exists = false;
			}
		}
	}
}