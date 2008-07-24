package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.tuskit.business.ProjectMemberDelegate;
    import org.tuskit.control.EventNames;
    import org.tuskit.model.ProjectMember;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.util.CairngormUtils;
    
    public class UpdateProjectMemberCommand implements ICommand, IResponder {
        
        private var _projectMember:ProjectMember;
        private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
        
        public function UpdateProjectMemberCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
            var delegate : ProjectMemberDelegate = new ProjectMemberDelegate(this);
            _projectMember = event.data;
            delegate.updateProjectMember(_projectMember);
        }

        public function result(event : Object) : void {
        }
      
        public function fault(event : Object) : void {
            //tuskit.debug("UpdateProjectMemberCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Updating ProjectMember Failed", "Error");
        }
    }
}