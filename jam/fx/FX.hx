package jam.fx;

import flixel.FlxState;
import jam.fx.frontends.EmitterFE;
import jam.fx.frontends.QuickTextFE;
import jam.fx.frontends.SceneFE;
import jam.fx.frontends.SoundFE;
import jam.fx.frontends.TextEmitterFE;

/**
 * FX - Easy to use class for playing sounds and emitting particles.
 */
class FX
{
	/**
	 * Colors to use in FX color scheme.
	 */
	public static var colors:Array<Int> = [
		0xFF666666,
		0xFFff2d2d,
		0xFFff8000,
		0xFFffcc00,
		0xFFb9ee19,
		0xFF3ef1f6,
		0xFFd082ff,
		0xFF999999
	];

	/** 
	 * Target an object and emit particles with an optional color argument.
	 */
	public static var emitter(default, null):EmitterFE;

	/**
	 * Recycle a Qtext object and emit it "like" a particle, but it's tweened.
	 */
	public static var quickText(default, null):QuickTextFE;

	/**
	 * Function for playing scenes.
	 */
	public static var scene(default, null):SceneFE;
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
	 * Initialize the frontend classes and add the quickText group to the state.
	 */
	public static function init(?state:FlxState):Void
	{
		emitter = new EmitterFE();

		quickText = new QuickTextFE();

		if (state != null)
		{
			state.add(quickText);
		}

		scene = new SceneFE();

		#if FLX_SOUND_SYSTEM
		sound = new SoundFE();
		#end

		textEmitter = new TextEmitterFE();
	}
}
