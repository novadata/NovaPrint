package  com.nova.print.control
{
	import com.nova.print.map.FoldAdvancedGridMap;
	import com.nova.print.map.FoldDataGridMap;
	import com.nova.print.map.PrintDataMap;
	import com.nova.print.map.PrintMap;
	import com.nova.print.util.SetupInfo;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
	import mx.controls.dataGridClasses.DataGridColumn;

	public class NovaAdvancedDataGrid
	{
		private static var novaAdvancedDataGrid:NovaAdvancedDataGrid=null;
		private var _dataGridHeight:int=0;//计算表格的实际高度
		public static function getInstance():NovaAdvancedDataGrid
		{
			if(novaAdvancedDataGrid==null)
			{
				novaAdvancedDataGrid=new NovaAdvancedDataGrid();
			}
			return novaAdvancedDataGrid;
		}
		public function creatAdvancedDataGrid(advancedGrid:AdvancedDataGrid):void
		{
			var dataProvider:ArrayCollection=PrintDataMap.getSimple().getData(SetupInfo.getInstance().colCurrentPage-1);
			var currentPage:int=SetupInfo.getInstance().rowCurrentPage-((SetupInfo.getInstance().colCurrentPage-1)*SetupInfo.getInstance().rowPages)-1;
			var paperHeight:int=SetupInfo.getInstance().printPaperArr[1];
			var viewheight:int=paperHeight-SetupInfo.getInstance().printHeaderNum-SetupInfo.getInstance().printFooterNum-SetupInfo.getInstance().printBottom-SetupInfo.getInstance().printTop;
			advancedGrid.columns=new Array();
			var columnArr:Array=FoldAdvancedGridMap.getSimple().getColumnArrByID(currentPage) as Array;
			if(columnArr.length==0)
			{
				advancedGrid.width=0;
				advancedGrid.height=0;
				return;
			}
			var array:Array=[];
			for(var j:int=0;j<columnArr.length;j++)
			{
				var column:AdvancedDataGridColumn=new AdvancedDataGridColumn();
				column.dataField=getDataField(columnArr[j]);
				trace("---------创建的DataField：  "+column.dataField+"-------------------------------------------------------");
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
			advancedGrid.columns=array;
			advancedGrid.resizableColumns=true;
			advancedGrid.mouseChildren=true;
			advancedGrid.sortableColumns=false;
			advancedGrid.selectable=false;
			advancedGrid.allowDragSelection=false;
			advancedGrid.setStyle("alternatingItemColors",[0xffffff]);
			advancedGrid.setStyle("horizontalGridLines",true);
			advancedGrid.setStyle("horizontalGridLineColor",0xDEE2E3);
			advancedGrid.setStyle("verticalGridLineColor",0xDEE2E3);
			advancedGrid.setStyle("headerStyleName","header");
			advancedGrid.setStyle("chromeColor",0xffffff);
			advancedGrid.setStyle("fontFamily","SONG");
			advancedGrid.setStyle("fontSize",10);
			advancedGrid.verticalScrollPolicy="off";
			advancedGrid.rowHeight=25;
			advancedGrid.dataProvider=dataProvider;
			//总共显示的行数为  每页显示多少行+补空行数目
			var length:int=dataProvider.length;
			length=Math.max(0,length);
			advancedGrid.rowCount=length;
			//var gridHeight:Number=length*advancedGrid.rowHeight;
			//_dataGridHeight=gridHeight+advancedGrid.headerHeight+SetupInfo.getInstance().emptyRowNum*25;
		}
		/**
		 * 根据数组ID获取表格的DataField
		 * */
		public function getHeadText(value:int):String
		{
			if(value>=FoldDataGridMap.getInstance().columnArray.length) return "";
			else
				var array:Array=FoldAdvancedGridMap.getSimple().columnArray[value] as Array;	
			return array[1];
		}
		/**
		 * 根据数组ID获取表格的DataField的对齐方式
		 * */
		public function getTextAlign(value:int):String
		{
			if(value>=FoldDataGridMap.getInstance().columnArray.length) return "";
			else
				var array:Array=FoldAdvancedGridMap.getSimple().columnArray[value] as Array;	
			return array[3];
		}
		/**
		 * 根据数组ID获取表格的DataField
		 * */
		public function getDataField(value:int):String
		{
			if(value>=FoldDataGridMap.getInstance().columnArray.length) return "";
			else
				var array:Array=FoldAdvancedGridMap.getSimple().columnArray[value] as Array;	
			return array[2];
		}
		private function setAdvancedDataGridColumn(columnXml:XML):AdvancedDataGridColumn
		{
			var column:AdvancedDataGridColumn=new AdvancedDataGridColumn();
			column.headerText=columnXml.@headerText;
			column.dataField=columnXml.@dataField;
			return column;
		}
		private function setAdvancedDataGridColumnGroup(groupXml:XML):AdvancedDataGridColumnGroup
		{
			var columnGroup:AdvancedDataGridColumnGroup=new AdvancedDataGridColumnGroup();
			columnGroup.headerText=groupXml.@headerText;
			var array:Array=[];
			for(var i:int=0;i<groupXml.children().length();i++)
			{
				array.push(setAdvancedDataGridColumn(groupXml.children()[i]));
			}
			columnGroup.children=array;
			return columnGroup;
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