package {
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxScrollZone;
	
	/**
	 *  Moto.as
	 * 
	 *  Created by: Ciro Durán <ciro@elchiguireliterario.com>
	 *  Date: August 14th, 2011.
	 */
	public class MenuState extends FlxState {		
		public var titleS : FlxSprite;
		
		public var roadS : FlxSprite;
		
		public var moto1S : FlxSprite;
		public var moto2S : FlxSprite;
		
		public var matasS : FlxSprite;
		
		public var fondoS : FlxSprite;
		
		public var defensa1S : FlxSprite;
		
		public var defensa2S : FlxSprite;
		
		public var defensa3S : FlxSprite;
		
		public var ciudades1S : FlxSprite;
		
		public var ciudades2S : FlxSprite;
		
		public var car1S : FlxSprite;
		public var car2S : FlxSprite;
		
		public var copyrightS : FlxSprite;
		
		private var camera : FlxCamera;
		
		override public function create():void {
			
			fondoS = new FlxSprite(0, 0, AssetRegistry.fondo);
			FlxScrollZone.add(fondoS, new Rectangle(0, 0, fondoS.width, fondoS.height), -0.1, 0, true);
			ciudades2S = new FlxSprite(0, 97, AssetRegistry.ciudades2);
			FlxScrollZone.add(ciudades2S, new Rectangle(0, 0, ciudades2S.width, ciudades2S.height), -0.2, 0, true, true);
			ciudades1S = new FlxSprite(0, 64, AssetRegistry.ciudades1);
			FlxScrollZone.add(ciudades1S, new Rectangle(0, 0, ciudades1S.width, ciudades1S.height), -0.3, 0, true, true);
			defensa3S = new FlxSprite(0, 145, AssetRegistry.defensa3);
			FlxScrollZone.add(defensa3S, new Rectangle(0, 0, defensa3S.width, defensa3S.height), -0.7, 0, true, true);
			defensa2S = new FlxSprite(0, 173, AssetRegistry.defensa2);
			FlxScrollZone.add(defensa2S, new Rectangle(0, 0, defensa2S.width, defensa2S.height), -0.8, 0, true, true);
			matasS = new FlxSprite(0, 179, AssetRegistry.matas);
			FlxScrollZone.add(matasS, new Rectangle(0, 0, matasS.width, matasS.height), -0.85, 0, true, true);
			defensa1S = new FlxSprite(0, 186, AssetRegistry.defensa1);
			FlxScrollZone.add(defensa1S, new Rectangle(0, 0, defensa1S.width, defensa1S.height), -0.9, 0, true, true);			roadS = new FlxSprite(0, 226, AssetRegistry.road);
			FlxScrollZone.add(roadS, new Rectangle(0, 0, roadS.width, roadS.height), -1, 0, true, true);			moto2S = new FlxSprite(0, 155, AssetRegistry.moto);			car1S = new FlxSprite(0, 149, AssetRegistry.car);			car2S = new FlxSprite(0, 149, AssetRegistry.car);			moto1S = new FlxSprite(0, 194, AssetRegistry.moto);			titleS = new FlxSprite(4, 2, AssetRegistry.title);
			copyrightS = new FlxSprite(2, FlxG.height-13, AssetRegistry.copyrightSpr);
			
			add(fondoS);
			add(ciudades2S);
			add(ciudades1S);
			add(defensa3S);
			add(defensa2S);
			add(matasS);
			add(defensa1S);
			add(roadS);
			add(moto2S);
			add(car1S);
			add(car2S);
			add(moto1S);
			add(titleS);
			add(copyrightS);
			
			car1S.x = -30;
			car1S.velocity.x = -100;
			
			car2S.x = car1S.x + car1S.width + 10;
			car2S.velocity.x = -100;
			
			moto1S.x = -moto1S.width - 100*Math.random();
			moto1S.velocity.x = 250 + (Math.random()-0.5)*200;
			
			moto2S.x = -moto2S.width - 100*Math.random();
			moto2S.velocity.x = 250 + (Math.random()-0.5)*200;
			
			FlxG.mouse.show();
		}
		override public function update():void {
			super.update();
			if(FlxG.mouse.justPressed()) {
				FlxG.mouse.hide();
				FlxG.switchState(new IntroState());
			}
			
			if (car1S.x < - car1S.width - 10) {
				car1S.x = car2S.x + car2S.width + 10 + 30*Math.random();
			}
			
			if (car2S.x < - car2S.width - 10) {
				car2S.x = car1S.x + car1S.width + 10 + 30*Math.random();
			}
			
			if (moto1S.x > FlxG.width + 10) {
				moto1S.x = - moto1S.width - 100*Math.random();
				moto1S.velocity.x = 250 + (Math.random()-0.5)*200;
			}
			
			if (moto2S.x > FlxG.width + 10) {
				moto2S.x = - moto2S.width - 100*Math.random();
				moto2S.velocity.x = 250 + (Math.random()-0.5)*200;
			}
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the scrolling image from the plugin, otherwise resources will get messed right up after a while
			FlxScrollZone.clear();
			
			super.destroy();
		}
	}
}
