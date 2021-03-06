package jam.fx.frontends;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import jam.fx.text.QuickText;

/**
 * FX frontend for displaying a quickText with `FX.quickText.display(...)`.
 */
class QuickTextFE extends FlxTypedGroup<QuickText>
{
	/**
	 * Instantiates a FlxTypedGroup of QuickText objects.
	 */
	public function new(maxSize:Int = 0)
	{
		super(maxSize);
	}

	/**
	 * Recycle and tween a QuickText object at specified coordinates. See QuickText class for the `display()` function.
	 * @param target   FlxObject to focus on.
	 * @param text     Text to display.
	 * @param duration Duration of the tween in seconds. Default is `1`.
	 * @param color    Color of the text. Default is `0xFFFFFF00`.
	 * @param scaleTo  Optional amount to scale the text. Default is `1.5`.
	 * @param offsetTo FlxPoint to offset the text. Defaults to `(0, -20)`.
	 * @param size     Size of the text before scaling. Default is `8`.
	 */
	public function display(target:FlxObject, text:String = "", duration:Float = 1, color:Int = 0xFFFFFF00, scaleTo:Float = 1.5, ?offsetTo:FlxPoint, size:Int = 8):Void
	{
		var qt = recycle(QuickText);
		toTop(qt);
		qt.display(target, text, duration, color, scaleTo, offsetTo, size);
	}

	/**
	 * Move a groups member to the top by swapping it with the top member.
	 * @param quickText   QuickText object that this groups members are.
	 */
	function toTop(quickText:QuickText):Void
	{
		if (members.indexOf(quickText) != members.length - 1)
		{
			members[members.indexOf(quickText)] = members.pop();
			members.push(quickText);
		}
	}
}
