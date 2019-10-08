package jam.fx.text;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;

/**
 * A scrolling text ticker.
 */
class TextTicker extends FlxSpriteGroup
{
	var ticker:FlxSprite;
	var tf:FlxText;
	var stampY:Int = 0;
	var bgX:Float = 0;
	var bgY:Float = 0;
	var bgColor:Int;
	var border:Int;
	var borderColor:Int;
	var lineStyle:LineStyle = {};

	/**
	 * Instantiate a new TextTicker.
	 * @param x           X coordinate of the TextTicker.
	 * @param y           Y coordinate of the TextTicker.
	 * @param width       Width of the TextTicker.
	 * @param height      Height of the TextTicker.
	 * @param text        Text message to scroll.
	 * @param textColor   Color of the scrolling text. Default is `0xFFFFFFFF`.
	 * @param bgColor     Background color of the TextTicker. Default is `0xFF000000`.
	 * @param borderColor Border color outlining the TextTicker. Default is `0xFF666666`.
	 * @param border      Border thickness. Default is `1`.
	 * @param upperCase   Whether or not to convert the text string to all uppercase. Default is `true`.
	 */
	public function new(x:Float = 0, y:Float = 0, width:Float = 96, height:Float = 14, text:String, textColor:Int = 0xFFFFFFFF, bgColor:Int = 0xFF000000, borderColor:Int = 0xFF666666, border:Int = 1, upperCase:Bool = true)
	{
		super();

		this.bgColor = bgColor;
		this.borderColor = borderColor;
		this.border = border;

		var textString = (upperCase) ? text.toUpperCase() : text;

		if (border > 0)
		{
			bgX = bgY = border / 2;
			lineStyle = {thickness: border, color: borderColor};
		}

		var textSize = Math.round(height - (border * 2) - 3);

		tf = new FlxText(width, 0, 0, textString, textSize);
		tf.color = textColor;
		tf.autoSize = true;
		tf.wordWrap = false;

		ticker = new FlxSprite(x, y).makeGraphic(Math.round(width), Math.round(height), bgColor, true);
		stampY = Math.round((ticker.height - tf.height) / 2);

	#if (windows||neko)
		stampY -= 1;
	#end

		add(ticker);
	}

	override function update(elapsed:Float):Void
	{
		if (ticker.isOnScreen())
		{
			super.update(elapsed);
			updateText(tf);
		}
	}

	function updateText(tf:FlxText):Void
	{
		if ((tf.x + tf.width) < x)
		{
			tf.x = x + width;
		}
		else
		{
			tf.x -= 1;
			ticker.graphic.bitmap.fillRect(ticker.graphic.bitmap.rect, bgColor);
			ticker.stamp(tf, Math.round(tf.x), stampY);
			FlxSpriteUtil.drawRect(ticker, bgX, bgY, width - border, height - border, 0x0, lineStyle);
		}
	}
}
