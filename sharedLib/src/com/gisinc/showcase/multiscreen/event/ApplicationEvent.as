package com.gisinc.showcase.multiscreen.event
{
	import flash.events.Event;
	
	public class ApplicationEvent extends Event
	{
		public static const MOBILE_NAVIGATE:String = "mobileNavigation";
		
		public var view:String;
		
		public function ApplicationEvent(type:String, view:String=null)
		{
			super(type, true);
			
			this.view = view;
		}		
	}
}