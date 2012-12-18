package motomadness.particles
{
	import org.flixel.FlxParticle;
	
	public class Smoke extends FlxParticle
	{
		public function Smoke()
		{
			super();
		}
		
		private var startingLifespan : int = lifespan;
		
		public override function onEmit():void {
			startingLifespan = lifespan;
		}
		
		public override function update():void {
			super.update();
			if (velocity.x > 2) {
				velocity.x *= 0.8;
			} else {
				velocity.x = 0;
			}
		}
	}
}