package com.nova.print.map
{
	import com.nova.print.util.SetupInfo;

	public class FoldAdvancedGridMap
	{
		private static var _simple:FoldAdvancedGridMap=null;
		private var _columnArray:Array=[];
		private var _columnIndexArray:Array=[];
		public static function getSimple():FoldAdvancedGridMap
		{
			if(_simple==null)
			{
				_simple=new FoldAdvancedGridMap();
			}
			return _simple;
		}
		private function PagesByFixInit():void
		{
			_columnArray=[];
			var groupXml:XML=LayoutMap.getSimple().advancedGridXml.children()[0] as XML;
			trace("groupXml:  "+groupXml);
			for(var i:int=0;i<groupXml.children().length();i++)
			{
				
				var xx:XML=groupXml.children()[i] as XML;
				if(xx.localName()=="AdvancedDataGridColumn" &&　xx.@visible!="false")
				{
					_columnArray.push(["0",xx.@headerText,xx.@dataField,xx.@textAlign,xx.@width]);
				}
				else if(xx.localName()=="AdvancedDataGridColumnGroup")
				{
					for(var j:int=0;j<xx.children().length();j++)
					{
						var xxx:XML=xx.children()[j] as XML;
						if(xxx.@visible!="false")
						{
							_columnArray.push([xx.@headerText,xxx.@headerText,xxx.@dataField,xxx.@textAlign,xxx.@width]);
						}
					}
				}
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
			/** 得到的变动的最列数目*/
			var length:int=LayoutMap.getSimple().allColumnIndex-fixRow;
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
				for(var end:int=(page-1)*SetupInfo.getInstance().printEndRow+fixRow;end<=LayoutMap.getSimple().allColumnIndex-1;end++)
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
			trace("_columnIndexArray:  "+_columnIndexArray);
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
			trace("总的列数目:  "+LayoutMap.getSimple().allColumnIndex);
			trace("根据列的分页数:"+_columnIndexArray.length);
			trace("根据列所取得的下标为： "+page);
			trace("取得的表格的数据为： "+_columnIndexArray[page]);
			trace("获取表格的相关数据---------------------------------------------------------end");
			return _columnIndexArray[page] as Array;
		}

		/** 记录所有需要显示的表格的数据*/
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

		public function get columnIndexArray():Array
		{
			return _columnIndexArray;
		}

		public function set columnIndexArray(value:Array):void
		{
			_columnIndexArray = value;
		}


	}
	
}