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
	 * @param text     Optional text for qText. Default is `""`.
	 */
	public function play(scene:Scene, target:FlxObject, ?player:FlxObject, color:Int = 0x0, index:Int = -1, text:String = ""):Void
	{
		if (scene.emitters != null)
		{
			for (e in scene.emitters)
			{
				var eColor = e.color;

				if (e.color != 0x0)
				{
					if (index != -1)       eColor = FX.colors[index];
					else if (color != 0x0) eColor = color;
				}

				FX.emitter.emit(e.emitter, target, e.quantity, eColor, e.frequency);
			}
		}

		if (scene.qText != null)
		{
			var q = scene.qText;
			var qColor = q.color;
			var qText = (q.text != "") ? q.text : text;

			if (q.color != 0x0)
			{
				if (index != -1)       qColor = FX.colors[index]; 
				else if (color != 0x0) qColor = color;
			}

			FX.quickText.emit(target, qText, qColor, q.duration, q.scaleTo, q.yTo, q.killScene, q.targetThis, q.synchColor, q.keepInView, q.center, q.size);
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
			var tColor = t.color;
			var tText = (t.text != "") ? t.text : text;
				
			if (t.color != 0x0)
			{
				if (index != -1)       tColor = FX.colors[index]; 
				else if (color != 0x0) tColor = color;
			}

			FX.textEmitter.emit(t.emitter, target, tText, t.quantity, tColor, t.frequency);
		}
	}
}
