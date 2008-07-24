import mx.controls.Alert;
import org.tuskit.model.TuskitModelLocator;
import org.tuskit.components.developer_box.DeveloperState;
import mx.core.Container;
import flexlib.controls.tabBarClasses.SuperTab;
import org.tuskit.components.developer_box.ProjectView;


include "../as/assets.as"
[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

[Bindable]
private var _devModel:DeveloperState = DeveloperState.getInstance();


private function init():void {
	_model.getUsersGroupsMemberships();
	_model.getTrackersProjects();
	callLater(initNonClosableTabs);
}
			
private function initNonClosableTabs():void {
	devTabs.setClosePolicyForTab(0, SuperTab.CLOSE_NEVER);
	devTabs.setClosePolicyForTab(1, SuperTab.CLOSE_NEVER);
}

private function newProjectTab(trigger:int):Container {
	var child:ProjectView = null;

	if (_devModel.currentProject == null) return homeTab;
	
	for each (var item:* in devTabs.getChildren()) {
		if (item.id == "project_" + _devModel.currentProject.id.toString()) {
			child = item;
		}
	}
	if (child == null) {

		child = new ProjectView();
	
		child.setStyle("closeable", true);
	
		child.project = _devModel.currentProject;
	
		//TODO make label of the tab bound to the name of the project
		//Right now if project name is changed project label does not change
		child.label = child.project.name;
		
	
		child.id = "project_" + child.project.id.toString(); 
	
		child.icon = projectIcon;
	
		devTabs.addChild(child);
	}
	child.projectMenu.selectedIndex = _devModel.currentProjectLocation;
	return child;
}