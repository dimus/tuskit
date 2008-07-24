    		import org.tuskit.model.TuskitModelLocator;
    		import org.tuskit.components.admin_box.AdminState;
	    	
	    	
	    	[Bindable]
	    	private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();		 	
		 	
		 	[Bindable]
		 	private var _state:AdminState = AdminState.getInstance();
			


			private function init():void {
				_model.getUsersGroupsMemberships();
			}

