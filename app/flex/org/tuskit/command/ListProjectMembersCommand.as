package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import org.tuskit.business.ProjectMemberDelegate;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.components.admin_box.AdminState;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import org.tuskit.model.User;
    import org.tuskit.model.Project;
    import org.tuskit.model.ProjectMember;
    
    
    public class ListProjectMembersCommand implements ICommand, IResponder {

	    private var _project:Project;

        public function ListProjectMembers():void {    
        }

        public function execute(event : CairngormEvent) : void {
        	_project = event.data;
            var delegate : ProjectMemberDelegate = new ProjectMemberDelegate(this);
            delegate.listProjectMembers(_project);
        }

        public function result(event : Object) : void {
            var result:XMLList = XMLList(event.result).children();
            var model : TuskitModelLocator = TuskitModelLocator.getInstance();
 			model.setProjectMembers(result);
 			//_project.projectMembers.source.sort(sortMembers);
 			model.isInTransitionState = false;
        }
    
        public function fault(event : Object) : void {
            //tuskit.debug("CreateSessionCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Cannot get list of project members");
        }
        
        public function sortMembers(item1:ProjectMember,item2:ProjectMember):int {
        	if (item1.user.last_name > item2.user.last_name) return 1
			else if (item1.user.last_name < item2.user.last_name) return -1
			else return 0;         	
        }
    }
}