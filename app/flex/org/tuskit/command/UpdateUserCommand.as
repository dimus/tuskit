package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.UserDelegate;
    import org.tuskit.model.User;
    import org.tuskit.model.Group;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.control.EventNames;
    import org.tuskit.util.CairngormUtils;
    import org.tuskit.model.Membership;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class UpdateUserCommand implements ICommand, IResponder {
        
        private var _groups:Object;
        private var _user:User;
        private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
        
        public function UpdateUserCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
            var delegate : UserDelegate = new UserDelegate(this);
            _groups = event.data.groups;
            _user = event.data.user
            delegate.updateUser(event.data.user);
        }

        public function result(event : Object) : void {
			var group:Group;
			var membership:Membership;
			if (_groups['toDelete'].length + _groups['toCreate'].length > 0) {
				for each (group in _groups['toDelete']) {
					membership = _user.getMembership(group);
					CairngormUtils.dispatchEvent(EventNames.DELETE_MEMBERSHIP, {membership:membership, toCommandsArray:true});				
				}
				for each (group in _groups['toCreate']) {
					membership = new Membership(_user, group);
					CairngormUtils.dispatchEvent(EventNames.CREATE_MEMBERSHIP, 
						{membership:membership, toCommandsArray:true});
				}
				_model.executeCommandsArray();
			} else {
				_model.commandsArray = []
				_model.getUsersGroupsMemberships();
			} 
        }
      
        public function fault(event : Object) : void {
        	_model.commandsArray = [];
            //tuskit.debug("UpdateUserCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Updating User Failed", "Error");
        }
    }
}