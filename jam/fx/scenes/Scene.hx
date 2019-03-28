package jam.fx.scenes;

import flixel.FlxG;
//import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxSoundGroup;
import jam.fx.particles.TextEmitter;
import jam.fx.text.QText;

/** 
 * Scene object with emitter(s) and/or sound(s) to play.
 */
class Scene // extends FlxBasic
{
//	public var onComplete:Void->Void;

	/** Emitter(s) data array. */
	public var emitters:Array<EmitterData>;

	/** Sound(s) data array. */
	public var sounds:Array<SoundData>;

	/** QText data. */
	public var qText:QTextData;

	/** TextEmitter data. */
	public var textEmitter:TextEmitterData;

	/** 
	 * Create and setup a Scene object with emitter(s), sound(s) and qText to play.
	 * @param emitters      Optional Array of EmitterData for this scene.
	 * @param sounds        Optional Array of SoundData for this scene.
	 * @param qText         Optional QTextData for this scene.
	 * @param textEmitter   Optional TextEmitterData for this scene.
	 */
	public function new(?emitters:Array<EmitterData>, ?sounds:Array<SoundData>, ?qText:QTextData, ?textEmitter:TextEmitterData)
	{
//		super();

		if (emitters != null)
		{
			for (e in emitters)				// Assign default values
			{
				if (e.color == null)			e.color = -1;
				if (e.frequency == null)		e.frequency = 0;
				if (e.quantity == null)			e.quantity = 0;
			}
		}
		
		if (textEmitter != null)			// Assign default values
		{
			if (textEmitter.color == null)		textEmitter.color = -1;
			if (textEmitter.frequency == null)	textEmitter.frequency = 0;
			if (textEmitter.quantity == null)	textEmitter.quantity = 0;
			if (textEmitter.text == null)		textEmitter.text = "?";
		}
		
		if (sounds != null)
		{
			for (s in sounds)				// Assign default values
			{
				if (s.random == null)			s.random = true;
				if (s.volume == null)			s.volume = 1;
				if (s.autoDestroy == null)		s.autoDestroy = true;
				if (s.looped == null)			s.looped = false;
			}
		}
		
		if (qText != null)					// Assign default values
		{
			if (qText.center == null)			qText.center = false;
			if (qText.color == null)			qText.color = -1;
			if (qText.duration == null)			qText.duration = 1;
			if (qText.keepInView == null)		qText.keepInView = true;
			if (qText.scaleTo == null)			qText.scaleTo = 1;
			if (qText.text == null)				qText.text = "?";
			if (qText.size == null)				qText.size = 8;
			if (qText.targetThis == null)		qText.targetThis = false;
			if (qText.synchColor == null)		qText.synchColor = true;
			if (qText.yTo == null)				qText.yTo = 0;
		}

		this.emitters = emitters;
		this.sounds = sounds;
		this.qText = qText;
		this.textEmitter = textEmitter;
	}

/*
	var complete = false;
	var print = false;
	var sPrint = false;
	var ePrint = false;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	
		trace("wtf");

		if (!print)
		{
			print = true;
			trace("here");
		}


		for (e in emitters)
		{
			complete = false;
			if (e.emitter.alive)
			{
				return;
			}
			complete = true;
		}

		if (!ePrint)
		{
			ePrint = true;
			trace("emitters complete 2");
		}

		if (complete)
		{
			trace("complete!");
			kill();
			onComplete();
		}
	}
*/

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
	var text:String;

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
	/** Sound to play. */
	var sound:String;

	/** Optional volume to play the sound. Default is `1`. */
	var ?volume:Float;

	/** Optional. Whether to play a random sound from Array when `sound` is a CSV. Default is `true` but will be ignored if not a CSV. */
	var ?random:Bool;

	/** Whether to `put()` the Point back in the pool. Default is `true`. */
//	var ?putPoint:Bool;

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
	/** Emitter to emit or explode. */
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
