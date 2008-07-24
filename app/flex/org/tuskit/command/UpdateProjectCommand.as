package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.tuskit.business.ProjectDelegate;
    import org.tuskit.control.EventNames;
    import org.tuskit.model.Project;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.util.CairngormUtils;
    
    public class UpdateProjectCommand implements ICommand, IResponder {
        
        private var _project:Project;
        private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
        
        public function UpdateProjectCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
            var delegate : ProjectDelegate = new ProjectDelegate(this);
            _project = event.data
            delegate.updateProject(_project);
        }

        public function result(event : Object) : void {
			_model.getTrackersProjects();
        }
      
        public function fault(event : Object) : void {
        	_model.commandsArray = [];
            //tuskit.debug("UpdateProjectCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Updating Project Failed", "Error");
        }
    }
}