package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.UserDelegate;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.util.CairngormUtils;
    import org.tuskit.control.EventNames;
 
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class ListUsersCommand implements ICommand, IResponder {
        private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
        
        public function ListUsers():void {     
        }

        public function execute(event : CairngormEvent) : void {
            if (event.data.toCommandsArray) {
            	event.data.toCommandsArray = false;
            	_model.commandsArray.push({command:this, event:event});
            }
			else {
	            var delegate : UserDelegate = new UserDelegate(this);
	            delegate.listUsers();
			}
        }

        public function result(event : Object) : void {
            var result:XMLList = XMLList(event.result).children();
 			_model.setUsers(result);
 			_model.commandsArrayDelete(this);
 			if (_model.commandsArray.length == 0){
				CairngormUtils.dispatchEvent(EventNames.LIST_MEMBERSHIPS);
 			}

        }
    
        public function fault(event : Object) : void {
        	_model.commandsArray=[];
            //tuskit.debug("CreateSessionCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Cannot get list of users");
        }
    }
}