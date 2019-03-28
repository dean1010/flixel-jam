package flixel.jam.effects.particles;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
//import flixel.jam.effects.particles.Emitter;

/**
 * Emitters - A FlxGroup of public static emitters.
 * Can be used anywhere with Emitters.explode(Emitters.gibs), for example.
 * You can define and add more emitters in this class as needed.
 */
class Emitters extends FlxGroup
{
	/** topLayer is for emitters above all layers. Some emitters are below the foreground layer, but some we want above. The order of the topLayer group and this Emitter class group are added in PlayState#loadLevel() in the proper order. */
//	public static var topLayer:FlxGroup;
/*	
	public static var debris:FlxEmitter;
	public static var block:FlxEmitter;
	public static var crumb:FlxEmitter;
	public static var puff:FlxEmitter;
	public static var skull:FlxEmitter;
	public static var chips:FlxEmitter;
	public static var steps1:FlxEmitter;
	public static var steps2:FlxEmitter;
	public static var steps3:FlxEmitter;
	public static var bodyParts:FlxEmitter;
	
	public static var gems:FlxGroup;
	public static var acid:FlxEmitter;
	public static var bits:FlxEmitter;
	public static var blood:FlxEmitter;
	public static var fire:FlxEmitter;
	public static var fire2:FlxEmitter;
	public static var gas:FlxEmitter;
	public static var gibs:FlxEmitter;
	public static var gold:FlxEmitter;
	public static var shrapnel:FlxEmitter;
	public static var shroom:FlxEmitter;
	public static var trippin:FlxEmitter;
	
	public static var gem:Array<FlxEmitter>;
	public static var number:Array<FlxEmitter>;
	public static var countdown:Array<FlxEmitter>;
	public static var explosion:Array<FlxEmitter>;
	public static var puffs:Array<FlxEmitter>;
*/

//	public static var confetti:Array<FlxEmitter>;
	public var pixels:FlxEmitter;
	public var fireball:FlxEmitter;
	
