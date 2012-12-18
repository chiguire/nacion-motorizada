package {

	import flash.utils.getTimer;
	
	import motomadness.Background;
	import motomadness.Carro;
	import motomadness.CarroTrafico;
	import motomadness.Lanes;
	import motomadness.Moto;
	import motomadness.MotoManager;
	import motomadness.TraficoManager;
	import motomadness.ui.FadingTextManager;
	import motomadness.ui.HUD;
	import motomadness.ui.TargetLockUI;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.plugin.photonstorm.FlxGradient;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	import org.flixel.plugin.photonstorm.FlxVelocity;

	/**
	 *  Moto.as
	 * 
	 *  Created by: Ciro Durán <ciro@elchiguireliterario.com>
	 *  Date: August 14th, 2011.
	 */
	public class PlayState extends FlxState {
		
		public static var elapsedTime:Number = 0;
		private static var lastTime:uint = 0;
		
		public var roadbg : Background;
		public var lanes : Lanes;
		public var motoGroup : MotoManager;
		public var trafficGroup : TraficoManager;
		public var carro : Carro;
		public var bulletGroup : FlxGroup;
		
		public var score : Number = 0;
		private var isInCombo : Boolean = false;
		private var howManyInCombo : int = 0;
		private var longestCombo : int = 0;
		
		public var hudGroup : HUD;
		public var fadingTextGroup : FadingTextManager;
		
		private var _cameraSpeed : Number = 8;
		
		private var timerToCreateTraffic : FlxTimer;
		private var timerToCreateMoto : FlxTimer;
		private var gameOverTimer : FlxTimer;
		private var level : Number = 1;
		private var motosDone : Number = 0;
		
		public function PlayState(): void {
			super();
		}
		
		override public function create():void {
			
			roadbg = new Background(_cameraSpeed);
			lanes = new Lanes(_cameraSpeed, 43, 0);
			carro = new Carro(74,160);
			carro.killed.add(killHandler);
			bulletGroup = new FlxGroup();
			trafficGroup = new TraficoManager();
			motoGroup = new MotoManager(carro, trafficGroup);
			motoGroup.comboEnded.add(endCombo);
			motoGroup.targetLocked.add(displayTargetLocked);
			hudGroup = new HUD(carro);
			fadingTextGroup = new FadingTextManager();
			
			add(roadbg);
			add(lanes);
			add(motoGroup);
			add(trafficGroup);
			add(carro);
			add(bulletGroup);
			add(carro.smokeEmitter);
			add(hudGroup);
			add(fadingTextGroup);
			
			timerToCreateMoto = new FlxTimer();
			timerToCreateMoto.start(2, 0, createMoto);
			
			timerToCreateTraffic = new FlxTimer();
			timerToCreateTraffic.start(4, 0, createTraffic);
			
			gameOverTimer = new FlxTimer();
			
			super.create();
		}
		
		override public function update():void {
			super.update();
			
			var time:uint = getTimer();
			elapsedTime = (time - lastTime) / 1000;
			lastTime = time;
			
			FlxG.overlap(carro, roadbg.sides, null, processCarSidesCollision);
			FlxG.collide(carro, roadbg.topBottom);
			FlxG.overlap(carro, motoGroup, notifyCollision, processCollision);
			FlxG.overlap(carro, trafficGroup, null, processCarTrafficGroup);
			FlxG.collide(trafficGroup, motoGroup, notifyMotoCollision);
			FlxG.collide(trafficGroup, roadbg.sides);
			FlxG.collide(motoGroup, roadbg.sides, notifyMotoCollision);
			FlxG.overlap(motoGroup, null, notifyMotoCollision, processMotoCollision);
			
			if (FlxG.keys.pressed("ESCAPE")) {
				FlxG.switchState(new MenuState());
			}
			
			hudGroup.score = score;
		}
		
		private function processCarTrafficGroup(a:Carro, b:FlxObject) : Boolean {
			var oldVelocity : Number = Math.sqrt(a.velocity.x*a.velocity.x+a.velocity.y*a.velocity.y);
			var angle : Number = FlxU.getAngle(a.getMidpoint(), b.getMidpoint());
			
			var separatedX:Boolean = FlxObject.separateX(a,b);
			var separatedY:Boolean = FlxObject.separateY(a,b);
			if (separatedX || separatedY) {
				if (oldVelocity > 50) {
					
					a.push(angle+Math.PI, 25, 50);
					//b.push(angle, 25, 50);
					if (!a.flickering) {
						a.hurt(10);
						a.flicker(2);
						FlxG.play(AssetRegistry.bocinaSnd, 1, false, true);
					}
				} else if (oldVelocity > 50) {
					
					a.push(angle+Math.PI, 25, 50);
					//b.push(angle, 25, 50);
					if (!a.flickering) {
						a.hurt(10);
						a.flicker(2);
						FlxG.play(AssetRegistry.bocinaSnd, 1, false, true);
					}
				}
			}
			return separatedX || separatedY;
		}
		
		private function processCarSidesCollision(a:Carro, b:FlxObject):Boolean
		{
			var oldVelocity : Number = Math.abs(a.velocity.x);
			var separatedX:Boolean = FlxObject.separateX(a,b);
			var separatedY:Boolean = FlxObject.separateY(a,b);
			if (separatedX || separatedY) {
				if (b == roadbg.leftBorde && oldVelocity > 50) {
					
					a.push(0, 25, 50);
					if (!a.flickering) {
						a.hurt(10);
						a.flicker(2);
						FlxG.play(AssetRegistry.motoHitSnd, 1, false, true);
					}
				} else if (b == roadbg.rightBorde && oldVelocity > 50) {
					
					a.push(Math.PI, 25, 50);
					if (!a.flickering) {
						a.hurt(10);
						a.flicker(2);
						FlxG.play(AssetRegistry.motoHitSnd, 1, false, true);
					}
				}
			}
			return separatedX || separatedY;
		}
		
		private function notifyCollision(a:FlxObject, b:FlxObject) : void {
			var moto : Moto;
			var carro : Carro;
			
			if (b is Moto) {
				moto = b as Moto;
			} else if (a is Moto) {
				moto = a as Moto;
			} else return;
			
			if (b is Carro) {
				carro = b as Carro;
			} else if (a is Carro) {
				carro = a as Carro;
			}
			
			if (!moto.isCrashed) {
				var angle : Number = FlxVelocity.angleBetween(moto, carro, false);
				carro.push(angle);
				
				if (!isInCombo) {
					isInCombo = true;
					howManyInCombo = 1;
				}
				
				moto.crash();
				incrementMotos();
				
				if (moto.movementType == Moto.RAM_CAR && !carro.flickering) {
					carro.hurt(25);
					carro.flicker(2);
				} else {
					fadingTextGroup.create(moto.x, moto.y, "+50");
					score += 50;
				}
			}
		}
		
		private function processCollision(a:FlxObject, b:FlxObject) : Boolean {
			var car : Carro = a as Carro;
			var motoB : Moto = b as Moto;
			var motoA : Moto = a as Moto;
			
			if (Boolean(carro) && Boolean(motoB) &&
				carro.alive && motoB.alive) {
				return FlxObject.separate(a, b);
			}
			
			if (Boolean(motoA) && Boolean(motoB)) {
				return processMotoCollision(a, b);
			}
			return false;
		}
		
		private function notifyMotoCollision(a:FlxObject, b:FlxObject) : void {
			var m1 : Moto;
			var m2 : Moto;
			var incr : int;
			if (a is Moto && b is Moto) {
				m1 = Moto(a);
				m2 = Moto(b);
				
				if (m1.movementType == Moto.RAM_CAR && !m2.isCrashed) {
					m2.crash(m1.crashedByCar);
					m1.crash(m2.crashedByCar);
					incrementMotos();
				} else if (m2.movementType == Moto.RAM_CAR && !m1.isCrashed) {
					m1.crash(m2.crashedByCar);
					m2.crash(m1.crashedByCar);
					incrementMotos();
				}
				
				if (m1.isCrashed && !m2.isCrashed) {
					m2.crash(true);
					incrementMotos();
					countCombo();
					if (howManyInCombo > 0) {
						incr = howManyInCombo*50;
						score += incr;
						fadingTextGroup.create(m2.x, m2.y, "+"+incr);
					}
				}
				if (!m1.isCrashed && m2.isCrashed) {
					m1.crash(true);
					incrementMotos();
					countCombo();
					if (howManyInCombo > 0) {
						incr = howManyInCombo*50; 
						score += incr;
						fadingTextGroup.create(m1.x, m1.y, "+"+incr);
					}
				}
			} else {
				if (a is Moto && !Moto(a).isCrashed) {
					Moto(a).crash();
					incrementMotos();
					
				} else if (b is Moto && !Moto(b).isCrashed) {
					Moto(b).crash();
					incrementMotos();
				}
			}
		}
		
		private function processMotoCollision(a:FlxObject, b:FlxObject) : Boolean {
			var motoA : Moto = a as Moto;
			var motoB : Moto = b as Moto;
			
			if (Boolean(motoA) && Boolean(motoB) &&
				motoA.alive && motoB.alive) {
				FlxObject.separate(a, b);
			}
			return true;
		}
		
		private function countCombo() : void {
			if (isInCombo) {
				howManyInCombo++;
				if (howManyInCombo >= 2) {
					hudGroup.setCombo(howManyInCombo);
				}
			}
		}
		
		private function endCombo() : void {
			if (isInCombo) {
				if (howManyInCombo > 1) {
					if (howManyInCombo > longestCombo) {
						longestCombo = howManyInCombo;
						hudGroup.highestCombo = longestCombo;
					}
					hudGroup.fadeCombo();
					FlxG.play(AssetRegistry.endComboSound);
				}
				howManyInCombo = 0;
				isInCombo = false;
			}
		}
		
		private function displayTargetLocked(m:Moto) : void {
			hudGroup.targetLock.setTargetLock(m.x);
			FlxG.play(AssetRegistry.targetLockSnd, 1, false, true);
		}
		
		public function createMoto(timer:FlxTimer) : void {
			var m : Moto;
			var l : Number = Math.min(level, 4);
			for (var i : int = 0; i != l; i++) {
				if (Math.random() < 0.8) {
					m = motoGroup.create(FlxG.width/2+(FlxG.width-50)/2*(Math.random()-0.5), FlxG.height+5, Moto.FOLLOW_CAR);
					m.carro = carro;
				} else {
					m = motoGroup.create(carro.x, FlxG.height+Moto.RAM_CAR_DISTANCE, Moto.RAM_CAR);
					m.carro = carro;
				}
			}
		}
		
		public var xlanes : Array = [24,49,74,99,124];
		
		public function createTraffic(timer:FlxTimer) : void {
			var c : CarroTrafico;
			c = trafficGroup.create(xlanes[int(FlxG.random()*6)], -30);
		}
		
		public function incrementMotos() : void {
			motosDone++;
			if (motosDone != 0 && motosDone % 25 == 0) {
				level++;
				hudGroup.level = level;
			}
		}
		
		override public function destroy():void {
			FlxScrollZone.clear();
		}
		
		public function set cameraSpeed(y:Number) : void {
			_cameraSpeed = y;
			FlxScrollZone.updateY(lanes, y);
			roadbg.cameraSpeed = y; 
		}
		
		public function get cameraSpeed() : Number {
			return _cameraSpeed;
		}
		
		public function killHandler() : void {
			FlxG.play(AssetRegistry.bigExplosionSound, 1, false, true);
			gameOverTimer.start(5, 1, finishPlay);
		}
		
		public function finishPlay(timer:FlxTimer) : void {
			FlxG.fade(0, 1, finishPlayFadeHandler); 
		}
		
		public function finishPlayFadeHandler() : void {
			FlxG.switchState(new MenuState());
		}
	}
}

