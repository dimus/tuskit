package org.tuskit.components.admin_box {
	import com.adobe.cairngorm.model.ModelLocator;
	import org.tuskit.model.User;
	
	[Bindable]
	public class AdminState implements ModelLocator {
		
		public var userInput:User = new User();
		
		public var resetFilter:int = 0;
			
        //
        //Singleton stuff
        //
        private static var _adminState:AdminState;

        public static function getInstance():AdminState {
            if (_adminState == null) {
                _adminState = new AdminState();
            }
            return _adminState;
        }
        
        //The constructor should be private, but this is not possible in
        //ActionScript 3.0.  So, throwing an Error if a second
        //TuskitModelLocator is created is the best we can do to implement
        //the Singleton pattern.
        public function AdminState() {
            if (_adminState != null) {
                throw new Error(
                  "Only one TuskitModelLocator instance may be instantiated.");
            }
        }
	}
}
