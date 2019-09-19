package jam.ui;

import flixel.system.FlxSoundGroup;
import jam.fx.FX;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
//import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
//import flixel.system.FlxSoundGroup;
//import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSubState;
//import flixel.util.FlxSpriteUtil;

//import ss.Panel;

#if !MOBILE
//import flixel.input.keyboard.FlxKey;
#end

class SS extends FlxSubState
{
	public static var soundGroup:FlxSoundGroup;

	public var txtStatus:FlxText;
	public var txtTitle:FlxText;
	
	var bgGraphicAsset:FlxGraphicAsset = "default_bg";
	var headerGraphicAsset:FlxGraphicAsset;
	var buttonGraphicAsset:FlxGraphicAsset = "default_button";
	var buttonWidth:Int = 100;
#if MOBILE
	var buttonHeight = 40;
#else
	var buttonHeight:Int = 32;
#end
	var boxBorder:Int = 6;
	var buttonSpacing:Int = 4;
	var textPadding:Int = 6;
	var buttonTextPadding:Int = 6;
	var buttonLabels:Array<String> = ["OK"];
	var verticalButtons:Bool = false;
	var buttonLayout:ButtonLayout = ButtonLayout.HORIZONTAL;
	var titleTextSize:Int = Reg.headerTextSize;
	var textSize:Int = Reg.textSize;
	var font:String = Reg.defaultFont;
	var headerFont:String = Reg.headerFont;
	var buttonFont:String = Reg.buttonFont;
	var buttonTextSize:Int = Reg.buttonTextSize;
	var textColor:FlxColor = Reg.textColor;
	var headerTextColor:FlxColor = Reg.headerTextColor;
	var buttonTextColor:FlxColor = Reg.buttonTextColor;
	var defaultButton:Int = 0;
	var statusHeight:Float = 0;
	var buttons:Array<Button>;
	var currentButton:Int = 0;
	var title:String;
	var rows:Int = -1;
	var cols:Int = -1;
	var instructions:String;
	var titleHeight:Float = 0;
	var buttonTextY:Array<Float>;
	var fadeDuration:Float = 1; // Reg.ssFadeDuration;
	var bg:FlxSprite;
	var panel:Panel;
	var panelWidth:Float = FlxG.height / 0.75;
	
