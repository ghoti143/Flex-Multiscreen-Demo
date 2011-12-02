package com.gisinc.showcase.multiscreen.model
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.layers.Layer;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class MapModel
	{
		public var currentParcel:Graphic;
		public var map:Map;
		public var extent:Extent;
		public var layers:ArrayCollection;
		public var infoSymbolLayer:GraphicsLayer;
		
		public function MapModel()
		{
		}
	}
}