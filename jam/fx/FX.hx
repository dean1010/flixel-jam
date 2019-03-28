package jam.fx;

import flixel.FlxState;
import jam.fx.frontends.EmitterFE;
import jam.fx.frontends.QuickTextFE;
import jam.fx.frontends.SceneFE;
import jam.fx.frontends.SoundFE;
import jam.fx.frontends.TextEmitterFE;

/** FX - Easy to use class for playing sounds and emitting particles.
 *  * `FX.emitter.emit(...)`
 *    * Emit particles with, or without explode = true and other features.
 *  * `FX.quickText.emit(...)`
 *    * Emit a QText object with a tween.
 *  * `FX.sound.play(...)`
 *    * Play a sound, or Array of sounds in succession, or randomly, with or without sound proximity.
 *  * `FX.scene.play(...)`
 *    * Array of emitter(s), sound(s) and/or quickText to play at once using predefined scenes.
 *  * `FX.textEmitter.emit(...)`
 *    * Emit text particles with, or without explode = true and other features.
 *
 * See the frontend classes for the functions.
 */
class FX
{
	/** Colors to use in FX color scheme. */
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
	 * emitter function that targets an object with an optional color argument.
	 */
	public static var emitter(default, null):EmitterFE;

	/**
	 * Recycle a Qtext object and emit it "like" a particle, but it's tweened.
	 */
	public static var quickText(default, null):QuickTextFE;

	/** scene frontend */
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
	public static function init(state:FlxState):Void
	{
		emitter = new EmitterFE();

		quickText = new QuickTextFE();
		state.add(quickText);

		scene = new SceneFE();

		#if FLX_SOUND_SYSTEM
		sound = new SoundFE();
		#end

		textEmitter = new TextEmitterFE();
	}
}
