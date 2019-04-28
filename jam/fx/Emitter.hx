package jam.fx;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * Emitter for launching a FlxEmitter with optional color and offset.
 */
class Emitter
{
	/**
	 * FlxEmitter to emit or explode.
	 */
	public var emitter:FlxEmitter;

	/**
	 * Instantiate an Emitter object for launching a FlxEmitter with optional color and offset.
	 * @param emitter FlxEmitter to emit or explode.
	 */
	public function new(emitter:FlxEmitter)
	{
		this.emitter = emitter;
	}

	/**
	 * Emit particles from a target object.
	 * @param target    FlxObject to focusOn() and emit particles. If `null` the `offset` point will be targeted.
	 * @param quantity  How many particles to emit. Default is `0` and will emit all the particles.
	 * @param color     Optional color for the particles. Default is `0xFFFFFFFF` (white, or no tint).
	 * @param frequency How often to emit a particle if > 0. Default is `0` and sets `explode = true`.
	 * @param offset    Optional FlxPoint to offset the emitter. If `target` is `null` the emitter will target this point.
	 * @return The `FlxEmitter` instance.
	 */
	public function emit(?target:FlxObject, quantity:Int = 0, color:Int = 0xFFFFFFFF, frequency:Float = 0, ?offset:FlxPoint):FlxTypedEmitter<FlxParticle>
	{
		var explode = frequency == 0 ? true : false;

		if (emitter.emitting) emitter.update(0);

		emitter.color.set(color);

		if (target != null)
		{
			emitter.focusOn(target);

			if (offset != null)
			{
				emitter.x += offset.x;
				emitter.y += offset.y;

				offset.put();
			}
		}
		else if (offset != null)
		{
			emitter.x = offset.x;
			emitter.y = offset.y;

			offset.put();
		}

		return emitter.start(explode, frequency, quantity);
	}
}
