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
	var textField:TextField;
	var times:Array<Float> = [];
	var updateDelay:Float = 0.16;
	var updateElapsed:Float = 0;
	var memPeak:Float = 0;
	var showMem:Bool = true;
	var showPeak:Bool = true;
	var precision = 2;

	public function new(x:Float = 0, y:Float = 0, textSize:Int = 12, textColor:Int = 0xFFFFFF, bgColor:Int = 0x000000, bgAlpha:Float = 1, showMem:Bool = true, showPeak:Bool = true, precision:Int = 2) 
	{
		super();

		if (System.totalMemory == 0) showMem = showPeak = false; // Not all targets supported

		this.x = x;
		this.y = y;
		this.precision = precision;
		this.showMem = showMem;
		this.showPeak = showPeak;

		textField = new TextField();
		textField.x = x;
		textField.y = y;
		textField.selectable = false;
		textField.defaultTextFormat = new TextFormat("_sans", textSize, textColor);
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.text = "FPS: 00";

		if (showMem)  textField.text += "\nMEM: 0"  + pad(0.0, precision) + " MB";
		if (showPeak) textField.text += "\nPeak: 0" + pad(0.0, precision) + " MB";

		if (bgAlpha > 0)
		{
			graphics.beginFill(bgColor, bgAlpha);
			graphics.drawRect(x, y, textField.width, textField.height);
			graphics.endFill();
		}

		addChild(textField);
		addEventListener(Event.ENTER_FRAME, onEnter);
	}

	function onEnter(_)
	{
		if (!visible) return;

		var now = Timer.stamp();
		var elapsed = now - (times.length > 0 ? times[times.length - 1] : 0);

		times.push(now);
		while (times[0] < now - 1) times.shift();

		if (updateElapsed < updateDelay)
		{
			updateElapsed += elapsed;
			return;
		}

		updateElapsed = 0;

		textField.text = "FPS: " + times.length;

		if (showMem || showPeak)
		{
			var p = Math.pow(10, precision);
			var mem = Math.round(System.totalMemory / 1024 / 1024 * p) / p;
			if (mem > memPeak) memPeak = mem;
			if (showMem)  textField.text += "\nMEM: "  + pad(mem, precision)     + " MB";
			if (showPeak) textField.text += "\nPeak: " + pad(memPeak, precision) + " MB";
		}
	}

	function pad(n:Float, p:Int = 2):String
	{
		var a = Std.string(n).split(".");

		if (a.length == 1) a.push("0");

		while(a[1].length < p) a[1] += "0";		

		return a[0] + "." + a[1];
	}
}
