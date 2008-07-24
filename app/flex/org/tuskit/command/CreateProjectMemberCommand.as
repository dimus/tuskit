package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.tuskit.business.ProjectMemberDelegate;
    import org.tuskit.control.EventNames;
    import org.tuskit.model.Project;
    import org.tuskit.model.ProjectMember;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.util.CairngormUtils;
    
    public class CreateProjectMemberCommand implements ICommand, IResponder {

		private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
		private var _project:Project;
    	
        public function CreateProjectMemberCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
			var projectMember:ProjectMember = event.data;
			_project = projectMember.project;
			var delegate : ProjectMemberDelegate = new ProjectMemberDelegate(this);
			delegate.createProjectMember(projectMember);			
        }

        public function result(event : Object) : void {
 			_model.commandsArrayDelete(this);
			if (_model.commandsArray.length == 0){
				_project.projectMembers.source=[];
				_model.getProjectMembers(_project);
			}
        }
    
        public function fault(event : Object) : void {
        	_model.commandsArray = [];
            //tuskit.debug("CreateProjectMemberCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Creating ProjectMember Failed", "Error");
        }
    }
}