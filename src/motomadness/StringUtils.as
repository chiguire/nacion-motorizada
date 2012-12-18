package motomadness
{
	public final class StringUtils
	{
		public static function trailZeroes(txt:*, zeroes:Number) : String {
			var result : String = String(txt);
			var num : int = zeroes - result.length;
			
			if (num > 0) {
				for (var i : int= 0; i != num; i++) {
					result = "0" + result;
				}
			}
			return result;
		}
		
		public static function clamp(value:Number, min:Number, max:Number) : Number {
			if (min > max) trace("clamp: min greater than max");
			return Math.max(min, Math.min(value, max));
		}
	}
}