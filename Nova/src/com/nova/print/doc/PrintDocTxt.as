package com.nova.print.doc
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.controls.Text;

	public class PrintDocTxt extends Sprite
	{
		private var txtFormat:TextFormat;
		private var txtField:TextField=null;
		private var maskSprite:Sprite=null;
		public function PrintDocTxt(txt:String,_algin:String,_width:int)
		{
			txtField=new TextField();
			txtFormat=new TextFormat();
			txtFormat.font="SONG";
			txtFormat.size=10;
			txtFormat.align=_algin;
			txtField.width=_width;
			txtField.embedFonts=true;
			if(txt==null)
			{
				txt="";
			}
			txtField.text=txt;
			txtField.height=20;
			txtField.setTextFormat(txtFormat);
			this.addChild(txtField);
			maskSprite=new Sprite();
			maskSprite.graphics.lineStyle(1);
			maskSprite.graphics.beginFill(0x000000);
			maskSprite.graphics.drawRect(1,0,_width-1,20);
			maskSprite.graphics.endFill();
			txtField.mask=maskSprite;
			this.addChild(maskSprite);
		}
	}
}