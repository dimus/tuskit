import org.tuskit.model.TuskitModelLocator
import lib.TuskitLib;

import org.tuskit.model.Iteration;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.ItemClickEvent;
import org.tuskit.model.Project;
import mx.controls.Alert;
import org.tuskit.components.developer_box.DeveloperState;

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

[Bindable]
private var _devModel:DeveloperState = DeveloperState.getInstance();

//DataGrid functions

private function parentProject(item:Iteration, column:DataGridColumn):String {
	return item.project.name;
}

private function daysLeft(item:Iteration, column:DataGridColumn):int {
	return item.daysLeft();
}

private function percentComplete(item:Iteration, column:DataGridColumn):String {
	return item.percentComplete().toFixed(1) + "%";
}

private function dailyLoad(item:Iteration, column:DataGridColumn):String {
	return item.dailyLoad.toFixed(1) + " w.u.";	
}

private function sortNumericString(str1:String, str2:String):int {
	return TuskitLib.sortNumericString(str1,str2);
}

private function sortByProjectName(iter1:Iteration, iter2:Iteration):int {
	if (iter1.project.name > iter2.project.name) return 1
	else if (iter1.project.name < iter2.project.name) return -1
	else return 0;
}

private function sortByDaysLeft(iter1:Iteration, iter2:Iteration):int {
	if (iter1.daysLeft() > iter2.daysLeft()) return 1
	else if (iter1.daysLeft() < iter2.daysLeft()) return -1
	else return 0;
}


private function sortByPercentComplete(iter1:Iteration, iter2:Iteration):int {
	if (iter1.percentComplete() > iter2.percentComplete()) return 1
	else if (iter1.percentComplete() < iter2.percentComplete()) return -1
	else return 0;
}

private function sortByDailyLoad(iter1:Iteration, iter2:Iteration):int {
	if (iter1.dailyLoad > iter2.dailyLoad) return 1
	else if (iter1.dailyLoad < iter2.dailyLoad) return -1
	else return 0;
}

public function toIterations(iteration:Iteration):void {
	iteration.project.selectedIteration = iteration;
	_devModel.currentProject = iteration.project;
	_devModel.currentProjectLocation = _devModel.PROJECT_ITERATIONS;
	_model.setProjectIterations(iteration.project)
	
	//change in triggerNewProjectTab let Developer Box know that it is 
	//time to create a new project
	_devModel.triggerNewProjectTab = 1 - _devModel.triggerNewProjectTab;
}

