package jam.fx.frontends;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import jam.fx.scenes.Scene;
import jam.fx.text.QText;

class QuickTextFE extends FlxTypedGroup<QText>
{
	/** QuickText - A FlxTypedGroup of recycled QText objects.
	 * @param maxSize   Maximum number of members. Default is 0, meaning no maximum.
	 */
	public function new(maxSize:Int = 0)
	{
		super(maxSize);
	}

	/** Recycle and tween a QText object at specified coordinates. See Qtext class for the real `emit()` function.
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
	public function emit(target:FlxObject, text:String = "", color:Int = -1, duration:Float = 1, scaleTo:Float = 1, yTo:Float = 0, index = -1, ?killScene:Scene, targetThis:Bool = false, synchColor:Bool = false, keepInView:Bool = true, center:Bool = false, size:Int = 8):Void
	{
		var qt = recycle(QText);

		toTop(qt);

		qt.emit(target, text, color, duration, scaleTo, yTo, index, killScene, targetThis, synchColor, keepInView, center, size);
	}

	/**
	 * Move a group member to the top by swapping it with the top member.
	 * @param qt   QText object that this groups members are.
	 */
	private function toTop(qt:QText):Void
	{
		if (members.indexOf(qt) != members.length - 1)
		{
			members[members.indexOf(qt)] = members.pop();
			members.push(qt);
		}
	}
}
