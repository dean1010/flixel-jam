package jam.fx.scenes;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxSoundGroup;
import jam.fx.particles.TextEmitter;
import jam.fx.text.QText;

/** 
 * Scene object to define a scene with emitter(s), sound(s), quickText and/or textEmitter. 
 * 
 * Example:
```
var myScene = new Scene(
	[
		{emitter: emitters.blood, quantity: 10},
		{emitter: emitters.pixels, quantity: 10, color: 0xFFFFFF00}
	], 
	[
		{sound: "hurt", volume: 0.5}
	], 
	{text: "Ow!", color: 0xFFFFFF00, duration: 0.5, scaleTo: 1.5}
);

FX.scene.play(myScene, target, player);

```
 */
class Scene
{
	/** Emitter(s) data array. */
	public var emitters(default, set):Array<EmitterData>;

	/** Sound(s) data array. */
	public var sounds(default, set):Array<SoundData>;

	/** QText data. */
	public var qText(default, set):QTextData;

	/** TextEmitter data. */
	public var textEmitter(default, set):TextEmitterData;

	/** 
	 * Create and setup a Scene object with optional emitter(s), sound(s), qText or textEmitter to play.
	 *
	 * @param emitters      Optional Array of EmitterData for this scene.
	 * @param sounds        Optional Array of SoundData for this scene.
	 * @param qText         Optional QTextData for this scene.
	 * @param textEmitter   Optional TextEmitterData for this scene.
	 */
	public function new(?emitters:Array<EmitterData>, ?sounds:Array<SoundData>, ?qText:QTextData, ?textEmitter:TextEmitterData)
	{
		set_emitters(emitters);
		set_sounds(sounds);
		set_qText(qText);
		set_textEmitter(textEmitter);
	}

	function set_emitters(emitters:Array<EmitterData>):Array<EmitterData>
	{
		if (emitters != null)
		{
			for (e in emitters)
			{
				if (e.color == null)	 e.color = 0xFFFFFFFF;
				if (e.frequency == null) e.frequency = 0;
				if (e.quantity == null)	 e.quantity = 0;
			}
		}

		return this.emitters = emitters;
	}

	function set_sounds(sounds:Array<SoundData>):Array<SoundData>
	{
		if (sounds != null)
		{
			for (s in sounds)
			{
				if (s.random == null)	   s.random = true;
				if (s.volume == null)	   s.volume = 1;
				if (s.autoDestroy == null) s.autoDestroy = true;
				if (s.looped == null)	   s.looped = false;
			}
		}

		return this.sounds = sounds;
	}

	function set_qText(qText:QTextData):QTextData
	{
		if (qText != null)
		{
			if (qText.center == null)	  qText.center = false;
			if (qText.color == null)	  qText.color = 0xFFFFFFFF;
			if (qText.duration == null)	  qText.duration = 1;
			if (qText.keepInView == null) qText.keepInView = true;
			if (qText.scaleTo == null)	  qText.scaleTo = 1;
			if (qText.text == null)		  qText.text = "";
			if (qText.size == null)		  qText.size = 8;
			if (qText.targetThis == null) qText.targetThis = false;
			if (qText.synchColor == null) qText.synchColor = true;
			if (qText.yTo == null)		  qText.yTo = 0;
		}
		
		return this.qText = qText;
	}

	function set_textEmitter(textEmitter:TextEmitterData):TextEmitterData
	{
		if (textEmitter != null)
		{
			if (textEmitter.color == null)	   textEmitter.color = 0xFFFFFFFF;
			if (textEmitter.frequency == null) textEmitter.frequency = 0;
			if (textEmitter.quantity == null)  textEmitter.quantity = 0;
			if (textEmitter.text == null)	   textEmitter.text = "";
		}

		return this.textEmitter = textEmitter;
	}
}

/** Emitter data for a scene. */
typedef EmitterData =
{
	/** Emitter to emit or explode. */
	var emitter:FlxEmitter;

	/** Optional quantity of particles to emit. Default is `0`, or all the particles. */
	var ?quantity:Int;

	/** Optional color to make the particles. Default is `-1`. (white, no tint) */
	var ?color:Int;

	/** Optional frequency to emit particles. Default is `0`. */
	var ?frequency:Float;
}

/** QText data for a scene. */
typedef QTextData =
{
	/** Text to display. */
	var ?text:String;

	/** Optional color to make the text. Default is `-1` (white, no tint). */
	var ?color:Int;

	/** Optional tween duration. Default is `1`. */
	var ?duration:Float;

	/** Optionally move the qText to force all text to be in view when near an edge. Default is `true`. */
	var ?keepInView:Bool;

	/** Optional amount to scale the text. Default is `1`. */
	var ?scaleTo:Float;

	/** Optional amount to tween the text `y`. Default is `0`. */
	var ?yTo:Float;

	/** Optional killScene to play. Default is `null`. */
	var ?killScene:Scene;

	/** Whether the killScene target is `this` QText, or the original target. Default is `false`. */
	var ?targetThis:Bool;

	/** Optionally synch the killScene emitter and qText colors. Default is `true`. */
	var ?synchColor:Bool;

	/** Optionally center the text to the screen. Default is `false`. */
	var ?center:Bool;

	/** Optional size of the text. Default is `8`. */
	var ?size:Int;
}

/** Sound data for a scene. */
typedef SoundData =
{
	/** Sound(s) to play. */
	var sound:String;

	/** Optional volume to play the sound. Default is `1`. */
	var ?volume:Float;

	/** Optional. Whether to play a random sound from Array when `sound` is a CSV. Default is `true` but will be ignored if not a CSV. */
	var ?random:Bool;

	/** Whether to loop the sound. Default is `false`. */
	var ?looped:Bool;

	/** Optional sound group to add the sound to. Default is `null` and defaults to `FlxG.sound.defaultSoundGroup`. */
	var ?group:FlxSoundGroup;

	/** Whether to destroy the sound when finished playing. Default is `true`. */
	var ?autoDestroy:Bool;

	/** Optional function to call when the sound completes. */
	var ?onComplete:Void->Void;
}

/** TextEmitter data for a scene. */
typedef TextEmitterData =
{
	/** TextEmitter to emit or explode. */
	var emitter:TextEmitter;

	/** Optional quantity of particles to emit. Default is `0`, or all the particles. */
	var ?quantity:Int;

	/** Optional color to make the particles. Default is `-1`. (white, no tint) */
	var ?color:Int;

	/** Optional frequency to emit particles. Default is `0`. */
	var ?frequency:Float;

	/** Text string to emit. Default is `"?"`. */
	var ?text:String;
}
