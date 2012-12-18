package motomadness
{
	import org.flixel.FlxGroup;
	
	public class TraficoManager extends FlxGroup
	{
		public function TraficoManager(MaxSize:uint=80)
		{
			super(MaxSize);
			
			var color : int = 1;
			for (var i:int = 0; i < MaxSize; i++) {
				var c : CarroTrafico = new CarroTrafico(0, 0, color);
				add(c);
				
				color = (color + 1) % 5;
			}
		}
		
		public function create(x:Number, y:Number) : CarroTrafico {
			var c : CarroTrafico;
			
			if (getFirstAvailable()) {
				c = CarroTrafico(getFirstAvailable()).create(x, y);
			}
			
			return c;
		}
	}
}