	public function new(colors:Array<Int>)
	{
		super();

		pixels = new Emitter().loadParticles(new FlxSprite().makeGraphic(2, 2, 0xFFFFFFFF).graphic, 120);
		pixels.launchMode = FlxEmitterMode.SQUARE;
	//	pixels.velocity.set(0, 0, 0, 0, -800, 0, 800, 0);
	//	pixels.acceleration.set(0, 0, 0, 600);
		pixels.alpha.set(1, 1, 0, 0);
		pixels.lifespan.set(1.0);
		
		fireball = new FlxEmitter(); // .loadParticles("images/explosion.png", 50, 16, true);
		fireball.launchMode = FlxEmitterMode.SQUARE;
		fireball.velocity.set(-16, -16, 16, 16);
		fireball.acceleration.set(0);
		fireball.alpha.set(1, 1, 0, 0);
		fireball.scale.set(1, 1, 1, 1, 6, 6, 10, 10);
		fireball.lifespan.set(3.0);
		fireball.maxSize = 100;
		for (i in 0...fireball.maxSize)
		{
			add(new Fireball());
		}
	//	var colors:Array<Int> = Global.colors;
		
	//	confetti = new Array();

//		gem = new Array();
//		number = new Array();
//		puffs = new Array();
//		explosion = new Array();
		
/*			
		for (i in 1...colors.length)
		{
			confetti[i] = new FlxEmitter().loadParticles(new FlxSprite().makeGraphic(2, 2, colors[i]).graphic, 48);
			confetti[i].launchMode = FlxEmitterMode.SQUARE;
			confetti[i].velocity.set(-32, -32, 32, 32);
			confetti[i].alpha.set(1, 1, 0, 0);
			confetti[i].lifespan.set(0.5); // 0.25

			if (i <= 6)
			{
				gem[i] = new FlxEmitter();
				gem[i].launchMode = FlxEmitterMode.CIRCLE;
				gem[i].angularVelocity.set(2880);
				gem[i].angularDrag.set(1440);
				gem[i].speed.set(60, 90, 0, 0);
				gem[i].lifespan.set(1000);
				gem[i].maxSize = 50;
				for (j in 0...gem[i].maxSize)
				{
					gem[i].add(new Gem(i));
					gem[i].color.set(Reg.colors[i]);
				}
				
				number[i] = new FlxEmitter();
				number[i].lifespan.set(1.0);
				number[i].launchMode = FlxEmitterMode.SQUARE;
				number[i].velocity.set(-48, -32, 48, -16);
				number[i].alpha.set(1, 1, 0, 0);
				number[i].maxSize = 10;
				
				for (j in 0...number[i].maxSize)
					number[i].add(new Num(i));
				
				puffs[i] = new FlxEmitter().loadParticles("assets/images/smoke12.png", 50, 0, true);
				puffs[i].launchMode = FlxEmitterMode.SQUARE;
				puffs[i].velocity.set(-16, -16, 16, 16);
				puffs[i].acceleration.set(0);
				puffs[i].alpha.set(1, 1, 0, 0);
				puffs[i].lifespan.set(1.0);
				puffs[i].color.set(colors[i]);
				
				explosion[i] = new FlxEmitter().loadParticles("assets/images/explosion.png", 50, 0, true);
				explosion[i].launchMode = FlxEmitterMode.SQUARE;
				explosion[i].velocity.set(-32, -32, 32, 32);
				explosion[i].acceleration.set(0);
				explosion[i].alpha.set(1, 1, 0, 0);
				explosion[i].lifespan.set(0.5);
				explosion[i].color.set(colors[i]);
			}
		}

		steps1 = new FlxEmitter().loadParticles("assets/images/debris.png", 20, 16, true);
		steps1.launchMode = FlxEmitterMode.SQUARE;
		steps1.velocity.set(-32, -12, 32, 0);
		steps1.acceleration.set(0, 128);
		steps1.alpha.set(1, 1, 0, 0);
		steps1.lifespan.set(0.5);
		
		steps2 = new FlxEmitter().loadParticles("assets/images/smoke6.png", 20, 16, true);
		steps2.launchMode = FlxEmitterMode.SQUARE;
		steps2.velocity.set(0, 0, 0, 0, -8, -8, 8, 0);
		steps2.acceleration.set(0);
		steps2.alpha.set(1, 1, 0, 0);
		steps2.lifespan.set(0.5);
		steps2.color.set(Reg.colors[5], Reg.colors[6]);		
		
		steps3 = new FlxEmitter().loadParticles("assets/images/boots.png", 20, 16, true);
		steps3.launchMode = FlxEmitterMode.SQUARE;
		steps3.velocity.set(-32, -12, 32, 0);
		steps3.acceleration.set(0, 64);
		steps3.alpha.set(1, 1, 0, 0);
		steps3.lifespan.set(0.5);
		
		countdown = new Array();
		
		for (i in 1...4)
		{
			countdown[i] = new FlxEmitter();
			countdown[i].lifespan.set(1);
			countdown[i].launchMode = FlxEmitterMode.SQUARE;
			countdown[i].velocity.set(0, -24, 0, -24);
			countdown[i].alpha.set(1, 1, 0, 0);
			countdown[i].maxSize = 4;
			
			for (j in 0...countdown[i].maxSize)
				countdown[i].add(new NumBomb(i));
		}
		
		acid = new FlxEmitter().loadParticles(new FlxSprite().makeGraphic(2, 2, 0xFFbdde04).graphic, 32);
		acid.launchMode = FlxEmitterMode.SQUARE;
		acid.velocity.set(-48, 0, 48, -48);
		acid.drag.set(-48, 0, 48, -48);
		acid.acceleration.set(0, 32);
		acid.alpha.set(1, 1, 0, 0);
		acid.lifespan.set(1);
		
		block = new FlxEmitter().loadParticles("assets/images/block_debris.png", 32, 16, true);
		block.acceleration.set(0, 240);
block.scale.set(0.5, 0.5, 0.5, 0.5, 1, 1, 2, 2);
		block.alpha.set(1, 1, 0, 0);
		block.lifespan.set(0.5);
		
		blood = new FlxEmitter().loadParticles(new FlxSprite().makeGraphic(2, 2, 0xFFCC0000).graphic, 100);
		blood.launchMode = FlxEmitterMode.SQUARE;
		blood.velocity.set(-48, 0, 48, -48);
		blood.acceleration.set(0, 16);
		blood.alpha.set(1, 1, 0, 0);
		blood.lifespan.set(1);
		
		crumb = new FlxEmitter().loadParticles("assets/images/crumbs.png", 50, 16); // , true);
		crumb.launchMode = FlxEmitterMode.SQUARE;
		crumb.velocity.set(-4, 96, 4, 96);
		crumb.alpha.set(1, 1, 0.5, 0.5);
		crumb.lifespan.set(1.5);
		
		debris = new FlxEmitter().loadParticles("assets/images/debris.png", 50, 16, true);
		debris.acceleration.set(0, 240);
		debris.alpha.set(1, 1, 0, 0);
		debris.lifespan.set(0.5);
		
		fire = new FlxEmitter().loadParticles(new FlxSprite().makeGraphic(2, 2, 0xFFFF9900).graphic, 32);
		fire.launchMode = FlxEmitterMode.SQUARE;
		fire.velocity.set(-24, 8, 24, -32);
		fire.alpha.set(1, 1, 0, 0);
		fire.lifespan.set(0.5);
		
		gas = new FlxEmitter().loadParticles("assets/images/gas.png", 12, 16, true);
		gas.launchMode = FlxEmitterMode.SQUARE;
		gas.velocity.set(-16, 0, 8, 16);
		gas.acceleration.set(0, -48);
		gas.alpha.set(1, 1, 0, 0);
		gas.lifespan.set(1.0);
		
		chips = new FlxEmitter().loadParticles("assets/images/barrel_debris.png", 48, 16, true);
		chips.launchMode = FlxEmitterMode.CIRCLE;
		chips.angularVelocity.set(1440, 2880, 0, 0);
		chips.angularDrag.set(0, 960);
		chips.speed.set(60, 90, 0, 0);
		chips.acceleration.set(0, 180);
	 	chips.alpha.set(1, 1, 0, 0);
		chips.lifespan.set(1.0);
		
		bits = new FlxEmitter().loadParticles("assets/images/bits.png", 50, 16, true);
		bits.launchMode = FlxEmitterMode.SQUARE;
		bits.velocity.set( -128, -128, 128, 128);
		bits.acceleration.set(0);
		bits.alpha.set(1, 1, 0, 0);
		bits.lifespan.set(0.5); // 2
		
		gibs = new FlxEmitter().loadParticles("assets/images/gibs.png", 50, 12, true); // 80
		gibs.launchMode = FlxEmitterMode.SQUARE;
		gibs.velocity.set(-180, -180, 180, 180);
		gibs.acceleration.set(0);
		gibs.alpha.set(1, 1, 0, 0);
		gibs.lifespan.set(0.5); // 2
		
		bodyParts = new FlxEmitter();
		bodyParts.maxSize = 6;
		
		for (i in 0...6)
			bodyParts.add(new BodyParts(i));
			
		bodyParts.launchMode = FlxEmitterMode.CIRCLE;
		bodyParts.angularVelocity.set(1080, 1440, 0, 0);
		bodyParts.angularDrag.set(360, 540, 720, 1080);
		bodyParts.drag.set(0, 0, 60, 60, 240, 240, 480, 480);
		bodyParts.elasticity.set(1.0, 1.0, 0, 0);
		bodyParts.acceleration.set(0, 480, 0, 480);
		bodyParts.velocity.set(-16, -48, 16, 16);
		bodyParts.speed.set(60, 120, 0, 0);
		bodyParts.lifespan.set(10);
		
		gold = new FlxEmitter().loadParticles(new FlxSprite().makeGraphic(1, 1, 0xFFFFCC00).graphic, 24);
		gold.launchMode = FlxEmitterMode.SQUARE;
		gold.velocity.set(-32, -32, 32, 32);
		gold.alpha.set(1, 1, 0, 0);
		gold.lifespan.set(1);
		
		fire2 = new FlxEmitter().loadParticles(new FlxSprite().makeGraphic(2, 2, 0xFFFF9900).graphic, 64);
		fire2.launchMode = FlxEmitterMode.SQUARE;
		fire2.velocity.set(-32, -32, 32, 32);
		fire2.alpha.set(1, 1, 0, 0);
		fire2.lifespan.set(0.5);
		
		puff = new FlxEmitter().loadParticles("assets/images/smoke.png", 100, 16, true);
		puff.launchMode = FlxEmitterMode.SQUARE;
		puff.velocity.set(-16, -16, 16, 16);
		puff.acceleration.set(0);
		puff.alpha.set(1, 1, 0, 0);
		puff.lifespan.set(1.0);
		
		shrapnel = new FlxEmitter();
		shrapnel.launchMode = FlxEmitterMode.SQUARE;
		shrapnel.velocity.set(-256, -256, 256, 256);
		shrapnel.drag.set(-64, -64, 64, 64);
		shrapnel.alpha.set(1, 1, 0, 0);
		shrapnel.elasticity.set(0.75);
		shrapnel.lifespan.set(0.75); // , 1);
		shrapnel.maxSize = 24;
		for (i in 0...shrapnel.maxSize)
			shrapnel.add(new Shrapnel());
		
		skull = new FlxEmitter().loadParticles("assets/images/binary.png", 48, 0, true);
		skull.launchMode = FlxEmitterMode.SQUARE;
		skull.velocity.set(-48, -48, 48, 48);
		skull.alpha.set(1, 1, 0, 0);
		skull.lifespan.set(1);
		
		shroom = new FlxEmitter().loadParticles("assets/images/shroom_emitter.png", 50, 16, true);
		shroom.launchMode = FlxEmitterMode.SQUARE;
		shroom.velocity.set(-16, -16, 16, -24);
		shroom.acceleration.set(0);
shroom.scale.set(0.5, 0.5, 1, 1, 2, 2, 4, 4);
		shroom.alpha.set(1, 1, 0, 0);
		shroom.lifespan.set(3);
		
		shrapnel.allowCollisions = FlxObject.ANY;  // collide with the tilemap and platforms.
		bodyParts.allowCollisions = FlxObject.ANY;  // collide with the tilemap and platforms.

		topLayer = new FlxGroup();
		gems = new FlxGroup();
		
		for (i in 1...gem.length)
		{
			gems.add(gem[i]);
			gem[i].allowCollisions = FlxObject.ANY;      // collide with the tilemap and platforms.
		}
		
		add(gems);
		add(acid);
		add(blood);
		add(shrapnel);
		add(shroom);
		add(trippin);
		
		topLayer.add(puff);
		topLayer.add(bits);
		topLayer.add(gibs);
		topLayer.add(gas);
		topLayer.add(block);
		topLayer.add(chips);
		topLayer.add(crumb);
		topLayer.add(debris);
		topLayer.add(gold);
		topLayer.add(fire);
		topLayer.add(fire2);
		topLayer.add(skull);
		topLayer.add(steps1);
		topLayer.add(steps2);
		topLayer.add(steps3);

		for (i in 1...number.length)
			topLayer.add(number[i]);
		
		for (i in 1...puffs.length)
			topLayer.add(puffs[i]);
		
		for (i in 1...explosion.length)
			topLayer.add(explosion[i]);
		
		for (i in 1...confetti.length)
			
		
		for (i in 1...countdown.length)
			topLayer.add(countdown[i]);
*/

		add(fireball);
		add(pixels);
	}
	
