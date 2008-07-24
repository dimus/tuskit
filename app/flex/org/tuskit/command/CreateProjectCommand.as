package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;

    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;

    import org.tuskit.business.ProjectDelegate;
    import org.tuskit.control.EventNames;
    import org.tuskit.model.Group;
    import org.tuskit.model.Membership;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.model.Project;
    import org.tuskit.util.CairngormUtils;
    import org.tuskit.validators.ServerErrors;
    import org.tuskit.components.developer_box.DeveloperState;

    public class CreateProjectCommand implements ICommand, IResponder {

    	private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
    	private var _devModel:DeveloperState = DeveloperState.getInstance();

        public function CreateProjectCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
            var delegate : ProjectDelegate = new ProjectDelegate(this);
            delegate.createProject(event.data);
        }

		/**
		 * creates project and project's memberships
		 * or reports errors
		 */
        public function result(event : Object) : void {
        	var result:XML =  XML(event.result);        
        	var project:Project = Project.fromXML(result);
			if (project.id > 0) {
				_model.getTrackersProjects();
				_devModel.currentProject = project;
				_devModel.currentProjectLocation = _devModel.PROJECT_MEMBERS;
				_devModel.triggerNewProjectTab = 1 - _devModel.triggerNewProjectTab;
		   	} else {
		   		handleErrors(result);
		   	}
        }

        private function handleErrors(result:XML) : void {
    		if (result.error == "Not Authorized"){
    			Alert.show("Not Authorized Access", "Project Not Created");
    		} else {
    			Alert.show("Please Correct Input Errors", "Project Not Created");
    			_model.projectErrors = new ServerErrors(result);
    		}	
    	}

        public function fault(event : Object) : void {
        	_model.commandsArray = [];
            //tuskit.debug("CreateProjectCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Unexpected Error", "Project Not Created");
        }
    }
}
