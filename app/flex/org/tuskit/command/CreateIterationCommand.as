package org.tuskit.command {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import mx.controls.Alert;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.tuskit.business.IterationDelegate;
    import org.tuskit.components.developer_box.DeveloperState;
    import org.tuskit.control.EventNames;
    import org.tuskit.model.Group;
    import org.tuskit.model.Iteration;
    import org.tuskit.model.Membership;
    import org.tuskit.model.Project;
    import org.tuskit.model.TuskitModelLocator;
    import org.tuskit.util.CairngormUtils;
    import org.tuskit.validators.ServerErrors;

    public class CreateIterationCommand implements ICommand, IResponder {

    	private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();
    	private var _devModel:DeveloperState = DeveloperState.getInstance();
		private var _project:Project;

        public function CreateIterationCommand():void {     
        }

        public function execute(event : CairngormEvent) : void {
        	var iteration:Iteration = event.data as Iteration;
        	_project = iteration.project;
            var delegate : IterationDelegate = new IterationDelegate(this);
            delegate.createIteration(iteration);
        }

		/**
		 * creates iteration and iteration's memberships
		 * or reports errors
		 */
        public function result(event : Object) : void {
        	var result:XMLList =  XMLList(event.result);
        	_model.setIterations(result);       
        	var iteration:Iteration = _model.getIteration(result.id);
        	iteration.project.selectedIteration = iteration;
        }

        private function handleErrors(result:XML) : void {
    		if (result.error == "Not Authorized"){
    			Alert.show("Not Authorized Access", "Iteration Not Created");
    		} else {
    			Alert.show("Please Correct Input Errors", "Iteration Not Created");
    			_model.iterationErrors = new ServerErrors(result);
    		}	
    	}

        public function fault(event : Object) : void {
        	_model.commandsArray = [];
            //tuskit.debug("CreateIterationCommand#fault, event = " + event);
            var faultEvent : FaultEvent = FaultEvent(event);
            Alert.show("Unexpected Error", "Iteration Not Created");
        }
    }
}
