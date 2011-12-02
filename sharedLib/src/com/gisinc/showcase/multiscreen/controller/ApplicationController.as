package com.gisinc.showcase.multiscreen.controller
{
	import com.gisinc.showcase.multiscreen.model.ApplicationModel;
	
	import flash.events.IEventDispatcher;

	public class ApplicationController 
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var applicationModel:ApplicationModel;
		
		public function ApplicationController()
		{
		}
	}
}