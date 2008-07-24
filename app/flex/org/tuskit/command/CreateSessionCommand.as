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
    
    public class CreateSessionCommand implements ICommand, IResponder {
        public function CreateSessionCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
            var delegate : SessionDelegate = new SessionDelegate(this);
            delegate.createSession(event.data.login, event.data.password);
        }

        public function result(event : Object) : void {
            var result:Object = event.result;
            if (event.result == "badlogin") {//TODO - use fault instead?
                Alert.show("Login failed.");
            } else {
                var model : TuskitModelLocator =
                    TuskitModelLocator.getInstance();
                model.currentUser = User.fromXML(XML(event.result));
                var groups:XMLList = XMLList(event.result.groups).children();
                var item:XML;
                for each (item in groups) {
                	model.currentUserGroups.addItem(Group.fromXML(XML(item)));
                }
                model.currentLocation = TuskitModelLocator.LOCATOR_MAIN;
            }
        }
    
        public function fault(event : Object) : void {
            //tuskit.debug("CreateSessionCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Login Failed", "Error");
        }
    }
}