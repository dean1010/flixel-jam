package jam.fx.frontends;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxObject;
import jam.fx.FX;
import jam.fx.text.QText;
import jam.fx.scenes.Scene;

/**
 * FrontEnd for playing an FX Scene.
 */
class SceneFE
{
	/**
	 * Function for playing an FX Scene.
	 */
	public function new() {}

	/**
	 * Play an FX Scene with emitter(s), sound(s) and/or qText.
	 * @param scene    Scene to play.
	 * @param target   Target object for the scene to emit on and used for sound proximity if player is specified.
	 * @param player   Optional player object used for calculating sound proximity to target.
	 * @param color    Optional color to apply to emitters and qText overriding their color parameters. Default is `0x0`.
	 * @param index    Optional index for playing sounds and to color particles with FX.colors[colorIndex]. Default is `-1`. (ignore)
	 * @param text     Optional index for playing sounds and to color particles with FX.colors[colorIndex]. Default is `-1`. (ignore)
	 */
	public function play(scene:Scene, target:FlxObject, ?player:FlxObject, color:Int = 0x0, index:Int = -1, text:String = "", ?onComplete:Void->Void):Void
	{
		if (onComplete != null)
		{
//			scene.onComplete = onComplete;
		}

		if (scene.emitters != null)
		{
			for (e in scene.emitters)
			{
				var eColor = e.color; // (color == 0x0) ? e.color : color;

				if (e.color == 0x0)
				{
				//	if (index != -1)       eColor = FX.colors[index];
				//	else 
					if (color != 0x0) eColor = color;
				}

				FX.emitter.emit(e.emitter, target, e.quantity, eColor, index, e.frequency);
			}
		}

		if (scene.qText != null)
		{
			var q = scene.qText;
			var qColor = (color == 0x0) ? q.color : color;
			var qText = (text == "") ? q.text : text;

			FX.quickText.emit(target, qText, qColor, q.duration, q.scaleTo, q.yTo, index, q.killScene, q.targetThis, q.synchColor, q.keepInView, q.center, q.size);
		}

		if (scene.sounds != null)
		{
			for (s in scene.sounds)
			{
				FX.sound.play(s.sound, s.volume, target, player, s.random, s.looped, s.group, s.autoDestroy, s.onComplete);
			}
		}

		if (scene.textEmitter != null)
		{
			var t = scene.textEmitter;
			var tColor = t.color; // (color == 0x0) ? e.color : color;

			if (t.color == 0x0)
			{
			//	if (index != -1)       tColor = FX.colors[index];
			//	else 
				if (color != 0x0) tColor = color;
			}

			FX.textEmitter.emit(t.emitter, target, text, t.quantity, tColor, index, t.frequency);
		}
	}
}
