package;

import flixel.FlxG;
//import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
//import flixel.util.FlxSpriteUtil;

/**
 * MsgBox - Generic message box to inform and/or allow to accept or cancel.
 * @author Dean
 */
class MsgBox extends SSTemplate
{
	/** By default this is false. If button[1] is chosen, this gets set to true. */
	public var confirmed:Bool = false;
	
	private var _textAlign:FlxTextAlign = FlxTextAlign.LEFT;
	private var _boxBgColor:FlxColor = Reg.msgBoxBgColor;
	private var _boxBorderColor:FlxColor = Reg.msgBoxBorderColor;
//	private var _boxBorder:Int = 6; 
	private var _msgBoxStyle:MsgBoxStyle = MsgBoxStyle.YES_NO;
	private var _message:String;
	private var _reverseButtonOrder:Bool = true; // Reverse the order since button[0] == false.
	
//	private var _panelGraphic:String = "assets/ui/panel_blue_50x50.png";
//	private var _sliceArray:Array<Int> = [10, 10, 40, 40];
	
	
	public function new(message:String, 
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
		
		if (msgBoxStyle   != null) _msgBoxStyle   = msgBoxStyle;
		if (defaultButton != null) _defaultButton = defaultButton;
		if (textAlign     != null) _textAlign     = textAlign;
		if (boxBgColor    != null) _boxBgColor    = boxBgColor;
		if (textSize      != null) _textSize      = textSize;
		if (textColor     != null) _textColor     = textColor;
	}
	
	override public function create():Void
	{
		switch (_msgBoxStyle)
		{
			case MsgBoxStyle.OK:
				_buttonLabels = ["OK"];
				
			case MsgBoxStyle.OK_CANCEL:
				_buttonLabels = ["Cancel", "OK"];
				
			case MsgBoxStyle.YES_NO:
				_buttonLabels = ["No", "Yes"];				
		}
		
		_buttonWidth = 80;
		
		var boxWidth:Float = _buttonWidth * 3; // FlxG.width * 0.75;
		
		var txtMessage = new FlxText(0, 0, boxWidth - ((_boxBorder + _buttonSpacing) * 2), _message, _textSize);
		txtMessage.setFormat(Reg.defaultFont, _textSize, _textColor, _textAlign);
		txtMessage.scrollFactor.set();
		
		if (txtMessage.textField.numLines == 1)
		{
			txtMessage.alignment = FlxTextAlign.CENTER;
		}
		
		var boxHeight:Float = txtMessage.height + _buttonHeight + (_boxBorder * 2) + (_buttonSpacing * 3) + _textPadding;
		var boxX:Float = (FlxG.width - boxWidth) / 2;
		var boxY:Float = (FlxG.height - boxHeight) / 2;
		
		// adds a panel for the box. Keep before super.create().
		_panel = new Panel(boxX, boxY, boxWidth, boxHeight); //, _panelGraphic, _sliceArray);
		
		super.create();
		
		txtMessage.setPosition(boxX + _boxBorder + _textPadding, boxY + _boxBorder + _textPadding);
		add(txtMessage);
		
		
		
//		var lineStyle:LineStyle = { thickness: _boxBorder, color: _boxBorderColor };
//		FlxSpriteUtil.drawRect(_bg, boxX, boxY, boxWidth, boxHeight, _boxBgColor, lineStyle);
	//	FlxSpriteUtil.drawRoundRect(_bg, boxX, boxY, boxWidth, boxHeight, 10, 10, _boxBgColor, lineStyle);
		
		var buttonX:Float = 0;
		
		for (i in 0..._buttons.length)
		{
//			remove(_buttons[i]);
			
			if (i == 0)	// Reverse the button x location.
				buttonX = _buttons[_buttons.length - 1].x;
			else
				buttonX -= (_buttonWidth  + _buttonSpacing);
			
			_buttons[i].x = buttonX;
			_buttons[i].y = boxY + boxHeight - (_buttonHeight + _buttonSpacing + (_boxBorder / 1));
			
			
//			add(_buttons[i]);
		}
	}
	
	override public function buttonClick(button:Button):Void
	{
		switch (button.ID)
		{
			case 0:  confirmed = false;
			case 1:  confirmed = true;
			default: trace("Unknown Button ID " + button.ID);
		}
		
		close();
		super.buttonClick(button);
		
	//	super.buttonClick(button);
	//	close();
	}
	
}
