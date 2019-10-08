package jam.fx;

import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.math.FlxPoint;
import jam.fx.text.TxtEmitter;
import jam.fx.text.TextParticle;

/**
 * Emitter for emitting text particles with optional color and offset.
 */
class TextEmitter
{
	/**
	 * TxtEmitter to emit or explode.
	 */
	public var emitter:TxtEmitter;

	/**
	 * Instantiate a TextEmitter object.
	 * @param emitter TxtEmitter to emit or explode.
	 */
	public function new(emitter:TxtEmitter)
	{
		this.emitter   = emitter;
	}

	/**
	 * Emit text particles from a target object.
	 * @param target    The FlxObject to focusOn and emit text particles. If `null` the `offset` point will be targeted.
	 * @param text      The text string.
	 * @param color     Optional color for the text particles. Default is `0xFFFFFFFF` (white).
	 * @param quantity  How many text particles to emit. Default is `1`.
	 * @param frequency How often to emit a particle, if > 0. Default is `0` and sets `explode = true`.
	 * @param offset    Optional FlxPoint to offset the emitter. If `target` is `null` the emitter will target this point.
	 * @return The `TxtEmitter` instance.
	 */
	public function emit(?target:FlxObject, text:String, color:Int = 0xFFFFFFFF, quantity:Int = 1, frequency:Float = 0, ?offset:FlxPoint):FlxTypedEmitter<TextParticle>
	{
		var explode = frequency > 0 ? false : true;

		if (emitter.emitting) emitter.update(0);

		emitter.color.set(color);
		emitter.text = text;

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

	public function destroy():Void
	{
		emitter.destroy();
	}
}
