import org.tuskit.model.TuskitModelLocator;
import mx.controls.Alert;

import mx.events.DragEvent;
import mx.managers.DragManager;
import mx.core.DragSource;
import mx.core.UIComponent;
import org.tuskit.model.Project;
import org.tuskit.model.Iteration;
import mx.controls.Tree;
import org.tuskit.components.developer_box.DeveloperState;
import org.tuskit.util.CairngormUtils;
import org.tuskit.control.EventNames;
import lib.TuskitLib;       

import mx.effects.Resize;

include "../../as/assets.as";

private var resizeEffect:Resize = new Resize();

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

[Bindable]
private var _devModel:DeveloperState = DeveloperState.getInstance();

[Bindable]
private var _newProject:Project = new Project();


public function toIterations(project:Project):void {
	_devModel.currentProject = project;
	_devModel.currentProjectLocation = _devModel.PROJECT_ITERATIONS;
	
	_model.setProjectIterations(project)
	
	//change in triggerNewProjectTab let Developer Box know that it is 
	//time to create a new project tab
	_devModel.triggerNewProjectTab = 1 - _devModel.triggerNewProjectTab;
}


public function newProject():void {
	stateShowNewProject();
}

private function init():void {
}

private function stateShowNewProject():void {
	_newProject = new Project();
	addProjectButton.visible=false;
	allProjectsBar.height=0;
	resizeEffect.target = newProjectPanel;
	resizeEffect.heightFrom = 0;
	resizeEffect.heightTo = 290;
	resizeEffect.duration = 600;
	resizeEffect.end();
	resizeEffect.play();
	focusManager.setFocus(projectInfoInput.projectName);

}

private function stateHideNewProject():void {
	_newProject = new Project();
	addProjectButton.visible=true;
	allProjectsBar.height = 33;
	resizeEffect.target = newProjectPanel;
	resizeEffect.heightFrom = 290;
	resizeEffect.heightTo = 0;
	resizeEffect.duration = 600;
	resizeEffect.end();
	resizeEffect.play();
}

private function hideNewProjectPanel(trigger:int):Boolean {
	stateHideNewProject();
	return true;
}

private function saveNewProject():void {
	_newProject.name = projectInfoInput.projectName.text;
	_newProject.description = projectInfoInput.projectDescription.text;
	_newProject.startDate = projectInfoInput.projectStartDate.selectedDate;
	_newProject.endDate = projectInfoInput.projectEndDate.selectedDate;
	_newProject.progressReports = projectInfoInput.projectProgressReports.selected;
	CairngormUtils.dispatchEvent(EventNames.CREATE_PROJECT, _newProject);
}



