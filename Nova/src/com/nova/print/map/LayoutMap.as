package com.nova.print.map
{
	import com.nova.print.util.SetupInfo;
	
	import mx.containers.Grid;

	/**
	 * 此类解析传递过来的界面XML
	 * 上部分XML,下部分XML,表格XML分别进行保存。 
	 * */
	public class LayoutMap
	{
		private var _topXml:XML=null;
		private var _bottomXml:XML=null;
		private var _gridXml:XML=null;
		private var _advancedGridXml:XML=null;
		private var _layoutXml:XML=null;
		private var _declarationsXml:XML=null;
		private var _gridType:int=0;
		private var _allColumnIndex:int=0;
		private static var _simple:LayoutMap=null;
		public static function getSimple():LayoutMap
		{
			if(_simple==null)
			{
				_simple=new LayoutMap();
			}
			return _simple;
		}
/**
 * 此方法用于解析所有界面的接口
 * 界面xml分别进行保存
 * */
		public function setLayout(xml:XML):void
		{
			_layoutXml=xml;
			_allColumnIndex=0;
			for(var i:int=0;i<xml.children().length();i++)
			{
				var xx:XML=xml.children()[i] as XML;
				if(xx.localName()=="BorderContainer")
				{
					if(xx.@id=="top")
					{
						_topXml=xx;
					}
					else
					{
						_bottomXml=xx;
					}
				}
				else if(xx.localName()=="AdvancedDataGrid")
				{
					creatAdvancedXml(xx);
				}
				else if(xx.localName()=="DataGrid")
				{
					creatDataGridXml(xx);
				}
				else if(xx.localName()=="Declarations")
				{
					creatDeclarationsXml(xx);
				}
			}
			if(_allColumnIndex>=4)
			{
				SetupInfo.getInstance().printEndRow=3;
			}
			else
			{
				SetupInfo.getInstance().printEndRow=_allColumnIndex-1;
			}
			if(_bottomXml==null)
			{
				_bottomXml= new XML(<BorderContainer x="0" y="0" id="bottom"/>);
			}
			if(_topXml==null)
			{
				_topXml= new XML(<BorderContainer x="0" y="0" id="top"/>);
			}
		}
		private function creatAdvancedXml(xx:XML):void
		{
			_gridType=1;
			SetupInfo.getInstance().hasGrid=true;
			_advancedGridXml=<AdvancedDataGrid></AdvancedDataGrid>;
			_advancedGridXml.@x=xx.@x;
			_advancedGridXml.@y=xx.@y;
			_advancedGridXml.@width=xx.@width;
			_advancedGridXml.@height=xx.@height;
			_advancedGridXml.@id=xx.@id;
			var groupXml:XML=xx.children()[0] as XML;
			for(var j:int=0;j<groupXml.children().length();j++)
			{
				var xxx:XML=groupXml.children()[j] as XML;
				if(xxx.localName()=="AdvancedDataGridColumn")
				{
					var visible:String=xxx.@visible;
					if(visible!="false")
					{
						visible="true";
						PrintMap.getSimple().creatRecordDataFieldArray(xxx.@dataField,xxx.@width);
						_allColumnIndex++;
					}
					_advancedGridXml.appendChild(<AdvancedDataGridColumn visible={visible} textAlign={xxx.@textAlign} width={xxx.@width} dataField={xxx.@dataField} headerText={xxx.@headerText} />);
				}
				else
				{
					var groupChildXml:XML=new XML(<groupColumn headerText={xxx.@headerText}></groupColumn>);
					for(var k:int=0;k<xxx.children().length();k++)
					{
						var xxxx:XML=xxx.children()[k] as XML;
						var groupVisible:String=xxxx.@visible;
						if(groupVisible!="false")
						{
							groupVisible="true";
							PrintMap.getSimple().creatRecordDataFieldArray(xxxx.@dataField,xxxx.@width);
							_allColumnIndex++;
						}
						groupChildXml.appendChild(<AdvancedDataGridColumn visible={groupVisible} textAlign={xxxx.@textAlign} width={xxxx.@width} dataField={xxxx.@dataField} headerText={xxxx.@headerText} />)
					}
					_advancedGridXml.appendChild(groupChildXml);
				}
			}
			trace("AdvancedDataGridXml: "+_advancedGridXml);
		}
		private function creatDataGridXml(xx:XML):void
		{
			_gridType=0;
			SetupInfo.getInstance().hasGrid=true;
			_gridXml=<Grid></Grid>;
			_gridXml.@x=xx.@x;
			_gridXml.@y=xx.@y;
			_gridXml.@width=xx.@width;
			_gridXml.@height=xx.@height;
			_gridXml.@id=xx.@id;
			var groupXml:XML=xx.children()[0] as XML;
			for(var j:int=0;j<groupXml.children().length();j++)
			{
				var xxx:XML=groupXml.children()[j] as XML;
				var visible:String=xxx.@visible;
				if(visible!="false")
				{
					visible="true";
					_allColumnIndex++;
					PrintMap.getSimple().creatRecordDataFieldArray(xxx.@dataField,xxx.@width);
				}
				_gridXml.appendChild(<DataGridColumn visible={visible} textAlign={xxx.@textAlign} width={xxx.@width} dataField={xxx.@dataField} headerText={xxx.@headerText} />);
			}
			trace("创建的单表格数据： "+_gridXml);
		}
		private function creatDeclarationsXml(xx:XML):void
		{
			_declarationsXml=xx;
		}
/**
 *此方法用来更新表格列的visible属性。
 * 用于保存和表格界面显示 
*/
		public function findGridVisible(headText:String):void
		{
			for(var i:int=0;i<_gridXml.children().length();i++)
			{
				var xx:String=_gridXml.children()[i].@headerText;
				var width:int=_gridXml.children()[i].@width;
				var textAlign:String=_gridXml.children()[i].@textAlign;
				var vi:String=_gridXml.children()[i].@visible;
				if(xx==headText)
				{
					if(vi=="false")
					{
						vi="true";
					}
					else
					{
						vi="false";
					}
				}
				_gridXml.children()[i].@visible=vi;
			}
		}
		public function gridVisibleAll():void
		{
			for(var i:int=0;i<_gridXml.children().length();i++)
			{
				_gridXml.children()[i].@visible="true";
			}
		}
		public function get topXml():XML
		{
			return _topXml;
		}

		public function set topXml(value:XML):void
		{
			_topXml = value;
		}

		public function get bottomXml():XML
		{
			return _bottomXml;
		}

		public function set bottomXml(value:XML):void
		{
			_bottomXml = value;
		}

		public function get gridXml():XML
		{
			return _gridXml;
		}

		public function set gridXml(value:XML):void
		{
			_gridXml = value;
		}

		public function get layoutXml():XML
		{
			return _layoutXml;
		}

		public function set layoutXml(value:XML):void
		{
			_layoutXml = value;
		}
/**
 * 保存其他属性
 * */
		public function get declarationsXml():XML
		{
			return _declarationsXml;
		}

		public function set declarationsXml(value:XML):void
		{
			_declarationsXml = value;
		}
/**
 * 多表头的界面XML
 * */
		public function get advancedGridXml():XML
		{
			return _advancedGridXml;
		}

		public function set advancedGridXml(value:XML):void
		{
			_advancedGridXml = value;
		}
/**
 * 标识区别表格或者多表头表格的属性
 * 0为单表格
 * 1为多表头表格
 * */
		public function get gridType():int
		{
			return _gridType;
		}

		public function set gridType(value:int):void
		{
			_gridType = value;
		}
/**
 * 所有要应该显示的表格列的个数
 * 
 * */
		public function get allColumnIndex():int
		{
			return _allColumnIndex;
		}

		public function set allColumnIndex(value:int):void
		{
			_allColumnIndex = value;
		}


	}
}