import org.tuskit.util.CairngormUtils;
import org.tuskit.control.EventNames;
import org.tuskit.model.TuskitModelLocator;
import org.tuskit.components.developer_box.DeveloperState;
import org.tuskit.model.Project;
import org.tuskit.model.Iteration;

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

[Bindable]
private var _devModel:DeveloperState = DeveloperState.getInstance();

[Bindable]
public var iteration:Iteration;

private function init():void {
	
}

private function updateIteration():void {
	var itr:Iteration = iteration;
	itr.name = editIteration.iterationName.text;
	itr.objectives = editIteration.objectives.text;
	itr.startDate = editIteration.startDate.selectedDate;
	itr.endDate = editIteration.endDate.selectedDate;
	itr.workUnits = editIteration.workUnits.value;
	_model.isInTransitionState=true;
	CairngormUtils.dispatchEvent(EventNames.UPDATE_ITERATION, itr);	
}
