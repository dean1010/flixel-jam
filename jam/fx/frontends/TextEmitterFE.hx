package jam.fx.frontends;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import jam.fx.particles.TextEmitter;
import jam.fx.particles.TextParticle;
import jam.fx.FX;

/**
 * FrontEnd for textEmitter.
 *
 * @author Dean Andreason
 */
class TextEmitterFE
{
	/**
	 * Function for emitting text particles.
	 */
	public function new() {}

	/**
	 * Will launch text particles from a target object.
	 * @param emitter     The text emitter to emit.
	 * @param target      The FlxObject to focusOn and emit text particles.
	 * @param text        The text string. Default is `?`.
	 * @param quantity    How many text particles to emit. Default is `1`.
	 * @param color       Optional color for the text particles.
	 * @param index       Optional index color `FX.colors[index]` to use. Default is `-1`. (ignore)
	 * @param frequency   How often to emit a particle, if > 0. Default is `0` and sets `explode = true`.
	 * @return This `FlxEmitter` instance (nice for chaining stuff together).
	 */
	public function emit(emitter:TextEmitter, target:FlxObject, text:String = "?", quantity:Int = 1, color:Int = -1, index:Int = -1, frequency:Float = 0):FlxTypedEmitter<TextParticle>
	{
		if (index != -1)      emitter.color.set(FX.colors[index]);
		else if (color != -1) emitter.color.set(color);

		emitter.text = text;

		var explode = frequency > 0 ? false : true;

		if (explode && emitter.emitting) emitter.update(0);

		emitter.focusOn(target);

		return emitter.start(explode, frequency, quantity);
	}
}
