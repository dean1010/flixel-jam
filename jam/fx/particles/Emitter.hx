package jam.effects.particles;

import flixel.effects.particles.FlxEmitter.FlxEmitterMode;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * Emitter - A FlxEmitter with extras.
 */
class Emitter extends FlxEmitter
{
//    public var onComplete:Void->Void;

	/**
	 * Creates a new `Emitter` object at a specific position.
	 * Does NOT automatically generate or attach particles!
	 * 
	 * @param   x      The x position of the emitter.
	 * @param   y      The y position of the emitter.
	 * @param   size   Optional, specifies a maximum capacity for this emitter. Default is 0 and means no maximum and will just grow.
	 */
	public function new(x:Float = 0, y:Float = 0, size:Int = 0)
	{
		super(x, y, size);

	//	setPosition(x, y);
	//	exists = false;
	}
/*
	override public function kill():Void
	{
		super.kill();
		
	}
*/
}
