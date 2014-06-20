package com.nova.print.doc
{
	import com.nova.print.control.NovaText;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Sprite;

	public class PrintPage extends Sprite
	{
		private var headTxt:NovaText;
		private var footTxt:NovaText;
		private var pageNum:NovaText;
		public function PrintPage()
		{
			
		}
		public  function Creat(_rowCurrentPage:int,_colCurrentPage:int):void
		{
			headTxt=new NovaText(SetupInfo.getInstance().printHeader,"center","",SetupInfo.getInstance().paperWidthSize);
			this.addChild(headTxt);
			footTxt=new NovaText(SetupInfo.getInstance().printFooter,"center","",SetupInfo.getInstance().paperWidthSize);
			this.addChild(footTxt);
			pageNum=new NovaText((_colCurrentPage+1)+"-"+(_rowCurrentPage+1),"left","",50);
			this.addChild(pageNum);
			headTxt.y=0;
			footTxt.y=SetupInfo.getInstance().paperHeightSize-SetupInfo.getInstance().printFooterNum-15;
			pageNum.x=SetupInfo.getInstance().pageWidth-60;
			pageNum.y=3;
		}
	}
}