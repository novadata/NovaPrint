package com.nova.print.doc
{
	import com.nova.print.control.NovaText;
	import com.nova.print.map.DataMap;
	import com.nova.print.map.FoldDataGridMap;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.map.PrintDataMap;
	import com.nova.print.map.PrintMap;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Sprite;
	
	import mx.collections.ArrayCollection;

	public class PrintGrid extends Sprite
	{
		private var rowCurrentPage:int=0;
		private var colCurrentPage:int=0;
		private var dataLength:int=0;//行数目
		private var headLength:int=0;//列数目
		private var gridWidth:int=0;//表格总宽度  
		private var gridHeight:int=0;//表格高度
		private var gridHeadArray:Array=[];
		private var gridColumnWidth:int=0;
		private var dataArray:ArrayCollection;
		private var colHeight:int=20;//表格的每行高度
		private var dynamicGridWidthArray:Array=[];//动态计算并存储每一列的列宽
		private var dynamicLocalX:Array=[];//记录每一列的X坐标
		public function PrintGrid(_rowCurrentPage:int,_colCurrentPage:int)
		{
			if(!SetupInfo.getInstance().hasGrid) return;
			rowCurrentPage=_rowCurrentPage;
			colCurrentPage=_colCurrentPage;
			gridWidth=getWidth();
			dataArray=PrintDataMap.getSimple().getData(colCurrentPage);
			dataLength=SetupInfo.getInstance().printRowNumber+1;
			gridHeight=dataLength*colHeight;
			gridHeadArray=FoldDataGridMap.getInstance().getColumnArrByID(rowCurrentPage);
			headLength=gridHeadArray.length;
			gridColumnWidth=Math.ceil(gridWidth/headLength);
			indexDataGridColumnWidth();
			trace("打印时创建表格的属性-----------------------------------------------------------start");
			trace("打印界面的实际宽度为: "+SetupInfo.getInstance().pageWidth);
			trace("表格的X坐标为: "+LayoutMap.getSimple().gridXml.@x);
			trace("表格的界面宽度为: "+gridWidth);
			trace("表格的界面高度为: "+gridHeight);
			trace("表格的数据集合为: "+dataArray);
			trace("表格的数据集合长度为； "+dataArray.length);
			trace("表格有多少行(加上补空行): "+dataLength);
			trace("表格的列标题数据集合: "+gridHeadArray);
			trace("每一列的宽度为: "+gridColumnWidth);
			trace("动态计算每一列的列宽数组集合为:  "+dynamicGridWidthArray);
			trace("打印时创建表格的属性-----------------------------------------------------------end");
			printLine();
			printHead();
			printContent();
		}
		private function getWidth():int
		{
			var pageWidth:int=SetupInfo.getInstance().pageWidth;
			var gw:int=pageWidth-Number(LayoutMap.getSimple().gridXml.@x)-10;
			return gw;
		}
/**
 * 该方法计算列宽
 * 如果指定了宽度则为该宽度  否则进行计算
 * */
		private function indexDataGridColumnWidth():void
		{
			dynamicGridWidthArray=[];
			var existIndex:int=0;//记录存在列宽数字相加
			var snapWitdh:int=0;//临时保存记录列宽相加的总宽度
			var unGridWidth:int=0;//临时保存没有记录列宽的总宽度
			var unNumer:int=0;//临时保存没有记录列宽的长度
			var unGridColumnWidth:int;//记录没有记录列宽的平均宽度
			var endGridColumnWidth:int;//记录最后一列的宽度
			for(var i:int=0;i<gridHeadArray.length;i++)
			{
				var index:int=gridHeadArray[i];
				var headArray:Array=FoldDataGridMap.getInstance().columnArray[index] as Array;
				var field:String=headArray[1];
				var headTxt:String=headArray[0];
				var gridColumnWidth:int=PrintMap.getSimple().getRecordGridWidth(field);
				dynamicGridWidthArray.push([headTxt,field,gridColumnWidth]);
				if(gridColumnWidth!=0)
				{
					snapWitdh+=gridColumnWidth;
					existIndex++;
				}
			}
			unGridWidth=gridWidth-snapWitdh;
			unNumer=headLength-existIndex;
			unGridColumnWidth=Math.ceil(unGridWidth/unNumer);
			for(var j:int=0;j<dynamicGridWidthArray.length;j++)
			{
				var array:Array=dynamicGridWidthArray[j] as Array;
				if(array[2]==0)
				{
					array[2]=unGridColumnWidth;
					dynamicGridWidthArray[j]=array;
				}
			}
		}
		private function graphicsRow():void
		{
			dynamicLocalX=[0];
			var width:int=0;
			this.graphics.lineStyle(1);
			for(var i:int=0;i<gridHeadArray.length-1;i++)
			{
				var index:int=gridHeadArray[i];
				var headArray:Array=FoldDataGridMap.getInstance().columnArray[index] as Array;
				var indexWidth:int=indexGridField(headArray[0]);
				width+=indexWidth;
				this.graphics.moveTo(width,0);
				this.graphics.lineTo(width,dataLength*colHeight);
				dynamicLocalX.push(width);
			}
			this.graphics.moveTo(gridWidth,0);
			this.graphics.lineTo(gridWidth,dataLength*colHeight);
			this.graphics.endFill();
		}
/**
 * 获取列的宽度并且进行画线
 * */
		private function indexGridField(headTxt:String):int
		{
			var w:int=0;
			for(var i:int=0;i<dynamicGridWidthArray.length;i++)
			{
				var array:Array=dynamicGridWidthArray[i] as Array;
				var head:String=array[0];
				if(headTxt==head)
				{
					w=array[2];
				}
			}
			return w;
		}
		private function printLine():void
		{
			
			this.graphics.clear();
			this.graphics.lineStyle(1);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(gridWidth,0);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(0,dataLength*colHeight);
			for(var i:int=1;i<=dataLength;i++)
			{
				this.graphics.moveTo(0,i*colHeight);
				this.graphics.lineTo(gridWidth,i*colHeight);
			}
			graphicsRow();
			if(SetupInfo.getInstance().printIsTaoda && !SetupInfo.getInstance().isPrintLines)
			{
				this.graphics.clear();
			}
		}
		private function printHead():void
		{
			if(SetupInfo.getInstance().printIsTaoda && !SetupInfo.getInstance().isPrintHeader) return;
			for(var i:int=0;i<gridHeadArray.length;i++)
			{
				var index:int=gridHeadArray[i];
				var headArray:Array=FoldDataGridMap.getInstance().columnArray[index] as Array;
				var nt:PrintDocTxt=new PrintDocTxt(headArray[0],"center",dynamicGridWidthArray[i][2]);
				nt.x=dynamicLocalX[i];
				nt.y=3;
				this.addChild(nt);
			}
		}
		private function printContent():void
		{
			for(var i:int=0;i<headLength;i++)
			{
				var index:int=gridHeadArray[i];
				var headArray:Array=FoldDataGridMap.getInstance().columnArray[index] as Array;
				var field:String=headArray[1];
				var align:String=headArray[2];
				if(align.length<=0)
				{
					align="left";
				}
				var localX:int=dynamicLocalX[i];
				var gridW:int=dynamicGridWidthArray[i][2];
				for(var j:int=0;j<dataArray.length;j++)
				{
					var obj:Object=dataArray.getItemAt(j);
					var txt:String=obj[field];
					var nt:PrintDocTxt=new PrintDocTxt(txt,align,gridW);
					trace("创建内容:  "+txt+"----"+gridW+"-----------align: "+align+"------坐标X"+localX);
					nt.x=localX;
					nt.y=colHeight*(j+1)+3;
					this.addChild(nt);
				}
			}
		}
		public function getHeight():int
		{
			return this.gridHeight;
		}
	}
}