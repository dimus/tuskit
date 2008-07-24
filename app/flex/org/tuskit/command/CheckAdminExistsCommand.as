package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.AdminExistsDelegate; //TODO make it more restful
    import org.tuskit.model.TuskitModelLocator;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class CheckAdminExistsCommand implements ICommand, IResponder {
        public function CheckAdminExists():void {     
        }

        public function execute(event : CairngormEvent) : void {
            var delegate : AdminExistsDelegate = new AdminExistsDelegate(this);
            delegate.checkAdminExists();
        }

        public function result(event : Object) : void {
            var result:Object = event.result;
            var model : TuskitModelLocator =
                    TuskitModelLocator.getInstance();
            if (event.result.admin_exists.toString() != 'true'){
    			model.currentLocation = TuskitModelLocator.LOCATOR_INIT;
            }
            else {
            	model.currentLocation = TuskitModelLocator.LOCATOR_LOGIN;
            }
        }
    
        public function fault(event : Object) : void {
            //tuskit.debug("CreateSessionCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Could not check if admin exists in database");
        }
    }
}