	/**
	 * Will focusOn(object) and emit particles.
	 * @param	emitter     The emitter to emit.
	 * @param	object      The object to focusOn and emit particles from.
	 * @param	frequency   How often to emit a particle. 0 = never emit, 0.1 = 1 particle every 0.1 seconds.
	 * @param	quantity    How many particles to emit. Default is 0 and will emit all the particles.
	 * @param	color       Optional color.
	 * @return  This `FlxEmitter` instance (nice for chaining stuff together).
	 */
	public static function emit(emitter:FlxEmitter, object:FlxObject, frequency:Float = 0.1, quantity:Int = 0, ?color:Int):FlxTypedEmitter<FlxParticle>
	{
		if (color != null) emitter.color.set(color);
		emitter.focusOn(object);
		return emitter.start(false, frequency, quantity);
	}
	
	/**
	 * Will focusOn(object) and emit particles with explode = true.
	 * @param	emitter    The emitter to emit.
	 * @param	object     The object to focusOn and emit particles from.
	 * @param	quantity   How many particles to emit. Default is 0 and will emit all the particles.
	 * @param	color      Optional color.
	 */
	public static function explode0(emitter:FlxEmitter, object:FlxObject, quantity:Int = 0, ?color:Int):Void 
	{
		if (color != null) emitter.color.set(color);
		emitter.focusOn(object);
		emitter.start(true, 0.1, quantity);
	}
	
