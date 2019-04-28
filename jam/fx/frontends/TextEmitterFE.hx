package jam.fx.frontends;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.math.FlxPoint;
import jam.fx.TextEmitter;
import jam.fx.text.TextParticle;

/**
 * FX frontend for emitting text particles with `FX.textEmitter.emit(...)`.
 */
class TextEmitterFE
{
	public function new() {}

	/**
	 * Will launch text particles from a target object.
	 * @param emitter   The TextEmitter with a TxtEmitter to emit.
	 * @param target    The FlxObject to focusOn and emit text particles.
	 * @param text      The text string. Default is `""`.
	 * @param quantity  How many text particles to emit. Default is `1`.
	 * @param color     Optional color for the text particles. Default is `0xFFFFFFFF` (white).
	 * @param frequency How often to emit particles if > 0. Default is `0` and sets `explode = true`.
	 * @param offset    Optional FlxPoint to offset the emitter.
	 * @return This `FlxEmitter` instance.
	 */
	public function emit(emitter:TextEmitter, target:FlxObject, text:String, quantity:Int = 1, color:Int = 0xFFFFFFFF, frequency:Float = 0, ?offset:FlxPoint):FlxTypedEmitter<TextParticle>
	{
		var explode = frequency > 0 ? false : true;

		if (explode && emitter.emitter.emitting)
		{
			emitter.emitter.update(0);
		}

		emitter.emitter.color.set(color);

		emitter.emitter.text = text;

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
