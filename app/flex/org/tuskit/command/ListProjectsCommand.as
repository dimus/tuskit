package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.ProjectDelegate;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.util.CairngormUtils;
    import org.tuskit.control.EventNames;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    public class ListProjectsCommand implements ICommand, IResponder {
        
        private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
        
        public function execute(event : CairngormEvent) : void {
            if (event.data.toCommandsArray) {
            	event.data.toCommandsArray = false;
            	_model.commandsArray.push({command:this, event:event});
            }
			else {
	            var delegate : ProjectDelegate = new ProjectDelegate(this);
	            delegate.listProjects();
			}
        }
 
        public function result(event : Object) : void {
            var result:XMLList = XMLList(event.result).children();
 			_model.setProjects(result);
 			_model.setProjectsTree();
 			_model.commandsArrayDelete(this);
 			_model.isInTransitionState = false;
			CairngormUtils.dispatchEvent(EventNames.LIST_CURRENT_ITERATIONS, {toCommandsArray: false});	
			//if (_model.commandsArray.length == 0){
			//
 			//}
        }
    
        public function fault(event : Object) : void {
        	_model.commandsArray = [];
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Cannot get list of projects");
        }
    }
}