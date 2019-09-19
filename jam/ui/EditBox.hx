package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import openfl.geom.Point;
//import flixel.addons.ui.FlxInputText;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
import openfl.text.TextFieldAutoSize;
//import flixel.util.FlxSpriteUtil.LineStyle;

//import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

class EditBox extends SSTemplate
{
	/** By default this is false. If button[1] is chosen, or there's only one button (OK), this gets set to true. */
	public var confirmed:Bool = false;
	
	public var inputString:String;
	public var inputText:TextField;
	
	private var _textAlign:FlxTextAlign = FlxTextAlign.LEFT;
	private var _boxBgColor:FlxColor = Reg.msgBoxBgColor;
	private var _boxBorderColor:FlxColor = Reg.msgBoxBorderColor;
	private var _msgBoxStyle:MsgBoxStyle = MsgBoxStyle.YES_NO;
	private var _message:String;
	private var _fontName:String;
	
	private var _oflScaleX:Float = 1;
	private var _oflScaleY:Float = 1;

	private var _reverseButtonOrder:Bool = true;		// Reverse the order since button[0] == false.
	
	private var _mouseEnabled:Bool = Reg.mouseEnabled;		// windows turns mouse visible without enabling it. This is to reset back onClose.
	
	public function new(message:String, inputString:String, 
						?msgBoxStyle:MsgBoxStyle, 
						?textAlign:FlxTextAlign, 
						?defaultButton:Int, 
						?subStateBG:FlxColor, 
						?boxBgColor:FlxColor, 
						?textSize:Int, 
						?textColor:FlxColor)
	{
		super();
		
		_message = message;
		this.inputString = inputString;
		
		if (msgBoxStyle   != null) _msgBoxStyle   = msgBoxStyle;
		if (defaultButton != null) _defaultButton = defaultButton;
		if (textAlign     != null) _textAlign     = textAlign;
		if (boxBgColor    != null) _boxBgColor    = boxBgColor;
		if (textSize      != null) _textSize      = textSize;
		if (textColor     != null) _textColor     = textColor;
		
#if MOBILE
		_fadeDuration = 0;
#end
	}
	
	private function updateSize(width:Int, height:Int)
	{
/////////////////////////////////////////////////////////////////////////////////////////
//	trace("RESIZE 1");
//	trace([inputText.x, inputText.y, inputText.width, inputText.height]);
//	trace([FlxG.width, FlxG.height]);
//	trace([FlxG.stage.stageWidth, FlxG.stage.stageHeight]);
/////////////////////////////////////////////////////////////////////////////////////////
		_oflScaleX = FlxG.scaleMode.scale.x; // / (FlxG.game.width / width);
		_oflScaleY = FlxG.scaleMode.scale.y; // / (FlxG.game.height / height);
		
		inputText.scaleX = _oflScaleX;
		inputText.scaleY = _oflScaleY;

	//	inputText.defaultTextFormat = new TextFormat(_fontName, Std.int(Reg.textSize * _oflScaleY), Reg.textColor);
		
/////////////////////////////////////////////////////////////////////////////////////////
//	trace("RESIZE 2");
//	trace([inputText.x, inputText.y, inputText.width, inputText.height]);
//	trace([FlxG.width, FlxG.height]);
//	trace([FlxG.stage.stageWidth, FlxG.stage.stageHeight]);
/////////////////////////////////////////////////////////////////////////////////////////
		
	}

