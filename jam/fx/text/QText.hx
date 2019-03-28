package jam.fx.text;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import jam.fx.FX;
import jam.fx.scenes.Scene;

/**
 * Qtext is a FlxText object that is recycled and emitted "like" a particle, but it's tweened.
 */
class QText extends FlxText
{
	/**
	 * Create a new Qtext object, a FlxText object that is recycled and emitted "like" a particle, but it's tweened.
	 */
	public function new()
	{
		super();

		wordWrap = false;
	}

	/** Recycle and tween a QText object at specified coordinates.
	 * @param target       FlxObject to focus on.
	 * @param text         Text to display.
	 * @param color        Color of the text. Default is `0xFFFFFFFF`.
	 * @param duration     Duration of the tween in seconds. Default is `1`.
	 * @param scaleTo      Optional amount to scale the text. Default is `1`.
	 * @param yTo          Amount to tween the text `y`. Negative numbers tween up. Default is `0`.
	 * @param index        Optional index color `FX.colors[index]` to use. Default is `-1`. (ignore)
	 * @param killScene    Optional `Scene` to play when the tween completes and `QText` is killed.
	 * @param targetThis   Whether the killScene target is `this` QText, or the original target. Default is `false`.
	 * @param synchColor   Whether to synch the colors of the killScene emitter(s) and/or qText. Default is `true`.
	 * @param keepInView   Whether to move the qText to keep all text in view when near an edge of the screen. Default is `true`.
	 * @param center       Whether to tween to center screen or tween to `yTo`. Default is `false`.
	 * @param size         Size of the text before scaling. Default is `8`.
	 */
	public function emit(target:FlxObject, text:String = "", color:Int = -1, duration:Float = 1, scaleTo:Float = 1, yTo:Float= 0, index = -1, ?killScene:Scene, targetThis:Bool = false, synchColor:Bool = true, keepInView:Bool = true, center:Bool = false, size:Int = 8):Void
	{
		var targetPoint = target.getMidpoint(FlxPoint.get());

		this.color = (index == -1) ? color : FX.colors[index];
		this.size = size;
		this.text = text;
		alpha = 1;
		scale.set(1, 1);

		targetPoint.x = targetPoint.x - (width / 2);
		targetPoint.y = targetPoint.y - (height / 2);

		reset(targetPoint.x, targetPoint.y);

		if (center)
		{
			targetPoint.x = ((FlxG.width - width) / 2) + camera.scroll.x;
			targetPoint.y = ((FlxG.height - height) / 2) + camera.scroll.y;
		}
		else if (keepInView)
		{
			if (targetPoint.x - ((width * scaleTo) - width) / 2 < 0)
			{
				targetPoint.x = ((width * scaleTo) - width) / 2;
			}
			else if (targetPoint.x + (((width * scaleTo) + width) / 2) > FlxG.width)
			{
				targetPoint.x = FlxG.width - ((width * scaleTo) + width) / 2;
			}

			if (targetPoint.y - (((height * scaleTo) - height) / 2) + yTo < 0)
			{
				targetPoint.y = ((height * scaleTo) - height) / 2;
			}
			else if (targetPoint.y + (((height * scaleTo) + height) / 2) + yTo > FlxG.height)
			{
				targetPoint.y = FlxG.height - ((height * scaleTo) + height) / 2;
			}
			else
			{
				targetPoint.y += yTo;
			}
		}
		else
		{
			targetPoint.y += yTo;
		}

		if (targetThis) target = this;

		FlxTween.tween(this, {x: targetPoint.x, y: targetPoint.y, "scale.x": scaleTo, "scale.y": scaleTo}, duration * 0.5).then(
			FlxTween.tween(this, {alpha: 0.0, "scale.x": 2 / scaleTo, "scale.y": 2 / scaleTo}, duration * 0.5,
			{type: FlxTweenType.ONESHOT, onComplete: tweenComplete.bind(_, target, synchColor, killScene, targetPoint)}));
	}

	/**
	 * Cleanup and play an optional killScene once tweens complete.
	 * @param tween         Tween that is complete.
	 * @param target        The target object for the killScene, if there is one.
	 * @param synchColor    Whether to synch the colors of the killScene emitter(s) and/or qText. Default is `true`.
	 * @param killScene     Optional Scene to play when we kill this QText.
	 * @param targetPoint   The targetPoint needs to be `put()` back in the pool.
	 */
	private function tweenComplete(tween:FlxTween, target:FlxObject, synchColor:Bool = true, ?killScene:Scene, targetPoint:FlxPoint):Void
	{
		if (killScene != null)
		{
			if (synchColor)
			{
				FX.scene.play(killScene, target, null, color);
			}
			else
			{
				FX.scene.play(killScene, target);
			}
		}

		kill();

		targetPoint.put();

		if (tween != null)
		{
			tween.destroy();
		}
	}
}
