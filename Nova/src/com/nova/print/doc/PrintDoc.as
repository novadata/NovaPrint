package com.nova.print.doc
{
	import com.nova.print.map.LayoutMap;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Sprite;
	
	import mx.managers.LayoutManager;

	public class PrintDoc extends Sprite
	{
		public function PrintDoc()
		{
			
		}
		public function Creat(_rowCurrentPage:int,_colCurrentPage:int,_gridHeight:int):void
		{
			
			this.graphics.clear();
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,SetupInfo.getInstance().paperRealWidth,SetupInfo.getInstance().paperRealHeight);
			this.graphics.endFill();
			
			
			
			var _gridHeight:int=SetupInfo.getInstance().gridHeight;
			var topX:Number=Number(LayoutMap.getSimple().topXml.@x);
			var topY:Number=Number(LayoutMap.getSimple().topXml.@y);
			var gridX:Number=Number(LayoutMap.getSimple().gridXml.@x);
			var gridY:Number=Number(LayoutMap.getSimple().gridXml.@y);
			var bottomX:Number=Number(LayoutMap.getSimple().bottomXml.@x);
			var bottomY:Number=Number(LayoutMap.getSimple().bottomXml.@y);
			var top:PrintText=new PrintText("top");
			this.addChild(top);
			top.x=topX;
			top.y=topY;
			var grid:PrintGrid=new PrintGrid(_rowCurrentPage,_colCurrentPage);
			this.addChild(grid);
			grid.x=gridX;
			grid.y=gridY;
			var bottom:PrintText=new PrintText("bottom");
			this.addChild(bottom);
			bottom.x=bottomX;
			if(SetupInfo.getInstance().hasGrid)
			{
				bottom.y=grid.y+grid.getHeight()+5;
			}
			else
			{
				bottom.y=bottomY;
			}
			var page:PrintPage=new PrintPage();
			page.Creat(_rowCurrentPage,_colCurrentPage);
			this.addChild(page);
		}
	}
}