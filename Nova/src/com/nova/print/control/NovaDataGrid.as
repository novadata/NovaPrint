package com.nova.print.control
{
	/**
	 * 此类是操作表格的所有的操作类
	 * 
	 * */
	import com.nova.print.map.DataMap;
	import com.nova.print.map.FoldDataGridMap;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.map.PrintDataMap;
	import com.nova.print.map.PrintMap;
	import com.nova.print.util.SetupInfo;
	
	import flashx.textLayout.formats.ITabStopFormat;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridBase;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	
	import spark.components.BorderContainer;

	public class NovaDataGrid
	{
		private static var novaDataGrid:NovaDataGrid=null;
		private var _exportGridXml:XML=null;
		private var _dataGridHeight:int=0;//计算表格的实际高度
		public static function getInstance():NovaDataGrid
		{
			if(novaDataGrid==null)
			{
				novaDataGrid=new NovaDataGrid();
			}
			return novaDataGrid;
		}
		/**
		 * 根据折页的数据创建 表格
		 * */
		public function creatDataGrid(dataGrid:DataGrid):void
		{
			var dataProvider:ArrayCollection=PrintDataMap.getSimple().getData(SetupInfo.getInstance().colCurrentPage-1);
			var currentPage:int=SetupInfo.getInstance().rowCurrentPage-((SetupInfo.getInstance().colCurrentPage-1)*SetupInfo.getInstance().rowPages)-1;
			var paperHeight:int=SetupInfo.getInstance().printPaperArr[1];
			var viewheight:int=paperHeight-SetupInfo.getInstance().printHeaderNum-SetupInfo.getInstance().printFooterNum-SetupInfo.getInstance().printBottom-SetupInfo.getInstance().printTop;
			dataGrid.columns=new Array();
			var columnArr:Array=FoldDataGridMap.getInstance().getColumnArrByID(currentPage) as Array;
			var emptyRowNum:int=0;
			emptyRowNum=Math.max(SetupInfo.getInstance().printRowNumber-dataProvider.length,0);
			if(columnArr.length==0)
			{
				dataGrid.width=0;
				dataGrid.height=0;
				return;
			}
			var array:Array=[];
			for(var j:int=0;j<columnArr.length;j++)
			{
				var column:DataGridColumn=new DataGridColumn();
				column.dataField=getDataField(columnArr[j]);
				var recordWidth:int=PrintMap.getSimple().getRecordGridWidth(column.dataField);
				if(recordWidth!=0)
				{
					column.width=recordWidth;
				}
				column.headerText=getHeadText(columnArr[j]);
				if(getTextAlign(columnArr[j])!="")
				{
					column.setStyle("textAlign",getTextAlign(columnArr[j]));
				}
				else
				{
					column.setStyle("textAlign","left");
				}
				array.push(column);
			}
			dataGrid.columns=array;
			dataGrid.resizableColumns=true;
			dataGrid.mouseChildren=true;
			dataGrid.editable=false;
			dataGrid.sortableColumns=false;
			dataGrid.selectable=false;
			dataGrid.allowDragSelection=false;
			dataGrid.setStyle("alternatingItemColors",[0xffffff]);
			dataGrid.setStyle("horizontalGridLines",true);
			dataGrid.setStyle("horizontalGridLineColor",0xDEE2E3);
			dataGrid.setStyle("verticalGridLineColor",0xDEE2E3);
			dataGrid.setStyle("headerStyleName","header");
			dataGrid.setStyle("chromeColor",0xffffff);
			dataGrid.setStyle("fontFamily","SONG");
			dataGrid.setStyle("fontSize",10);
			dataGrid.verticalScrollPolicy="off";
			dataGrid.rowHeight=25;
			dataGrid.dataProvider=dataProvider;
			//总共显示的行数为  每页显示多少行+补空行数目
			var length:int=dataProvider.length;
			length=Math.max(0,length);
			dataGrid.rowCount=length;
			var gridHeight:Number=(length+1)*dataGrid.rowHeight;
			_dataGridHeight=gridHeight+emptyRowNum*25-3;
		}
		/**
		 * 根据数组ID获取表格的DataField
		 * */
		public function getDataField(value:int):String
		{
			if(value>=FoldDataGridMap.getInstance().columnArray.length) return "";
			else
				var array:Array=FoldDataGridMap.getInstance().columnArray[value] as Array;	
			return array[1];
		}
		/**
		 * 根据数组ID获取表格的宽度
		 * */
		public function getColumnWidth(value:int):int
		{
			if(value>=FoldDataGridMap.getInstance().columnArray.length) return 50;
			else
				var array:Array=FoldDataGridMap.getInstance().columnArray[value] as Array;	
			return array[3];
		}
		/**
		 * 根据数组ID获取表格的DataField
		 * */
		public function getHeadText(value:int):String
		{
			if(value>=FoldDataGridMap.getInstance().columnArray.length) return "";
			else
				var array:Array=FoldDataGridMap.getInstance().columnArray[value] as Array;	
			return array[0];
		}
		/**
		 * 根据数组ID获取表格的DataField的对齐方式
		 * */
		public function getTextAlign(value:int):String
		{
			if(value>=FoldDataGridMap.getInstance().columnArray.length) return "";
			else
				var array:Array=FoldDataGridMap.getInstance().columnArray[value] as Array;	
			return array[2];
		}
		private function setColumns(xml:XML):Array
		{
			var columns:Array=new Array();
			for(var i:int=0;i<xml.children().length();i++)
			{
				columns.push(setGridColumn(xml.children()[i]));
			}
			return columns;
		}
		private function setGridColumn(columnXml:XML):DataGridColumn
		{
			var gc:DataGridColumn=new DataGridColumn();
			gc.dataField=columnXml.@dataField;
			var gcw:String=columnXml.@width;
			if(gcw.length!=0)
			{
				gc.width=columnXml.@width;
			}
			gc.headerText=columnXml.@headerText;
			if(columnXml.@textAlign!="")
			{
				gc.setStyle("textAlign",columnXml.@textAlign);
			}
			else
			{
				gc.setStyle("textAlign","left");
			}
			return gc;
		}
		public function get exportGridXml():XML
		{
			return _exportGridXml;
		}

		public function set exportGridXml(value:XML):void
		{
			_exportGridXml = value;
		}

		public function get dataGridHeight():int
		{
			return _dataGridHeight;
		}

		public function set dataGridHeight(value:int):void
		{
			_dataGridHeight = value;
		}

	}
}