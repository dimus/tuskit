package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.SessionDelegate;
    import org.tuskit.model.User;
    import org.tuskit.model.Group;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.control.EventNames;
    import org.tuskit.util.CairngormUtils;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class DeleteSessionCommand implements ICommand, IResponder {
        public function DeleteSessionCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
        	var model : TuskitModelLocator =
                    TuskitModelLocator.getInstance();
            //model.reset();
            var delegate : SessionDelegate = new SessionDelegate(this);
            delegate.deleteSession();
        }

        public function result(event:Object) : void {
        	var model : TuskitModelLocator =
                    TuskitModelLocator.getInstance();
            model.currentLocation = TuskitModelLocator.LOCATOR_LOGIN;
        }
    
        public function fault(event : Object) : void {
            //tuskit.debug("DeleteSessionCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Logout Failed", "Error");
        }
    }
}