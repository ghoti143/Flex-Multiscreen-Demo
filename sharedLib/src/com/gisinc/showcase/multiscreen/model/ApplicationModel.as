package com.gisinc.showcase.multiscreen.model
{
	[Bindable]
	public class ApplicationModel
	{
		public static const MOBILE_SCREEN_TYPE:String = "mobile";
		public static const KIOSK_SCREEN_TYPE:String = "kiosk";
		
		public var screenType:String;
		
		public function ApplicationModel()
		{
		}
	}
}