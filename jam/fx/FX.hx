package jam.fx;

import flixel.FlxState;
import jam.fx.frontends.EmitterFE;
import jam.fx.frontends.QuickTextFE;
import jam.fx.frontends.SoundFE;
import jam.fx.frontends.TextEmitterFE;

/**
 * FX - Easy to use class for playing sounds and emitting particles.
 */
class FX
{
	/**
	 * Colors to use in the FX color scheme.
	 */
	public static var colors:Array<Int> = [
		0xFFFFFFFF,
		0xFFff2d2d,
		0xFFff8000,
		0xFFffcc00,
		0xFFb9ee19,
		0xFF3ef1f6,
		0xFFd082ff
	];

	/** 
	 * Target an object and emit particles with an optional color and offset.
	 */
	public static var emitter(default, null):EmitterFE;

	/**
	 * QuickText objects are recycled and emitted "like" a particle, but tweened.
	 */
	public static var quickText(default, null):QuickTextFE;

	#if FLX_SOUND_SYSTEM
	/**
	 * Functions for playing sound(s) with additional features.
	 */
	public static var sound(default, null):SoundFE;
	#end

	/** 
	 * Target an object and emit a TextParticle with specified `text` and optional `color` argument.
	 */
	public static var textEmitter(default, null):TextEmitterFE;

	/**
	 * Initialize the frontend classes.
	 * @param colors Optional colors to use in the FX color scheme, overriding the default colors.
	 * @param state  Optional FlxState if you want the quickText FlxGroup added here. 
	 * Typically, you want the quickText group on top of z-order, so add() it accordingly.
	 * Alternately, you can add it in your state with `add(FX.quickText)` at the end of `create()`.
	 */
	public static function init(?colors:Array<Int>, ?state:FlxState):Void
	{
		if (colors != null) FX.colors = colors;
		if (state != null) state.add(quickText);

		emitter = new EmitterFE();
		quickText = new QuickTextFE();
		textEmitter = new TextEmitterFE();
		#if FLX_SOUND_SYSTEM
		sound = new SoundFE();
		#end
	}
}
