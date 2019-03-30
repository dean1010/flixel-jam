package jam.text;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;

class ScrollingText extends FlxSpriteGroup
{
	var scroller:FlxSprite;
	var tf:FlxText;
	var bgColor:Int;
	var borderColor:Int;
	var border:Int;
	var lineStyle:LineStyle = {};
	var bgX:Float = 0;
	var bgY:Float = 0;
	var tfY:Int = 0;
	var delay:Float = 0.2;
	var delayElapsed:Float = 0;
	var step:Int = 20;

	public function new(x:Float = 0, y:Float = 0, width:Float = 128, height:Float = 16, text:String = "", textColor:Int = 0xFFFF0000, bgColor:Int = 0xFF000000, borderColor:Int = 0xFF333333, border:Int = 1, upperCase:Bool = true, smooth:Bool = true, delay:Float = 0.2, step:Int = 20)
	{
		super();

		this.bgColor = bgColor;
		this.borderColor = borderColor;
		this.border = border;

		if (smooth)
		{
			this.delay = 0;
			this.step = 1;
		}
		else
		{
			this.delay = delay;
			this.step = step;
		}

		var textString = (upperCase) ? text.toUpperCase() : text;

		if (border > 0)
		{
			bgX = bgY = border / 2;
			lineStyle = {thickness: border, color: borderColor};
		}

		var textSize = Math.round(height - (border * 2) - 2);

		tf = new FlxText(width, 0, 0, textString, textSize);
		tf.color = textColor;
		tf.autoSize = true;
		tf.wordWrap = false;

		//	tfY = Math.round(((height - tf.textField.textHeight) / 2) - 2 + bgY);

		scroller = new FlxSprite(x, y).makeGraphic(Math.round(width), Math.round(height), bgColor, true);

		add(scroller);
	}

	override public function update(elapsed:Float):Void
	{
		if (scroller.isOnScreen())
		{
			super.update(elapsed);

			if (delay == 0)
			{
				updateText(tf);
			}
			else if (delayElapsed > delay)
			{
				delayElapsed = 0;
				updateText(tf);
			}
			else
			{
				delayElapsed += elapsed;
			}
		}
	}

	private function updateText(tf:FlxText):Void
	{
		if ((tf.x + tf.width) < x)
		{
			tf.x = x + width;
		}
		else
		{
			tf.x -= step;
			FlxSpriteUtil.drawRect(scroller, bgX, bgY, width - border, height - border, bgColor, lineStyle);
			scroller.stamp(tf, Math.round(tf.x), tfY);
		}
	}
}
