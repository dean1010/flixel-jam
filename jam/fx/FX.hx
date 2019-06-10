package jam.fx;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.math.FlxRect;
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
	 * [0xFF666666, 0xFFff2d2d, 0xFFff8000, 0xFFffcc00, 0xFFb9ee19, 0xFF3ef1f6, 0xFFd082ff]
	 * Color array for emitters and other color scheme items, like guns, gems, bullets, etc.
	 */
	public static var colors:Array<Int> = [
		0xFF666666,
		0xFFff2222,
		0xFFff8000,
		0xFFffdd00,
		0xFF99ff00,
		0xFF00ccff,
		0xFFcc33ff
	];

	/**
	 * Takes the place of `FlxG.worldBounds` so we can do `FlxG.worldBounds.set(0, 0)` to 
	 * avoid double overlap problem with `FlxG.overlap()`, and use this with our own 
	 * `inWorldBounds(obj)` function.
	 */
	public static var worldBounds(default, null):FlxRect = FlxRect.get();

	/**
	 * Check if an object is within the `worldBounds` rectangle.
	 * Takes the place of `obj.inWorldBounds()` so we can do `FlxG.worldBounds.set(0, 0)` to 
	 * avoid double overlap problem with `FlxG.overlap()`, and use this function instead.
	 * @param obj Object to check if it is within the `worldBounds` rectangle.
	 * @return `true` or `false`.
	 */
	public static function inWorldBounds(obj:FlxObject):Bool
	{
		return (obj.x + obj.width >= worldBounds.x && 
				obj.y + obj.height >= worldBounds.y && 
				obj.x <= worldBounds.right && 
				obj.y <= worldBounds.bottom);
	}

	/**
	 * Initialize the frontend classes.
	 * @param colorScheme Color array for emitters and color scheme items, like guns, gems, bullets, etc.
	 * @param state       Optional FlxState if you want the quickText FlxGroup added here. 
	 * Typically, you want the quickText group on top of z-order, so add() it accordingly.
	 * Alternately, you can add it in your state with `add(FX.quickText)` at the end of `create()`.
	 */
	public static function init(?colorScheme:Array<Int>, ?state:FlxState):Void
	{
		if (colorScheme != null) colors = colorScheme;
		if (state != null) state.add(quickText);

		emitter = new EmitterFE();
		quickText = new QuickTextFE();
		textEmitter = new TextEmitterFE();
		#if FLX_SOUND_SYSTEM
		sound = new SoundFE();
		#end
	}
}
