package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.MembershipDelegate;
    import org.tuskit.model.Membership;
    import org.tuskit.model.Group;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.control.EventNames;
    import org.tuskit.util.CairngormUtils;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class CreateMembershipCommand implements ICommand, IResponder {

    	private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
    	    	
        public function CreateMembershipCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
            var membership:Membership = event.data.membership;
            if (event.data.toCommandsArray) {
            	event.data.toCommandsArray = false;
            	_model.commandsArray.push({command:this, event:event});
        	}
            else {
	            var delegate : MembershipDelegate = new MembershipDelegate(this);
	            delegate.createMembership(membership);
            }
        }

        public function result(event : Object) : void {
 			_model.commandsArrayDelete(this);
			if (_model.commandsArray.length == 0){
				_model.getUsersGroupsMemberships();
			}
        }
    
        public function fault(event : Object) : void {
        	_model.commandsArray = [];
            //tuskit.debug("CreateMembershipCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Creating Membership Failed", "Error");
        }
    }
}