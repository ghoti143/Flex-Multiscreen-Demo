package com.gisinc.showcase.multiscreen.pm
{
	import com.gisinc.showcase.multiscreen.event.MappingEvent;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	public class ParcelInfoSymbolPM
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;	
		
		[Bindable][Embed(source='assets/images/close_button.png')]
		public var close_button:Class;
		
		function ParcelInfoSymbolPM()
		{
		}
		
		public function handleCloseButtonClick(event:MouseEvent):void
		{
			dispatcher.dispatchEvent(new MappingEvent(MappingEvent.HIDE_INFO_WINDOW));	
		}
	}
}