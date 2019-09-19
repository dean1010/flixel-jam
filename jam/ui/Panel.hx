package jam.ui;

import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.geom.Rectangle;

/**
 * Panel - A background panel used for MsgBox, headers, pages, etc., using FlxUI9SliceSprite.
 */
class Panel extends FlxUI9SliceSprite
{
	var graphicAsset:FlxGraphicAsset = "default_panel";
	var sliceArray:Array<Int> = [15, 15, 35, 35];
	
	/**
	 * A background panel used for MsgBox, headers, pages, etc. Uses FlxUI9SliceSprite
	 * @param x            X position.
	 * @param y            Y position.
	 * @param width        Width of panel.
	 * @param height       Height of panel.
	 * @param graphicAsset Graphic to use for the slice.
	 * @param sliceArray   [x1,y1,x2,y2] 2 points (upper-left and lower-right) that define the 9-slice grid.
	 */
	public function new(x:Float = 0, y:Float = 0, width:Float = 100, height:Float = 100, ?graphicAsset:FlxGraphicAsset, ?sliceArray:Array<Int>)
	{
		if (graphicAsset == null) graphicAsset = this.graphicAsset ;
		if (sliceArray   == null) sliceArray   = this.sliceArray   ;
		if (sliceArray   == null) sliceArray   = this.sliceArray   ;

		var rect = new Rectangle(0, 0, width, height);
		
		super(x, y, graphicAsset, rect, sliceArray);
		
		scrollFactor.set();
	}
}
