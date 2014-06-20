package com.nova.print.map
{
	import com.nova.print.util.SetupInfo;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;

	/**
	 * 此类存储所有传递过来的Data数据
	 * 所有的文本数据和表格数据
	 * */
	public class DataMap
	{
		private var _tfData:ArrayCollection=null;
		private var _gridData:ArrayCollection=null;
		private var _dataXml:XML=null;
		private static var simple:DataMap=null;
		public static function getSimple():DataMap
		{
			if(simple==null)
			{
				simple=new DataMap();
			}
			return simple;
		}
/**
 * 此方法是接受js传递过来的数据接口
 * 表格和文本分别进行保存
 * */
		public function setData(value:XML):void
		{
			_dataXml=value;
			setTfData();
			setGridData();
		}
		private function setTfData():void
		{
			_tfData=new ArrayCollection();
			for(var i:int=0;i<_dataXml.children().length();i++)
			{
				var item:XML=_dataXml.children()[i] as XML;
				if(item.localName()!="DataGrid")
				{
					var object:Object=new Object();
					object.id=item.localName();
					object.text=_dataXml.children()[i];
					_tfData.addItem(object);
				}
			}
		}
		private function setGridData():void
		{
			_gridData=new ArrayCollection();
			var dataXml:XML=new XML(_dataXml.DataGrid.RowData);;
			var colXml:XML=new XML(_dataXml.DataGrid.ColModel);
			var colArr:Array=[];
			for(var i:int=0;i<colXml.children().length();i++)
			{
				colArr.push(colXml.children()[i].@DataField);
			}
			for(var j:int=0;j<dataXml.children().length();j++)
			{
				var item:XML=dataXml.children()[j] as XML;
				var obj:Object=new Object();
				for(var c:int=0;c<colArr.length;c++)
				{
					var str:String=colArr[c];
					obj[colArr[c]]=item.@[str];
				}
				_gridData.addItem(obj);
			}
			
		}
		public function get tfData():ArrayCollection
		{
			return _tfData;
		}

		public function set tfData(value:ArrayCollection):void
		{
			_tfData = value;
		}

		public function get gridData():ArrayCollection
		{
			return _gridData;
		}

		public function set gridData(value:ArrayCollection):void
		{
			_gridData = value;
		}

		public function get dataXml():XML
		{
			return _dataXml;
		}

		public function set dataXml(value:XML):void
		{
			_dataXml = value;
		}


	}
}