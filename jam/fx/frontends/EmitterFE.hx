package jam.fx.frontends;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import jam.fx.FX;

/**
 * FrontEnd for emitting particles.
 */
class EmitterFE
{
	/**
	 * Function for emitting particles.
	 */
	public function new() {}

	/**
	 * Will emit particles from a target Object.
	 * @param emitter     The emitter to emit.
	 * @param target      The FlxObject to focusOn and emit particles.
	 * @param quantity    How many particles to emit. Default is `0` and will emit all the particles.
	 * @param color       Optional color to tint the particles.
	 * @param index       Optional index color `FX.colors[index]` to use. Default is `-1`. (ignore)
	 * @param frequency   How often to emit a particle, if > 0. Default is `0` and sets `explode = true`.
	 * @return This `FlxEmitter` instance.
	 */
	public function emit(emitter:FlxEmitter, target:FlxObject, quantity:Int = 0, color:Int = -1, index:Int = -1, frequency:Float = 0):FlxTypedEmitter<FlxParticle>
	{
	//	if (index != -1)      emitter.color.set(FX.colors[index]);
	//	else 
		if (color != -1) emitter.color.set(color);

		var explode = frequency > 0 ? false : true;

		if (explode && emitter.emitting)
		{
			emitter.update(0);
		}

		emitter.focusOn(target);

		return emitter.start(explode, frequency, quantity);
	}
}
