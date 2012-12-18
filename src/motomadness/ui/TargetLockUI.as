package motomadness.ui
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class TargetLockUI extends FlxSprite
	{
		public var lock : FlxSprite;
		
		private var locks : Array;
		
		public function TargetLockUI(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			this.makeGraphic(FlxG.width, 27, 0, true, "targetLockSpr");
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			solid = false;
			
			locks = new Array();
			lock = new FlxSprite(0, 0, AssetRegistry.targetLockSpr);
		}
		
		public function setTargetLock(xValue:Number) : void {
			locks.push({x:xValue, duration: 20});
		}
		
		public override function update() : void {
			fill(0);
			
			var l : Number = locks.length;
			for (var i : int = 0; i != l; i++) {
				var o : Object = locks[i];
				
				if (o.duration % 4 == 0) {
					stamp(lock, o.x, 0);
				}
				o.duration--;
			}
			
			locks = locks.filter(function (item:*, index:int, array:Array) : Boolean { return item.duration > 0; });
		}
	}
}