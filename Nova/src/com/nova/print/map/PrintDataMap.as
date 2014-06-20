package com.nova.print.map
{
	import com.nova.print.util.SetupInfo;
	
	import flash.system.System;
	
	import mx.collections.ArrayCollection;

/**
 * 此类是保存根据数据行来进行分页的数据集合。
 * 更改每页显示行时调用此类
 * */
	public class PrintDataMap
	{
		
		private var _dataArray:Array=[];
		private static var _simple:PrintDataMap=null;
		public static function getSimple():PrintDataMap
		{
			if(_simple==null)
			{
				_simple=new PrintDataMap();
			}
			return _simple;
		}
		public function getData(index:int):ArrayCollection
		{
			return _dataArray[index];
		}
		public function initData():void
		{
			_dataArray=[];
			var length:int=DataMap.getSimple().gridData.length;
			var printNums:int=SetupInfo.getInstance().printRowNumber;
			SetupInfo.getInstance().colPages=Math.ceil(length/printNums);
			if(SetupInfo.getInstance().colPages==1)
			{
				_dataArray.push(DataMap.getSimple().gridData);
				return;
			}
			for(var i:int=1;i<SetupInfo.getInstance().colPages;i++)
			{
				var array:ArrayCollection=new ArrayCollection();
				var max:int=i*printNums;
				var min:int=(i-1)*printNums;
				for(var j:int=min;j<max;j++)
				{
					var obj:Object=DataMap.getSimple().gridData.getItemAt(j);
					array.addItem(obj);
				}
				_dataArray.push(array);
			}
			var endArrayCollection:ArrayCollection=new ArrayCollection();
			for(var k:int=(SetupInfo.getInstance().colPages-1)*printNums;k<length;k++)
			{
				endArrayCollection.addItem(DataMap.getSimple().gridData.getItemAt(k));
			}
			_dataArray.push(endArrayCollection);
			
		}
/**
 * 每个数据行分页所保存的数据集合
 * */
		public function get dataArray():Array
		{
			return _dataArray;
		}

		public function set dataArray(value:Array):void
		{
			_dataArray = value;
		}

	}
}