package motomadness
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	
	public class Moto extends FlxSprite
	{
		public var name : String = "null";
		public var carro: Carro;
		public var trafficGroup: FlxGroup;
		
		public var movementType : int = NO_INSTRUCTION;
		
		public static const RAM_CAR_DISTANCE : int = 70;
		
		public static const NO_INSTRUCTION : int = 0;
		public static const FOLLOW_CAR : int = 1;
		public static const RAM_CAR : int = 2;
		public static const RAM_AHEAD_CAR : int = 3;
		public static const RAM_AHEAD_TRUCK : int = 4;
		
		public var isCrashed : Boolean = false;
		public var crashedByCar : Boolean = false;
		
		public var exited : Signal;
		public var targetLocked : Signal;
		
		private var playedLock : Boolean = false; //For motos with movementType RAM_CAR, falg for telling if target lock icon has been shown
		
		public function Moto(carro:Carro, trafficGroup: FlxGroup)
		{
			super(0, 0);
			
			
			exists = false;
			alive = false;
			crashedByCar = false;
			playedLock = false;
			
			exited = new Signal(Moto);
			targetLocked = new Signal(Moto);
			
			this.carro = carro;
			this.trafficGroup = trafficGroup;
		}
		
		public function loadAssets(graph:Class) : void {
			loadGraphic(graph, true, true, 17, 17, false);
			facing = FlxObject.LEFT;
			width = 11;
			centerOffsets(false);
			
			addAnimation("normal", [0]);
			addAnimation("fallinit", [1, 2, 3, 3], 15, false);
			addAnimationCallback(animationCallback);
			addAnimation("fallloop", [4, 5, 6, 7, 8, 9, 10, 11], 15, true);
		}
		
		public function create(x:Number, y:Number, type:Number = NaN) : Moto {
			exists = true;
			alive = true;
			crashedByCar = false;
			facing = FlxObject.LEFT;
			this.x = x;
			this.y = y;
			
			acceleration.y = 0;
			velocity.y = 0;
			velocity.x = 0;
			isCrashed = false;
			playedLock = false;
			
			if (isNaN(type)) {
				movementType = Math.random()<0.5? FOLLOW_CAR: RAM_CAR;
			} else {
				movementType = type;
			}
			
			if (movementType == RAM_CAR) {
				loadAssets(AssetRegistry.moto2Sprite);
				
				FlxVelocity.moveTowardsObject(this, carro, 210);
				orient();
			} else {
				loadAssets(AssetRegistry.motoSprite);
			}
			play("normal", true);
			
			return this;
		}
		
		private function animationCallback(name:String, frameNumber:uint, frameIndex:uint) : void {
			if (name == "fallinit" && frameNumber == 3) {
				play("fallloop");
			}
			
			if (name == "fallloop" && frameNumber == 7) {
				FlxG.play(AssetRegistry.motoHitFloorSnd, 1.4-y/FlxG.height, false, true);
			}
		}
		
		public function crash(byCar:Boolean = false) : void {
			if (isCrashed) return;
			crashedByCar = byCar;
			facing = Math.random() < 0.5? FlxObject.LEFT: FlxObject.RIGHT;
			play("fallinit");
			FlxG.play(AssetRegistry.motoHitSnd, 1, false, true);
			angle = 0;
			isCrashed = true;
			alive = false;
			velocity.x = 0;
			velocity.y = 20;
			acceleration.y = 45;
			immovable = false;
		}
		
		public override function update():void {
			if (!isCrashed && Boolean(carro) && carro.alive) {
				if (movementType == FOLLOW_CAR) {
					if (FlxVelocity.distanceBetween(this, carro) > 30) {
						
						var nearCar : Boolean = false;
						for (var i : Number = 0; i != trafficGroup.members.length; i++) {
							var basic : FlxSprite = trafficGroup.members[i] as FlxSprite;
							if((basic != null) && basic.exists && basic.active) {
								if (FlxVelocity.distanceBetween(this, basic) < 30) {
									FlxVelocity.moveTowardsObject(this, basic, -60);
									nearCar = true;
								}
							}
						}
						if (!nearCar) {
							FlxVelocity.moveTowardsObject(this, carro, 60);
						}
						orient();
						immovable = false;
					} else {
						angle = 0;
						velocity.x = 0;
						velocity.y = 0;
						immovable = true;
					}
				} else if (movementType == RAM_CAR) {
					if (y < FlxG.height + RAM_CAR_DISTANCE-5 && !playedLock) {
						playedLock = true;
						targetLocked.dispatch(this);
					}
					
					if (y < -10) {
						y = 0;
						exists = false;
						alive = false;
					}
				} else if (movementType == RAM_AHEAD_CAR) {
					angle = 0;
					velocity.x = -190;
					velocity.y = 0;
					if (y < -10) {
						y = 0;
						exists = false;
						alive = false;
					}
				}
			} else if (y > FlxG.height+25) {
				y = 0;
				exists = false;
				alive = false;
				exited.dispatch(this);
			}
		}
		
		public function orient() : void {
			angle = Math.max(-20, Math.min(20, FlxVelocity.angleBetween(this, carro, true)+90));
		}
	}
}