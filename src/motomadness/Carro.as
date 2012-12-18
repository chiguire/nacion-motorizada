package motomadness
{
	import flash.ui.Keyboard;
	
	import motomadness.particles.Smoke;
	
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.osflash.signals.Signal;
	
	public class Carro extends FlxSprite
	{
		public var driveable : Boolean = true;
		
		public static const PUSH_DURATION : uint = 15;
		public var pushDuration : uint = 0;
		public var pushAngle : Number;
		
		public var angularLimit : Number = 15;
		
		public var smokeEmitter : FlxEmitter;
		public var fireEmitter : FlxEmitter;
		
		public var killed : Signal;
		
		public function Carro(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			this.loadRotatedGraphic(AssetRegistry.carroSprite, 64, -1, true, true);
			health = 100;
			drag.x = 180;
			drag.y = 180;
			maxVelocity.x = 120;
			maxVelocity.y = 120;
			
			smokeEmitter = new FlxEmitter(X, Y, 50);
			smokeEmitter.setSize(this.width, 10);
			smokeEmitter.particleClass = Smoke;
			smokeEmitter.makeParticles(AssetRegistry.smokeSprite,50, 16, false, 0);
			smokeEmitter.setXSpeed(-50, 50);
			smokeEmitter.setYSpeed(50, 200);
			
			fireEmitter = new FlxEmitter(X, Y, 50);
			fireEmitter.setSize(this.width, this.height);
			fireEmitter.particleClass = Smoke;
			fireEmitter.makeParticles(AssetRegistry.fireSprite, 50, 16, true, 0);
			fireEmitter.setXSpeed(-100, 100);
			fireEmitter.setYSpeed(-100,100);
			
			killed = new Signal();
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
				if (FlxG.keys.LEFT || FlxG.keys.A) {
					acceleration.x = -120;
					angularVelocity = -80;
				} else if (FlxG.keys.RIGHT || FlxG.keys.D) {
					acceleration.x = 120;
					angularVelocity = 80;
				} else {
					angularVelocity = 0;
					angle *= 0.9;
					if (Math.abs(angle) < 2) {
						angle = 0;
					}
					acceleration.x = 0;
				}
				
				if (FlxG.keys.UP || FlxG.keys.W) {
					acceleration.y = -100;
				} else if (FlxG.keys.DOWN || FlxG.keys.S) {
					acceleration.y = 100;
				} else {
					acceleration.y = 0;
				}
				
				angle = StringUtils.clamp(angle, -angularLimit, angularLimit);
			} else {
				if (pushDuration <= 0) {
					driveable = true;
					pushDuration = 0;
				} else {
					pushDuration--;
				}
			}
			
			smokeEmitter.x = this.x;
			smokeEmitter.y = this.y;
			
			fireEmitter.x = this.x;
			fireEmitter.y = this.y;
			
			if (health <= 33 && !smokeEmitter.on) {
				smokeEmitter.start(false, 2, 0.1, 50);
			}
		}
		
		public override function kill():void {
			super.kill();
			exists = true;
			loadGraphic(AssetRegistry.carroDestroyedSprite, false, false);
			centerOffsets(false);
			//center car
			fireEmitter.start(true,1, 0.1);
			
			killed.dispatch();
		}
	}
}