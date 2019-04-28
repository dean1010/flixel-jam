package jam.fx.text;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import jam.fx.FX;

/**
 * QuickText is a FlxText object that is recycled and emitted "like" a particle, but it's tweened.
 */
class QuickText extends FlxText
{
	/**
	 * Instantiate a new QuickText object, a FlxText object that is recycled and emitted "like" a particle, but it's tweened.
	 */
	public function new()
	{
		super();

		setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, 0xFF000000, 1, 0);
		wordWrap = false;
	}

	/** 
	 * Emit a QuickText object at specified coordinates.
	 * @param target     FlxObject to focus on.
	 * @param text       Text to display.
	 * @param color      Color of the text. Default is `0xFFFFFFFF`.
	 * @param duration   Duration of the tween in seconds. Default is `1`.
	 * @param scaleTo    Optional amount to scale the text. Default is `1`.
	 * @param yTo        Amount to tween the text `y`. Negative numbers tween up. Default is `0`.
	 * @param keepInView Whether to move the quickText to keep all text in view when near an edge of the screen. Default is `true`.
	 * @param center     Whether to tween to center screen or tween to `yTo`. Default is `false`.
	 * @param size       Size of the text before scaling. Default is `8`.
	 */
	public function emit(target:FlxObject, text:String, color:Int = 0xFFFFFFFF, duration:Float = 1, scaleTo:Float = 1, yTo:Float = 0, keepInView:Bool = true, center:Bool = false, size:Int = 8):Void
	{
		var targetPoint = target.getMidpoint(FlxPoint.get());

		this.color = color;
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

		FlxTween.tween(this,
			{
				x: targetPoint.x,
				y: targetPoint.y,
				"scale.x": scaleTo,
				"scale.y": scaleTo
			}, duration * 0.5)
			.then(
				FlxTween.tween(this, 
				{
					alpha: 0.0, 
					"scale.x": 2 / scaleTo, 
					"scale.y": 2 / scaleTo
				}, duration * 0.5, 
				{
					type: FlxTweenType.ONESHOT, 
					onComplete: tweenComplete.bind(_, targetPoint)
				})
		);
	}

	/**
	 * Cleanup when done with the tween.
	 * @param tween       Tween that is complete.
	 * @param targetPoint The targetPoint needs to be `put()` back in the pool.
	 */
	function tweenComplete(tween:FlxTween, targetPoint:FlxPoint):Void
	{
		kill();
		targetPoint.put();
		if (tween != null) tween.destroy();
	}
}
