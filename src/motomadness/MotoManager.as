package motomadness
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.osflash.signals.Signal;
	
	public class MotoManager extends FlxGroup
	{
		public var comboEnded : Signal;
		public var targetLocked : Signal;
		
		public var internalCounter : int = 0;
		
		public function MotoManager(carro : Carro, trafficGroup: FlxGroup, MaxSize:uint=0)
		{
			super(MaxSize);
			
			comboEnded = new Signal();
			targetLocked = new Signal(Moto);
			
			for (var i:int = 0; i < 200; i++) {
				var m : Moto = new Moto(carro, trafficGroup);
				m.exited.add(checkComboEnd);
				m.targetLocked.add(targetLockedBubble);
				add(m);
			}
		}
		
		public function create(x:Number, y:Number, type:Number) : Moto {
			var m : Moto;
			
			var fb : FlxBasic = getFirstAvailable();
			if (fb) {
				trace("Creating moto in x "+x+", y "+y+" has name "+Moto(fb).name+"("+fb.exists+") assigning name "+String(internalCounter));
				m = Moto(fb).create(x, y, type);
				m.name = String(internalCounter);
				internalCounter++;
			} else {
				trace("No more motos!");
			}
			
			return m;
		}
		
		public function checkComboEnd(e:*) : void {
			if (countExistsButDead() == 0) {
				comboEnded.dispatch();
			}
		}
		
		public function targetLockedBubble(m:Moto) : void {
			targetLocked.dispatch(m);
		}
		
		/**
		 * Call this function to find out how many members of the group exist but are dead.
		 */
		private function countExistsButDead():int
		{
			var count:int = -1;
			var basic:FlxBasic;
			var i:uint = 0;
			while(i < length)
			{
				basic = members[i++] as FlxBasic;
				if(basic != null)
				{
					if(count < 0)
						count = 0;
					if(basic.exists && !basic.alive)
						count++;
				}
			}
			return count;
		}
	}
}