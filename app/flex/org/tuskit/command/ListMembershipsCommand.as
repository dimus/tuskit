package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.MembershipDelegate;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.components.admin_box.AdminState;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import org.tuskit.model.User;
    
    public class ListMembershipsCommand implements ICommand, IResponder {
        public function ListMemberships():void {     
        }

        public function execute(event : CairngormEvent) : void {
            var delegate : MembershipDelegate = new MembershipDelegate(this);
            delegate.listMemberships();
        }

        public function result(event : Object) : void {
            var result:XMLList = XMLList(event.result).children();
            var model : TuskitModelLocator = TuskitModelLocator.getInstance();
 			var adminState : AdminState = AdminState.getInstance();
 			var user:User;
 			model.setMemberships(result);
 			user = model.getUser(model.selectedUserId);
 			if (user != null) adminState.userInput = user;
 			else adminState.userInput = new User();
 			model.isInTransitionState = false;
 			adminState.resetFilter = 1 - adminState.resetFilter;
        }
    
        public function fault(event : Object) : void {
            //tuskit.debug("CreateSessionCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Cannot get list of memberships");
        }
    }
}