	override public function create():Void
	{		
		FlxG.cameras.reset();
		
		switch (_msgBoxStyle)
		{
			case MsgBoxStyle.OK:
				_buttonLabels = ["OK"];
				
			case MsgBoxStyle.OK_CANCEL:
				_buttonLabels = ["Cancel", "OK"];
				
			case MsgBoxStyle.YES_NO:
				_buttonLabels = ["No", "Yes"];				
		}
		
		_defaultButton = _buttonLabels.length - 1;
		_currentButton = _defaultButton;
		
		_buttonWidth = 80;
		
		var boxWidth:Float = _buttonWidth * 3; // FlxG.width * 0.75;
		
		var txtMessage = new FlxText(0, 0, boxWidth - (_buttonSpacing * 2) - (_boxBorder * 2), "TEST", _textSize);
		txtMessage.setFormat(_font, _textSize, _textColor, _textAlign);
		_fontName = txtMessage.font;
		
		var textBoxHeight = txtMessage.height;
		
		txtMessage.text = _message;
		
		txtMessage.scrollFactor.set();
		
		if (txtMessage.textField.numLines == 1)
		{
			txtMessage.alignment = FlxTextAlign.CENTER;
		}
		
		var boxX:Float = (FlxG.width - boxWidth) / 2;
		
		_oflScaleX = FlxG.scaleMode.scale.x;
		_oflScaleY = FlxG.scaleMode.scale.y;
		
		inputText = new TextField();
		
		inputText.embedFonts = true;
		inputText.defaultTextFormat = new TextFormat(_fontName, Std.int(Reg.textSize * _oflScaleY), Reg.textColor);
		inputText.type = TextFieldType.INPUT;
		inputText.autoSize = TextFieldAutoSize.LEFT;
		inputText.multiline = false;
		inputText.maxChars = 16;
#if MOBILE
		inputText.textColor = Reg.textColor; // android needs this for some reason
		inputText.needsSoftKeyboard = true;
		inputText.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
#end
		inputText.text = inputString;
		inputText.autoSize = TextFieldAutoSize.NONE;
		inputText.width = (boxWidth - (_buttonSpacing * 8) - (_boxBorder * 2)) * _oflScaleX;
		
		inputText.selectable = true;
		FlxG.addChildBelowMouse(inputText);
		FlxG.stage.focus = inputText;
		inputText.setSelection(0, inputString.length);
		
/////////////////////////////////////////////////////////////////////////////////////////
//		inputText.background = true;
//	trace("CREATE");
//	trace([inputText.x, inputText.y, inputText.width, inputText.height]);
//	trace([FlxG.width, FlxG.height]);
//	trace([FlxG.stage.stageWidth, FlxG.stage.stageHeight]);
/////////////////////////////////////////////////////////////////////////////////////////
	
		var boxHeight:Float = txtMessage.height + textBoxHeight + _buttonHeight + (_boxBorder * 2) + (_buttonSpacing * 4);
		
#if MOBILE
		var boxY:Float = _buttonSpacing; // move near top on mobile to be out of the way of softkeyboard.
#else
		var boxY:Float = (FlxG.height - boxHeight) / 2;
#end
		// adds a panel for the box. Keep before super.create().
		_panel = new Panel(boxX, boxY, boxWidth, boxHeight); //, _panelGraphic, _sliceArray);
		
#if windows
		Reg.setMouseEnabled(true);
#end
		super.create();
		
		txtMessage.setPosition(boxX + _boxBorder + _buttonSpacing, boxY + _boxBorder + _buttonSpacing);
		add(txtMessage);
		
		var textBorder = new FlxSprite().makeGraphic(Std.int(boxWidth - (_buttonSpacing * 8) - (_boxBorder * 2)), Std.int(textBoxHeight), 0xFF382f28);
		var lineStyle:LineStyle = { thickness: 2, color: 0xFF191611 }; // Reg.textColor };
		FlxSpriteUtil.drawRect(textBorder, 0, 0, textBorder.width, textBorder.height, 0xFF382f28, lineStyle);
		textBorder.setPosition(boxX + _boxBorder + (_buttonSpacing * 4), txtMessage.y + txtMessage.height + _buttonSpacing);
		textBorder.scrollFactor.set();
		add(textBorder);
		
		var inputOffset = 2; // Math.abs(textBorder.height - (inputText.height / oflScaleY)) / 2;
		
		inputText.x = 3 + (inputOffset + boxX + _boxBorder + (_buttonSpacing * 4)) * _oflScaleX;
		inputText.y = (inputOffset + txtMessage.y + txtMessage.height + _buttonSpacing) * _oflScaleY;
		
		var buttonX:Float = 0;
		
		for (i in 0..._buttons.length)
		{
			if (i == 0)	// Reverse the button x location.
				buttonX = _buttons[_buttons.length - 1].x;
			else
				buttonX -= (_buttonWidth  + _buttonSpacing);
			
			_buttons[i].x = buttonX;
			_buttons[i].y = boxY + boxHeight - (_buttonHeight + _buttonSpacing + _boxBorder);
		}
		
		// used to resize the openfl TextField we're using, when the game resizes
//		FlxG.signals.gameResized.add(updateSize);
	}
	
	override public function close():Void 
	{
		super.close();
//#if !MOBILE
		// MOUSE ENABLE //////////////////////////////////////////////////
#if windows
		FlxG.stage.focus = null;
		Reg.setMouseEnabled(_mouseEnabled);
#end
		// MOUSE ENABLE //////////////////////////////////////////////////
//#end
	//	FlxG.camera.follow(PlayState.player, PLATFORMER, 1);
	}
	
	override public function buttonClick(button:Button):Void
	{
		switch (button.ID)
		{
			case 0: confirmed = false;
				
			case 1: confirmed = true;
				
			default: trace("Unknown Button ID " + button.ID);
		}
		
		if (_buttons.length < 2)
			confirmed = true;
		
		super.buttonClick(button);
		
		if (StringTools.trim(inputText.text) != "" || !confirmed)
		{
			confirmed = ((_currentButton == 1 && _buttons.length > 1) || (_currentButton == 0 && _buttons.length < 2)) ? true : false;
#if MOBILE
			if (inputText.hasEventListener(KeyboardEvent.KEY_DOWN))
			{
				inputText.removeEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			}
			
			FlxG.stage.focus = null;
#end
			FlxG.removeChild(inputText);
			
			close();
		}
		else
		{
			Util.playSound("deny", 1, false, Reg.uiSoundGroup);
			FlxG.stage.focus = inputText;
		}
	}
	
#if MOBILE // when user presses enter on softkeyboard
	function onEnter(e:KeyboardEvent)
	{
		if (e.keyCode == 13)
		{
			if (StringTools.trim(inputText.text) != "")
			{
				confirmed = ((_currentButton == 1 && _buttons.length > 1) || (_currentButton == 0 && _buttons.length < 2)) ? true : false;
			
				if (inputText.hasEventListener(KeyboardEvent.KEY_DOWN))
				{
					inputText.removeEventListener(KeyboardEvent.KEY_DOWN, onEnter);
				}
				
				FlxG.stage.focus = null;
				FlxG.removeChild(inputText);
				
				Util.playSound("switch", 1, false, Reg.uiSoundGroup);
				
				close();
			}
			else
			{
				Util.playSound("deny", 1, false, Reg.uiSoundGroup);
				FlxG.stage.focus = inputText;
			}
		}
	}
#end
	
}