	/**
	 * Will focusOn(object) and emit particles with explode = true.
	 * @param	emitter    The emitter to emit.
	 * @param	target     The object to focusOn and emit particles from.
	 * @param	quantity   How many particles to emit. Default is 0 and will emit all the particles.
	 * @param	color      Optional color.
	 */
	public function explode(emitter:FlxEmitter, target:Dynamic, quantity:Int = 0, ?color:Int):Void 
	{
		if (Std.is(target, FlxObject)) target = cast(target, FlxObject).getMidpoint(FlxPoint.get());
		if (emitter.emitting) emitter.update(0);
		if (color != null) emitter.color.set(color);
		emitter.setPosition(target.x, target.y);
		emitter.start(true, 0.1, quantity);
		target.put();
	}
/*	
	public function explPoint(emitter:FlxEmitter, point:FlxPoint, quantity:Int = 0, ?color:Int):Void 
	{
		if (emitter.emitting) emitter.update(0);
		if (color != null) emitter.color.set(color);
		emitter.setPosition(point.x, point.y);
		emitter.start(true, 0.1, quantity);
	}
*/	
	/**
	 * Will focusOn(object) and emit particles with explode = true.
	 * @param	emitter    The emitter to emit.
	 * @param	object     The object to focusOn and emit particles from.
	 * @param	quantity   How many particles to emit. Default is 0 and will emit all the particles.
	 * @param	scale      Optional scale.
	 * @param	color      Optional color.
	 */
	public static function explodeScaled(emitter:FlxEmitter, object:FlxObject, quantity:Int = 0, ?scale:Float, ?color:Int):Void 
	{
		if (color != null) emitter.color.set(color);
	//	emitter.scale.set(scale, scale, scale, scale, scale, scale * 0.25);
		emitter.scale.set(1, 1, 1, 1, scale, scale);
		emitter.focusOn(object);
		emitter.start(true, 0.1, quantity);
	}
	
	/**
	 * Will explode a particle, rather than an object, and emit particles with explode = true.
	 * @param	emitter    The emitter to emit.
	 * @param	particle   The particle to explode.
	 * @param	quantity   How many particles to emit. Default is 0 and will emit all the particles.
	 * @param	color      Optional color.
	 */
	public static function explodeParticle(emitter:FlxEmitter, particle:FlxParticle, quantity:Int = 0, ?color:Int):Void 
	{
		if (color != null) emitter.color.set(color);
		emitter.setPosition(particle.getMidpoint().x, particle.getMidpoint().y);
		emitter.start(true, 0.1, quantity);
	}
	
	/**
	 * Emitter will explode on a FlxPoint.
	 * @param	emitter    The emitter to emit.
	 * @param	point      The point to emit particles from.
	 * @param	quantity   How many particles to emit. Default is 0 and will emit all the particles.
	 * @param	color      Optional color.
	 */
	public static function explodePoint(emitter:FlxEmitter, point:FlxPoint, quantity:Int = 0, ?color:Int):Void 
	{
		if (color != null) emitter.color.set(color);
		emitter.setPosition(point.x, point.y);
		emitter.start(true, 0.1, quantity);
	}
	
}