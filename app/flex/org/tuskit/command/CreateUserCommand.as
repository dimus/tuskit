package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.tuskit.business.UserDelegate;
    import org.tuskit.control.EventNames;
    import org.tuskit.model.Group;
    import org.tuskit.model.Membership;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.model.User;
    import org.tuskit.util.CairngormUtils;
    import org.tuskit.validators.ServerErrors;
    
    public class CreateUserCommand implements ICommand, IResponder {
    	
    	private var _groups:Object;
    	private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
    	
        public function CreateUserCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
            var delegate : UserDelegate = new UserDelegate(this);
            _groups = event.data.groups;
            delegate.createUser(event.data.user);
        }
        
		/**
		 * creates user and user's memberships
		 * or reports errors
		 */
        public function result(event : Object) : void {
        	var result:XML =  XML(event.result);        
        	var user:User = User.fromXML(result);
			if (user.id > 0) {	
				_model.selectedUserId = user.id;
				var group:Group;
				for each (group in _groups['toCreate']) {
					var membership:Membership = new Membership(user, group);
					CairngormUtils.dispatchEvent(EventNames.CREATE_MEMBERSHIP, 
						{membership:membership, toCommandsArray:true});
				}
				_model.executeCommandsArray();
		   	} else {
		   		handleErrors(result);
		   	}
        }
        
        private function handleErrors(result:XML) : void {
    		if (result.error == "Not Authorized"){
    			Alert.show("Not Authorized Access", "User Not Created");
    		} else {
    			Alert.show("Please Correct Input Errors", "User Not Created");
    			_model.userErrors = new ServerErrors(result);
    		}	
    	}
    
        public function fault(event : Object) : void {
        	_model.commandsArray = [];
            //tuskit.debug("CreateUserCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Unexpected Error", "User Not Created");
        }
    }
}