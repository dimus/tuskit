package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.tuskit.business.IterationDelegate;
    import org.tuskit.control.EventNames;
    import org.tuskit.model.Project;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.util.CairngormUtils;
    import org.tuskit.model.Iteration;
    
    public class UpdateIterationCommand implements ICommand, IResponder {
        
        private var _project:Project;
        private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
        
        public function UpdateIterationCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
            var delegate : IterationDelegate = new IterationDelegate(this);
            var iteration:Iteration = event.data;
            _project = iteration.project
            delegate.updateIteration(iteration);
        }

        public function result(event : Object) : void {
        	_model.isInTransitionState=false;
        }
      
        public function fault(event : Object) : void {
        	_model.commandsArray = [];
            //tuskit.debug("UpdateProjectCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Updating Iteration Failed", "Error");
        }
    }
}