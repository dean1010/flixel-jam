package jam.util;

import haxe.Timer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

class FPSplus extends Sprite
{
	var times:Array<Float> = [];
	var textField:TextField;
	var memPeak:Float = 0;
	var showMem:Bool = true;
	var showPeak:Bool = true;

	public function new(x:Float = 0, y:Float = 0, textSize:Int = 12, textColor:Int = 0xFFFFFF, bgColor:Int = 0x000000, bgAlpha:Float = 1, showMem:Bool = true, showPeak:Bool = true) 
	{
		super();

		this.x = x;
		this.y = y;
		this.showMem = showMem;
		this.showPeak = showPeak;

		textField = new TextField();
		textField.x = 4;
		textField.y = 2;
		textField.selectable = false;
		textField.defaultTextFormat = new TextFormat("_sans", textSize, textColor);
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.text = "FPS: 00";
		if (showMem)  textField.text += "\nMEM: 100.0 MB";
		if (showPeak) textField.text += "\npeak: 100.0 MB";

		var w = textField.width + 8;
		var h = textField.height + 4;

		graphics.beginFill(bgColor, bgAlpha);
		graphics.drawRect(x, y, w, h);
		graphics.endFill();

		addChild(textField);
		addEventListener(Event.ENTER_FRAME, onEnter);
	}

	function onEnter(_)
	{	
		if (!visible) return;

		var now = Timer.stamp();

		times.push(now);
		while (times[0] < now - 1) times.shift();
		textField.text = "FPS: " + times.length;

		if (showMem || showPeak)
		{
			var mem = Math.round(System.totalMemory / 1024 / 1024 * 10) / 10;

			if (mem > memPeak) memPeak = mem;
			if (showMem) textField.text += "\nMEM: " + pad(mem) + " MB";
			if (showPeak) textField.text += "\npeak: " + pad(memPeak) + " MB";
		}
	}

	function pad(n:Float):String
	{
		return (Std.string(n).indexOf(".") != -1 ? Std.string(n) : Std.string(n) + ".0");
	}
}
