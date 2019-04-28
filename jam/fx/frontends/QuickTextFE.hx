package jam.fx.frontends;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import jam.fx.text.QuickText;

/**
 * FX frontend for emitting a quickText with `FX.quickText.emit(...)`.
 */
class QuickTextFE extends FlxTypedGroup<QuickText>
{
	/**
	 * Instantiates a FlxTypedGroup of QuickText objects.
	 * @param maxSize   Maximum number of members. Default is `0`, meaning no maximum.
	 */
	public function new(maxSize:Int = 0)
	{
		super(maxSize);
	}

	/** 
	 * Recycle and tween a QuickText object at specified coordinates. See QuickText class for the `emit()` function.
	 * @param target     FlxObject to focus on.
	 * @param text       Text to display.
	 * @param color      Color of the text. Default is `0xFFFFFFFF`.
	 * @param duration   Duration of the tween in seconds. Default is `1`.
	 * @param scaleTo    Optional amount to scale the text. Default is `1`.
	 * @param yTo        Amount to tween the text `y`. Negative numbers tween up. Default is `0`.
	 * @param keepInView Whether to move the quickText to keep all text in view. Default is `true`.
	 * @param center     Whether to tween to center screen or tween to `yTo`. Default is `false`.
	 * @param size       Size of the text before scaling. Default is `8`.
	 */
	public function emit(target:FlxObject, text:String = "", color:Int = 0xFFFFFFFF, duration:Float = 1, scaleTo:Float = 1, yTo:Float = 0, keepInView:Bool = true, center:Bool = false, size:Int = 8):Void
	{
		var qt = recycle(QuickText);
		toTop(qt);
		qt.emit(target, text, color, duration, scaleTo, yTo, keepInView, center, size);
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
