package jam.fx.frontends;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.math.FlxPoint;
import jam.fx.particles.TextEmitter;
import jam.fx.particles.TextParticle;

class TextEmitterFE
{
	public function new() {}

	/**
	 * Will launch text particles from a target object.
	 * @param emitter     The text emitter to emit.
	 * @param target      The FlxObject to focusOn and emit text particles.
	 * @param text        The text string. Default is `?`.
	 * @param quantity    How many text particles to emit. Default is `1`.
	 * @param color       Optional color for the text particles. Default is `0xFFFFFFFF` (white).
	 * @param frequency   How often to emit a particle, if > 0. Default is `0` and sets `explode = true`.
	 * @param offset      Optional FlxPoint to offset the emitter.
	 * @return This `FlxEmitter` instance.
	 */
	public function emit(emitter:TextEmitter, target:FlxObject, text:String = "?", quantity:Int = 1, color:Int = 0xFFFFFFFF, frequency:Float = 0, ?offset:FlxPoint):FlxTypedEmitter<TextParticle>
	{
		var explode = frequency > 0 ? false : true;

		if (explode && emitter.emitting)
		{
			emitter.update(0);
		}

		if (color != 0xFFFFFFFF)
		{
			emitter.color.set(color);
		}

		emitter.text = text;

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
