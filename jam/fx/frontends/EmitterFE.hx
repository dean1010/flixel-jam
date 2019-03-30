package jam.fx.frontends;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;

class EmitterFE
{
	public function new() {}

	/**
	 * Will emit particles from a target Object.
	 * @param emitter     The emitter to emit.
	 * @param target      The FlxObject to focusOn and emit particles.
	 * @param quantity    How many particles to emit. Default is `0` and will emit all the particles.
	 * @param color       Optional color for the particles. Default is `0x0` (transparent).
	 * @param frequency   How often to emit a particle, if > 0. Default is `0` and sets `explode = true`.
	 * @param offset      Optional FlxPoint to offset the emitter.
	 * @return This `FlxEmitter` instance.
	 */
	public function emit(emitter:FlxEmitter, target:FlxObject, quantity:Int = 0, color:Int = 0x0, frequency:Float = 0, ?offset:FlxPoint):FlxTypedEmitter<FlxParticle>
	{
		var explode = frequency > 0 ? false : true;

		if (explode && emitter.emitting)
		{
			emitter.update(0);
		}

		if (color != 0x0)
		{
			emitter.color.set(color);
		}

		emitter.focusOn(target);

		if (offset != null)
		{
			emitter.x += offset.x;
			emitter.y += offset.y;
			
			offset.put();
		}

		return emitter.start(explode, frequency, quantity);
	}
}