	override public function create():Void
	{
///		persistentDraw = false;
		
#if !MOBILE	
		if (Reg.mouseEnabled != FlxG.mouse.enabled)
			Reg.setMouseEnabled(Reg.mouseEnabled, false);
#end
		
		if (soundGroup == null)
		{
			soundGroup = new FlxSoundGroup();
		}

		buttons = new Array();
		buttonTextY = new Array();
		
		super.create();

		if (bgGraphicAsset == null)
		{
			bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		}
		else
		{
			bg = new FlxSprite().loadGraphic(bgGraphicAsset);
			bg.setGraphicSize(FlxG.width, FlxG.height);
			bg.updateHitbox();
		}
		
	//	if (FlxG.width > bg.width || FlxG.height > bg.height)
	//		bg.setGraphicSize(FlxG.width, FlxG.height);
		
		bg.scrollFactor.set();
		
		add(bg);
		
		if (panel != null)
			add(panel);
		
		titleHeight = 0;
		
		if (title != null)
		{
		//	var headerWidth = FlxG.width * 0.75;
			var headerHeight = buttonHeight;
		//	var headerX = (FlxG.width - headerWidth) / 2;
			var headerY = buttonSpacing;
		//	var border = 4;
			
		//	var headerBorderColor = Reg.headerBorderColor;
		//	var headerBgColor = Reg.msgBoxBgColor;
			
			titleHeight = headerY + headerHeight;
			
			txtTitle = new FlxText(0, buttonSpacing, FlxG.width, title, titleTextSize);
			txtTitle.alignment = CENTER;
			txtTitle.setFormat(headerFont, titleTextSize, headerTextColor, FlxTextAlign.CENTER);
			txtTitle.y = headerY + (headerHeight - txtTitle.height) / 2;
			txtTitle.scrollFactor.set();
			
			add(txtTitle);
		}
		
		var buttonGroupHeight:Float =  (buttonLabels.length * buttonHeight) + ((buttonLabels.length - 1) * buttonSpacing);
		
		if (rows > 0)
			buttonGroupHeight = (rows * buttonHeight) + ((rows - 1) * buttonSpacing);
		
		var startX:Float = 0;
		var startY:Float = 0;
		
		if (instructions != null)
		{
			txtStatus = new FlxText(0, 0, FlxG.width, instructions, textSize);
			txtStatus.alignment = CENTER;
			txtStatus.y = FlxG.height - txtStatus.height - buttonSpacing;
			txtStatus.setFormat(font, textSize, textColor, FlxTextAlign.CENTER);
			txtStatus.scrollFactor.set();
			add(txtStatus);
			statusHeight = txtStatus.height;
		}
		
		if (verticalButtons)	// Main Menu with 2 wertical columns of buttons centered.
		{
			if (rows == -1)
			{
				rows = buttonLabels.length;
				cols = 1;
			}
			
			startX = (FlxG.width - ((buttonWidth + buttonSpacing) * 2)) / 2;
			startY = titleHeight + ((FlxG.height - titleHeight - statusHeight) / 2 - buttonGroupHeight / 2);
			
			var row:Int = 0;
			
			for (i in 0...buttonLabels.length)
			{
				if (i == Std.int(buttonLabels.length / 2))
				{
					row = 0;
					startX += buttonWidth + buttonSpacing;
				}
				buttons[i] = new Button(0, 0, buttonLabels[i], buttonWidth, buttonHeight); // , null, null, null, null, null, null, null); //, buttonGraphicAsset, null, buttonTextSize, buttonTextColor, null, buttonTextPadding);
				buttons[i].label.font = Reg.buttonFont;
				buttons[i].ID = i;
				buttons[i].name = buttonLabels[i];
				buttons[i].setPosition(startX, startY + (row * buttonSpacing) + (row * buttonHeight));
				buttons[i].onUp.callback = buttonClick.bind(buttons[i]);
				buttons[i].onOver.callback = setButtonFocus.bind(buttons[i]);
				add(buttons[i]);
				
				buttonTextY[i] = buttons[i].labelOffsets[0].y;
				row++;
			}
		}
		else					// Dialog with horizontal buttons across the bottom.
		{
			if (cols == -1)
			{
				cols = buttonLabels.length;
				rows = 1;
			}
			
			startX = FlxG.width / 2 - ((buttonLabels.length * buttonWidth) + ((buttonLabels.length - 1) * buttonSpacing)) / 2;
			startY = FlxG.height - (buttonHeight + buttonSpacing) - statusHeight;
			
			for (i in 0...buttonLabels.length)
			{
				buttons[i] = new Button(0, 0, buttonLabels[i], buttonWidth, buttonHeight);
				buttons[i].label.font = Reg.buttonFont;
				buttons[i].ID = i;
				buttons[i].name = buttonLabels[i];
				buttons[i].setPosition(startX + (i * buttonSpacing) + (i * buttonWidth), startY);
				buttons[i].onUp.callback = buttonClick.bind(buttons[i]);
				buttons[i].onOver.callback = setButtonFocus.bind(buttons[i]);
				add(buttons[i]);
				
				buttonTextY[i] = buttons[i].labelOffsets[0].y;
			}
		}
		
		currentButton = defaultButton;
		setButtonFocus(buttons[currentButton], false);
		
		FlxG.cameras.fade(FlxColor.BLACK, fadeDuration, true, null, true);
	}
	
	private function setButtonFocus(button:Button, ?playSound:Bool = true):Void
	{
		if (button == null || button.animation.name == "highlight")
			return;
		
		currentButton = button.ID;
		
		highlightButton(currentButton);
		
		#if !MOBILE
		if (playSound) FX.sound.play("button", 1, null, null, false, false, soundGroup);
		#end
	}
	
