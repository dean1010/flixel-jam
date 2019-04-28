package jam.util;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

/**
 * Utility functions.
 */
class Util
{
	/**
	 * Clear a bitmap by filling it with transparency.
	 * @param bitmapData BitmapData to clear.
	 */
	public static function clearBitmapData(bitmapData:BitmapData):Void
	{
		bitmapData.fillRect(bitmapData.rect, 0x0);
	}

	/**
	 * Clear a graphic by filling it with transparency.
	 * @param graphic FlxGraphic to clear.
	 */
	public static function clearGraphic(graphic:FlxGraphic):Void
	{
		graphic.bitmap.fillRect(graphic.bitmap.rect, 0x0);
	}

	/**
	 * Clear a FlxSprite by filling it with transparency.
	 * @param sprite FlxSprite to clear its `graphic.bitmap`.
	 */
	public static function clearSprite(sprite:FlxSprite):Void
	{
		sprite.graphic.bitmap.fillRect(sprite.graphic.bitmap.rect, 0x0);
	}

	/**
	 * Calculates the distance between the center points of two objects.
	 * @param objectA Object to check distance from objectB.
	 * @param objectB Object to check distance from objectA.
	 * @return The distance between objectA and objectB center points.
	 */
	public static function distanceBetween(objectA:FlxObject, objectB:FlxObject):Float
	{
		if (objectA == null || objectB == null) return 0;

		var pA = objectA.getMidpoint(FlxPoint.get());
		var pB = objectB.getMidpoint(FlxPoint.get());

		var dx:Float = pA.x - pB.x;
		var dy:Float = pA.y - pB.y;

		pA.put();
		pB.put();

		return Math.sqrt(dx * dx + dy * dy);
	}

	/**
	 * Determines the distance in tiles.
	 * @param distanceInPixels Distance in pixels.
	 * @param tileSize         Tilemap tile size.
	 * @return Distance in tiles.
	 */
	public static function distanceInTiles(distanceInPixels:Float, tileSize:Int):Float
	{
		return distanceInPixels / tileSize;
	}

	/**
	 * Remove all spaces from a String.
	 * @param s String to remove spaces from.
	 * @return String with spaces removed.
	 */
	public static function removeSpaces(s:String):String
	{
		return StringTools.replace(s, " ", "");
	}

	/**
	 * Returns an array of random `Int`s equal to the total value.
	 * @param total Total value to return as an array of Int values.
	 * @param min   Minimum value for random Int.
	 * @param max   Maximum value for random Int.
	 * @return Array<Int>
	 */
	public static function randomInts(total:Int, min:Int = 1, max:Int = 6):Array<Int>
	{
		var a:Array<Int> = new Array();
		var i = 1;

		while (total >= 6)
		{
			i = FlxG.random.int(min, max);
			a.push(i);
			total -= i;
		}

		if (total > 0) a.push(total);

		return a;
	}
}
