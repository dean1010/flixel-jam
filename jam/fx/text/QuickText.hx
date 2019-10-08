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
 * QuickText is a FlxText object that is recycled and tweened.
 */
class QuickText extends FlxText
{
	/**
	 * Instantiate a new QuickText object.
	 */
	public function new()
	{
		super();

		setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, 0xFF000000, 1, 0);
		wordWrap = false;
	}

	/**
	 * Tween the recycled QuickText object.
	 * @param target   FlxObject to focus on.
	 * @param text     Text to display.
	 * @param color    Color of the text. Default is `0xFFFFFFFF`.
	 * @param duration Duration of the tween in seconds. Default is `1`.
	 * @param scaleTo  Optional amount to scale the text. Default is `1.5`.
	 * @param offsetTo FlxPoint to offset the text. Defaults to `(0, -20)`.
	 * @param size     Size of the text before scaling. Default is `8`.
	 */
	public function display(target:FlxObject, text:String, color:Int = 0xFFFFFFFF, duration:Float = 1, scaleTo:Float = 1.5, ?offsetTo:FlxPoint, size:Int = 8):Void
	{
		var targetPoint = target.getMidpoint(FlxPoint.get());
		var screenBounds = FlxPoint.get(FX.worldBounds.width, FX.worldBounds.height);

		this.color = color;
		this.size = size;
		this.text = text;

		if (offsetTo == null)
		{
			offsetTo = FlxPoint.get(0, -20);
		}

		scrollFactor.set(target.scrollFactor.x, target.scrollFactor.y);

		if (target.scrollFactor.x == 0)
		{
			screenBounds.set(FlxG.width, FlxG.height);
		}

		targetPoint.x = targetPoint.x - (width / 2);
		targetPoint.y = targetPoint.y - (height / 2);

		reset(targetPoint.x, targetPoint.y);

		if (targetPoint.x - (((width * scaleTo) - width) / 2) + offsetTo.x < 0)
		{
			targetPoint.x = ((width * scaleTo) - width) / 2;
		}
		else if (targetPoint.x + (((width * scaleTo) + width) / 2) + offsetTo.x > screenBounds.x)
		{
			targetPoint.x = screenBounds.x - ((width * scaleTo) + width) / 2;
		}
		else
		{
			targetPoint.add(offsetTo.x, 0);
		}

		if (targetPoint.y - (((height * scaleTo) - height) / 2) + offsetTo.y < 0)
		{
			targetPoint.y = ((height * scaleTo) - height) / 2;
		}
		else if (targetPoint.y + (((height * scaleTo) + height) / 2) + offsetTo.y > screenBounds.y)
		{
			targetPoint.y = screenBounds.y - ((height * scaleTo) + height) / 2;
		}
		else
		{
			targetPoint.add(0, offsetTo.y);
		}

		screenBounds.put();
		offsetTo.put();

		scale.set(0.1, 0.1);

		FlxTween.tween(this,
			{
				x: targetPoint.x,
				y: targetPoint.y,
				"scale.x": scaleTo,
				"scale.y": scaleTo
			}, duration * 0.6,
			{
				ease: FlxEase.bounceOut
			})
			.wait(0.2)
			.then(
				FlxTween.tween(this, 
				{
					"scale.x": 0.1, 
					"scale.y": 1
				}, duration * 0.2, 
				{
					onComplete: function (tween:FlxTween)
								{
									kill();
									targetPoint.put();
								}
				})
		);
	}
}
