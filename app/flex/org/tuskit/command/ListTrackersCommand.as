package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.TrackerDelegate;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.util.CairngormUtils;
    import org.tuskit.control.EventNames;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class ListTrackersCommand implements ICommand, IResponder {
        
        private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
        
        public function execute(event : CairngormEvent) : void {
            if (event.data.toCommandsArray) {
            	event.data.toCommandsArray = false;
            	_model.commandsArray.push({command:this, event:event});
            }
			else {
	            var delegate : TrackerDelegate = new TrackerDelegate(this);
	            delegate.listTrackers();
			}
        }

        public function result(event : Object) : void {
            var result:XMLList = XMLList(event.result).children();
 			_model.setTrackers(result);
 			_model.commandsArrayDelete(this);
			if (_model.commandsArray.length == 0) {
				CairngormUtils.dispatchEvent(EventNames.LIST_PROJECTS, {toCommandsArray: false});
 			}
        }
    
        public function fault(event : Object) : void {
        	_model.commandsArray = [];
            //tuskit.debug("CreateSessionCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Cannot get list of trackers");
        }
    }
}