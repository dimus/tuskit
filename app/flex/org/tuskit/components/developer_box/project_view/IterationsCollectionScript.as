// ActionScript file
import org.tuskit.model.TuskitModelLocator;
import org.tuskit.components.developer_box.DeveloperState;
import org.tuskit.model.Iteration;
import org.tuskit.model.Project;
import mx.controls.dataGridClasses.DataGridColumn;
import lib.TuskitLib;
import mx.controls.Alert;
import org.tuskit.util.CairngormUtils;
import org.tuskit.control.EventNames;

[Bindable]
public var project:Project;

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

[Bindable]
private var _devModel:DeveloperState = DeveloperState.getInstance();

[Bindable]
private var _newIteration:Iteration = new Iteration(project);

private function init():void {
}



public function toIteration(iteration:Iteration):void {
	project.selectedIteration = iteration;
}


private function showStartDate(item:Iteration, column:DataGridColumn):String {
	return TuskitLib.dateToString(item.startDate);
}

private function showEndDate(item:Iteration, column:DataGridColumn):String {
	return TuskitLib.dateToString(item.endDate);
}

private function sortByDate(iter1:Iteration, iter2:Iteration):int {
	if (iter1.startDate > iter2.startDate) return 1
	else if (iter1.startDate < iter2.startDate) return -1
	else return 0;
}

private function saveNewIteration():void {
	_newIteration.project = project;
	_newIteration.name = newIteration.iterationName.text;
	_newIteration.objectives = newIteration.objectives.text;
	_newIteration.startDate = newIteration.startDate.selectedDate;
	_newIteration.endDate = newIteration.endDate.selectedDate;
	_newIteration.workUnits = newIteration.workUnits.value;
	CairngormUtils.dispatchEvent(EventNames.CREATE_ITERATION, _newIteration);	
}