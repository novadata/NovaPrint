/**
 * 
 * 此类解析折页的相关属性
 * 保存折页后的表格属性
 * */
package  com.nova.print.map
{
	import com.nova.print.control.NovaDataGrid;
	import com.nova.print.util.SetupInfo;
	
	import flashx.textLayout.formats.ITabStopFormat;
	
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.EdgeMetrics;

	public class FoldDataGridMap
	{
		private static var fdMap:FoldDataGridMap=null;
		/**  表格的默认宽度*/
		public var columnDefaultWidth:int=100;
		/** 记录所有需要显示的表格的数据*/
		private var _columnArray:Array=[];
		private var _columnIndexArray:Array=[];
		public  var allColumnNum:int=0;
		public static function getInstance():FoldDataGridMap
		{
			if(fdMap==null)
			{
				fdMap=new FoldDataGridMap();
			}
			return fdMap;
		}
		public function PagesByFixInit():void
		{
			allColumnNum=0;
			_columnArray=[];
			for(var i:int=0;i<LayoutMap.getSimple().gridXml.children().length();i++)
			{
				
				var xx:XML=LayoutMap.getSimple().gridXml.children()[i] as XML;
				if(xx.@visible!="false")
				{
					allColumnNum++;
					_columnArray.push([xx.@headerText,xx.@dataField,xx.@textAlign,xx.@width]);
				}
			}
			 if(allColumnNum<LayoutMap.getSimple().allColumnIndex)
			 {
				SetupInfo.getInstance().gridHeadCheckBol=false;
			 }
			 else
			 {
				 SetupInfo.getInstance().gridHeadCheckBol=true;
			 }
			 if(allColumnNum<=1)
			 {
				 SetupInfo.getInstance().gridIsEnable=false;
			 }
			 else
			 {
				 SetupInfo.getInstance().gridIsEnable=true;
			 }
		}
		/**
		 * 固定方式折页
		 * */
		public function getPagesByFix():void
		{
			PagesByFixInit();
			_columnIndexArray=[];
			/** 纸张宽度*/
			var paperWidth:int=SetupInfo.getInstance().paperWidthSize;
			/** 默认固定列*/
			var fixRow:int=SetupInfo.getInstance().printFirstRow;
			var fixWidth:int=columnDefaultWidth*2;
			/** 剩余的列的宽度*/
			var getRowWidht:int=paperWidth-fixWidth;
			/** 得到的变动的最列数目*/
			var length:int=allColumnNum-fixRow;
			SetupInfo.getInstance().printFoldMax=length;
			var page:int=Math.ceil(length/SetupInfo.getInstance().printEndRow);
			var fixArr:Array=[];
			for(var fix:int=0;fix<fixRow;fix++)
			{
				fixArr.push(fix);
			}
			for(var i:int=0;i<page-1;i++)
			{
				var array:Array=[];
				array=array.concat(fixArr);
				for(var j:int=0;j<SetupInfo.getInstance().printEndRow;j++)
				{
					array.push(i*SetupInfo.getInstance().printEndRow+fixRow+j);	
				}
				_columnIndexArray.push(array);
			}
			if(length>0)
			{
				var endArray:Array=[];
				endArray=endArray.concat(fixArr);
				for(var end:int=(page-1)*SetupInfo.getInstance().printEndRow+fixRow;end<=allColumnNum-1;end++)
				{
					endArray.push(end);
				}
				_columnIndexArray.push(endArray);
			}
			else
			{
				_columnIndexArray.push(fixArr);
			}
			SetupInfo.getInstance().rowPages=page;
		}
		
		/**
		 * 变动方式折页
		 * */
		public function getPageByChange():void
		{
			PagesByFixInit();
			_columnIndexArray=[];
			/** 纸张宽度*/
			var paperWidth:int=SetupInfo.getInstance().paperWidthSize;
			/** 默认第一页列数*/
			var changeRow:int=SetupInfo.getInstance().printFirstRow;
			/** 后几页列数*/
			var endRow:int=SetupInfo.getInstance().printEndRow;
			var length:int=allColumnNum-changeRow;
			SetupInfo.getInstance().printFoldMax=length;
			var page:int=Math.ceil(length/endRow);
			/** 第一页默认列的列*/
			var defaultArr:Array=[];
			for(var defaultRow:int=0;defaultRow<changeRow;defaultRow++)
			{
				defaultArr.push(defaultRow);
			}
			_columnIndexArray.push(defaultArr);;
			for(var i:int=0;i<page-1;i++)
			{
				var array:Array=[];
				for(var j:int=0;j<endRow;j++)
				{
					array.push(endRow*i+changeRow+j);
				}
				_columnIndexArray.push(array);
			}
			if(allColumnNum>1)
			{
				var endArr:Array=[];
				var okArr:Array=_columnIndexArray[_columnIndexArray.length-1] as Array;
				var endNum:int=okArr[okArr.length-1]+1;
				for(var end:int=endNum;end<=allColumnNum-1;end++)
				{
					endArr.push(end);
				}
				_columnIndexArray.push(endArr);
			}
			SetupInfo.getInstance().rowPages=page+1;
		}
/**
 * 根据当前页获取表格的数据   
 * 注意此处的当前页是减掉过
 * 即：当前为第一页时   传递的数据为0；
 * */
		public function getColumnArrByID(value:int):Array
		{
			var col:int=Math.ceil((value+1)/SetupInfo.getInstance().rowPages);
			var page:int=value-(col-1)*SetupInfo.getInstance().rowPages;
			trace("获取表格的相关数据-------------------------------------------------------start");
			trace("当前的页数:  "+value);
			trace("总的列数目:  "+allColumnNum);
			trace("根据列的分页数:"+_columnIndexArray.length);
			trace("根据列所取得的下标为： "+page);
			trace("取得的表格的数据为： "+_columnIndexArray[page]);
			trace("获取表格的相关数据---------------------------------------------------------end");

			return _columnIndexArray[page] as Array;
		}

		/** 存储对表格动态分配的列*/
		public function get columnArray():Array
		{
			return _columnArray;
		}

		/**
		 * @private
		 */
		public function set columnArray(value:Array):void
		{
			_columnArray = value;
		}

		/**  记录所有的表格下标*/
		public function get columnIndexArray():Array
		{
			return _columnIndexArray;
		}

		/**
		 * @private
		 */
		public function set columnIndexArray(value:Array):void
		{
			_columnIndexArray = value;
		}


	}
}