package jam.fx.frontends;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;
import jam.fx.Emitter;

/**
 * FX frontend for emitting particles with `FX.emitter.emit(...)`.
 */
class EmitterFE
{
	public function new() {}

	/**
	 * Emit particles from a target Object.
	 * @param emitter   The Emitter with a FlxEmitter to emit.
	 * @param target    The FlxObject to focusOn and emit particles.
	 * @param quantity  How many particles to emit. Default is `0` and will emit all the particles.
	 * @param color     Optional color for the particles. Default is `0xFFFFFFFF` (white, or no tint).
	 * @param frequency How often to emit particles if > 0. Default is `0` and sets `explode = true`.
	 * @param offset    Optional FlxPoint to offset the emitter.
	 * @return The `FlxEmitter` instance.
	 */
	public function emit(emitter:Emitter, target:FlxObject, quantity:Int = 0, color:Int = 0xFFFFFFFF, frequency:Float = 0, ?offset:FlxPoint):FlxTypedEmitter<FlxParticle>
	{
		var explode = frequency > 0 ? false : true;

		if (explode && emitter.emitter.emitting)
		{
			emitter.emitter.update(0);
		}

		emitter.emitter.color.set(color);

		if (target != null)
		{
			emitter.emitter.focusOn(target);

			if (offset != null)
			{
				emitter.emitter.x += offset.x;
				emitter.emitter.y += offset.y;

				offset.put();
			}
		}
		else if (offset != null)
		{
			emitter.emitter.x = offset.x;
			emitter.emitter.y = offset.y;

			offset.put();
		}

		return emitter.emitter.start(explode, frequency, quantity);
	}
}