	public function highlightButton(id:Int):Void
	{
		for (i in 0...buttons.length)
		{
			if (buttonTextY[i] >= 0)
				buttons[i].labelOffsets[0].y = buttonTextY[i]; // reset the button labelOffset that may have changed with key press.
				
			if (i != id) buttons[i].animation.play("normal");
		}
		
		if (id >= 0) buttons[id].animation.play("highlight");
	}
	
	/** Override this function in your SS class to add code to execute when clicking a button. */
	public function buttonClick(button:Button):Void
	{
		FX.sound.play("switch", 1, null, null, false, false, soundGroup);
		button.animation.play("highlight");
	}
	
	/** Override this function in your SS class to add custom button navigation code. */
	public function navigateButtons():Void
	{
		if (buttons == null)
			return;
		
		if (buttons.length < 1)
			return;
		
		if ((IC.tab.justPressed && IC.shift.pressed) || IC.action2.justPressed)
		{
			currentButton--;
			currentButton = FlxMath.wrap(currentButton, 0, buttons.length - 1);
			
			while (buttons[currentButton].alpha < 1)
			{
				currentButton--;
				currentButton = FlxMath.wrap(currentButton, 0, buttons.length - 1);
			}
			
			setButtonFocus(buttons[currentButton]);
		}
		else if (IC.tab.justPressed || IC.action1.justPressed)
		{
			currentButton++;
			currentButton = FlxMath.wrap(currentButton, 0, buttons.length - 1);
			
			while (buttons[currentButton].alpha < 1)
			{
				currentButton++;
				currentButton = FlxMath.wrap(currentButton, 0, buttons.length - 1);
			}
				
			setButtonFocus(buttons[currentButton]);
		}
		
		if (buttons[currentButton] == null)
			return;
			
		if (buttons[currentButton].animation.name == "normal")
			setButtonFocus(buttons[currentButton], false);
		
		if (IC.enter.justPressed)
		{
			buttons[currentButton].labelOffsets[0].y += buttons[currentButton].labelOffsets[2].y;
			buttons[currentButton].animation.play("pressed");
		}
		
		if (IC.enter.justReleased)
		{
			if (buttons[currentButton].animation.name == "pressed")
			{
				buttons[currentButton].labelOffsets[0].y -= buttons[currentButton].labelOffsets[2].y;
				buttonClick(buttons[currentButton]);
			}
		}
	}
	
	private function quit(msgBox:MsgBox):Void
	{
		Reg.quit(msgBox);
	}
	
	override public function close():Void
	{
		super.close();
		FlxG.cameras.fade(FlxColor.BLACK, fadeDuration, true, null, true);		
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		bg.destroy();
		bg = null;
		
		bgGraphicAsset = null;
		
		if (txtStatus != null)
		{
			txtStatus.destroy();
			txtStatus = null;
		}
		
		for (i in 0...buttons.length)
		{
			buttons[i].destroy();
			buttons[i] = null;
		}
		buttons = null;
		
		while (buttonLabels.length > 0)
		{
			var rem = buttonLabels.pop();
			rem = null;
		}
		buttonLabels = null;
		
		while (buttonTextY.length > 0)
		{
			var rem = buttonTextY.pop();
			rem = null;
		}
		buttonTextY = null;
	}
	
	override public function update(elapsed:Float):Void
	{
	#if !MOBILE
		#if flash
		if (FlxG.keys.justPressed.ESCAPE)
		{
			Reg.fullScreen = FlxG.fullscreen;
			Reg.saveOptions();
		}
		#end
		
		#if !WEBEMBED
		if (FlxG.keys.justPressed.F11)
		{
			Reg.fullScreen = !Reg.fullScreen;
			FlxG.fullscreen = Reg.fullScreen;
			Reg.saveOptions();
		}
		#end
		
		if (FlxG.keys.justPressed.F9)
		{
			Reg.setMouseEnabled(!Reg.mouseEnabled, true);
		//	Reg.saveOptions(); /// added 5-16
		}
	#end
		
		if (buttons == null)
			return;
		
	#if !MOBILE
		if (!Reg.quitting)
		{
			IC.input();
			navigateButtons();
		}
	#end
		super.update(elapsed);
	}
}
	
enum ButtonLayout
{
	VERTICAL;
	HORIZONTAL;
	GRID;
}
