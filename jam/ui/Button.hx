package jam.ui;

import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText.FlxTextAlign;

class Button extends FlxUIButton
{
	var font:String = null;
	var textColor:Int = 0xFFFFFFFF;
	var textPadding:Int = 5;
	var textSize:Int = 10;
	var graphicAsset:FlxGraphicAsset = "default_button";
	var sliceArray:Array<Array<Int>> = [[15, 15, 35, 35]];
//	var sliceArray:Array<Array<Int>> = [[12, 12, 38, 38]];
	var verticalTextAlign:VerticalTextAlign = VerticalTextAlign.CENTER;

	/**
	 * Slice9 Button with vertical text alignment.
	 * @param x                 X coordinate of the Button.
	 * @param y                 Y coordinate of the Button.
	 * @param labelText         Text displayed on the Button.
	 * @param buttonWidth       Width of the Button.
	 * @param buttonHeight      Height of the Button.
	 * @param graphicAsset      Slice9 graphic asset.
	 * @param sliceArray        Slice array for the 3 button states.
	 * @param verticalTextAlign Vertical alignment of the text label. Default is `VerticalTextAlign.CENTER`
	 * @param onClick           Function to call when the Button is clicked.
	 */
	public function new(x:Float = 0, y:Float = 0, ?labelText:String, buttonWidth:Int = 80, buttonHeight:Int = 30, ?graphicAsset:FlxGraphicAsset, ?sliceArray:Array<Array<Int>>, ?verticalTextAlign:VerticalTextAlign, ?onClick:Void->Void)
	{
		super(x, y, labelText, onClick, false, false);

		if (graphicAsset      == null) graphicAsset      = this.graphicAsset      ;
		if (sliceArray        == null) sliceArray        = this.sliceArray        ;
		if (verticalTextAlign == null) verticalTextAlign = this.verticalTextAlign ;

		while (sliceArray.length < 3) sliceArray.push(sliceArray[sliceArray.length - 1]);

		broadcastToFlxUI = false;

		loadGraphicSlice9([graphicAsset], buttonWidth, buttonHeight, sliceArray, FlxUI9SliceSprite.TILE_NONE, -1, false, 50, 50);

		if (labelText != null && labelText != "")
		{	
			label.setFormat(font, textSize, textColor, FlxTextAlign.CENTER);
		 	label.fieldWidth = buttonWidth - (textPadding * 2);
		 	label.x = (buttonWidth - label.fieldWidth) / 2;

			switch (verticalTextAlign)
			{
				case VerticalTextAlign.TOP:
					setCenterLabelOffset(label.x, textPadding);
				case VerticalTextAlign.CENTER:
					autoCenterLabel();
				case VerticalTextAlign.BOTTOM:
					setCenterLabelOffset(label.x, buttonHeight - label.height - textPadding);
				default:
					autoCenterLabel();
			}

			label.alpha = 1;
			labelAlphas = [1, 1, 1];
		}
	}

	/**
	 * Format the Button label text.
	 * @param font        Button labels font. Leave `null` to use default font.
	 * @param textSize    Button labels text size.
	 * @param textColor   Button labels text color.
	 * @param textPadding Padding distance from edges of the Button.
	 * @param alignX      Horizontal text alignment.
	 * @param alignY      Vertical text alignment.
	 */
	public function formatText(?font:String, textSize:Int = 10, textColor:Int = 0xFFFFFFFF, textPadding:Int = 5, alignX:FlxTextAlign = FlxTextAlign.CENTER, alignY:VerticalTextAlign = VerticalTextAlign.CENTER):Void
	{
		label.setFormat(font, textSize, textColor, alignX);
		label.fieldWidth = width - (textPadding * 2);
		label.x = (width - label.fieldWidth) / 2;

		switch (alignY)
		{
			case VerticalTextAlign.TOP:
				setCenterLabelOffset(label.x, textPadding);
			case VerticalTextAlign.CENTER:
				autoCenterLabel();
			case VerticalTextAlign.BOTTOM:
				setCenterLabelOffset(label.x, height - label.height - textPadding);
			default:
				autoCenterLabel();
		}
	}
}

enum VerticalTextAlign
{
	TOP;
	CENTER;
	BOTTOM;
}
