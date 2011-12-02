package com.gisinc.showcase.multiscreen.controller
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.events.MapMouseEvent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
	import com.esri.ags.layers.FeatureLayer;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	import com.gisinc.showcase.multiscreen.event.ApplicationEvent;
	import com.gisinc.showcase.multiscreen.event.MappingEvent;
	import com.gisinc.showcase.multiscreen.model.ApplicationModel;
	import com.gisinc.showcase.multiscreen.model.MapModel;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.utils.services.ServiceHelper;

	public class MapController 
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var sh:ServiceHelper;
		
		[Inject]
		public var mapModel:MapModel;
		
		[Inject]
		public var applicationModel:ApplicationModel;
		
		[Embed(source='assets/images/marker_red.png')]
		public var marker_red:Class;
		
		private var selectCursorId:int;
		
		[PostConstruct]
		public function init():void
		{
			mapModel.extent = new Extent(-9276552, 5239734, -9261711, 5255311);
			
			var basemap:ArcGISTiledMapServiceLayer = new ArcGISTiledMapServiceLayer("http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer");
			var parcels:ArcGISDynamicMapServiceLayer = new ArcGISDynamicMapServiceLayer("http://localgovtemplates2.esri.com/ArcGIS/rest/services/Bloomfield/TaxParcelQuery/MapServer");
			
			mapModel.layers = new ArrayCollection([basemap, parcels]);
			
			createInfoSymbolLayer();
		}
		
		[EventHandler("MappingEvent.REGISTER_MAP_OBJECT", properties="map")]
		public function handleRegisterMapObject(map:Map):void
		{
			mapModel.map = map;
		}
		
		[EventHandler("MappingEvent.ENABLE_IDENTIFY")]
		public function handleEnableIdentify():void
		{
			mapModel.map.addEventListener(MapMouseEvent.MAP_CLICK, handleMapClick);
			mapModel.map.panEnabled = false;
			selectCursorId = CursorManager.setCursor(marker_red, 2, -9, -32);
		}
		
		[EventHandler("MappingEvent.MAP_CLICK", properties="mapPoint")]
		public function handleMapClick(event:MapMouseEvent):void
		{
			removeCursorAndClickListener();
			
			var mapPoint:MapPoint = event.mapPoint;
			
			var qt:QueryTask = new QueryTask("http://localgovtemplates2.esri.com/ArcGIS/rest/services/Bloomfield/TaxParcelQuery/MapServer/0");
			qt.showBusyCursor = true;
			
			var query:Query = new Query();
			query.geometry = mapPoint;
			query.spatialRelationship = Query.SPATIAL_REL_INTERSECTS;
			query.returnGeometry = true;
			query.outFields = ["*"];
			
			var call:AsyncToken = qt.execute(query);
			sh.executeServiceCall(call, queryParcelsResultHandler, queryParcelsFaultHandler);		
		}
		
		[EventHandler("MappingEvent.HIDE_INFO_WINDOW")]
		public function handleHideInfoWindow():void
		{
			mapModel.infoSymbolLayer.clear();
			mapModel.map.panEnabled = true;
		}
		
		[EventHandler("MappingEvent.ADD_INFO_GRAPHIC", properties="graphic")]
		public function handleAddInfoGraphic(graphic:Graphic):void
		{
			mapModel.infoSymbolLayer.clear();
			mapModel.infoSymbolLayer.add(graphic);
		}
		
		private function removeCursorAndClickListener():void
		{
			mapModel.map.removeEventListener(MapMouseEvent.MAP_CLICK, handleMapClick);
			CursorManager.removeCursor(selectCursorId);
			mapModel.map.panEnabled = true;
		}
		
		private function queryParcelsResultHandler(fs:FeatureSet):void
		{
			mapModel.currentParcel = fs.features[0] as Graphic;
			
			var e:MappingEvent = new MappingEvent(MappingEvent.PARCEL_DETAILS_LOADED);
			e.graphic = mapModel.currentParcel;
			dispatcher.dispatchEvent(e);
		}
		
		private function queryParcelsFaultHandler(event:FaultEvent):void
		{
			// do nothing
		}
		
		private function createInfoSymbolLayer():void
		{
			mapModel.infoSymbolLayer = new GraphicsLayer();
			mapModel.infoSymbolLayer.addEventListener(MouseEvent.MOUSE_OVER, handleInfoSymbolLayerMouseOver);
			mapModel.infoSymbolLayer.addEventListener(MouseEvent.MOUSE_OUT, handleInfoSymbolLayerMouseOut);
			
			mapModel.layers.addItem(mapModel.infoSymbolLayer);
		}
		
		private function handleInfoSymbolLayerMouseOver(event:MouseEvent):void
		{
			mapModel.map.panEnabled = false;
		}
		
		private function handleInfoSymbolLayerMouseOut(event:MouseEvent):void
		{
			mapModel.map.panEnabled = true;
		}
	}
}