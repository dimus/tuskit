package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.MembershipDelegate;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.control.EventNames;
    import org.tuskit.util.CairngormUtils;
    import org.tuskit.model.Membership;
    
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class DeleteMembershipCommand implements ICommand, IResponder {

    	private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();


        public function DeleteMembershipCommand() {
        }
		
        public function execute(event : CairngormEvent) : void {
            var membership:Membership = event.data.membership;
            if (event.data.collectCommandsToArray) {
            	event.data.collectCommandsToArray = false;
            	_model.commandsArray.push({command:this, event:event});
        	}
            else {
	            var delegate : MembershipDelegate = new MembershipDelegate(this);
	            delegate.deleteMembership(event.data.membership);
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
            var faultEvent : FaultEvent = FaultEvent(event);
            //tuskit.debug("DeleteMembershipCommand#fault: " + faultEvent);
        }
    }
}