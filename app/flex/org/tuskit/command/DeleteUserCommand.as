package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.UserDelegate;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.control.EventNames;
    import org.tuskit.util.CairngormUtils;
    
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.controls.Alert;
    
    public class DeleteUserCommand implements ICommand, IResponder {
		private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
		
        public function DeleteUserCommand() {
        }

        public function execute(event : CairngormEvent) : void {
            var delegate : UserDelegate = new UserDelegate(this);
            delegate.deleteUser(event.data);
        }
        public function result(event : Object) : void {
        	try {
        	 	if (event.result.error == 'Foreign Key Problem') {
        			Alert.show("User is assigned to something. You cannot delete the User.", "Cannot Delete User");
        		}
	        }
        	catch(ReferenceError:Error){
        	}
        	_model.selectedUserId = -1;
			_model.getUsersGroupsMemberships();
        }
        
        public function fault(event : Object) : void {
            var faultEvent : FaultEvent = FaultEvent(event);
            //tuskit.debug("DeleteUserCommand#fault: " + faultEvent);
        }
    }
}