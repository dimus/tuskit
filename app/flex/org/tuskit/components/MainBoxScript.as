import org.tuskit.model.TuskitModelLocator;
import mx.core.Container;

[Bindable]
private var _model:TuskitModelLocator = TuskitModelLocator.getInstance();

private function init():void {
	var views_order:Array = [
		TuskitModelLocator.DEVELOPER, 
		TuskitModelLocator.CUSTOMER, 
		TuskitModelLocator.ADMIN];	
	for (var i:String in views_order){
		for (var j:String in _model.currentUserGroups) {
			if (_model.currentUserGroups[j].id == views_order[i]) {
				_model.currentGroupId = _model.currentUserGroups[j].id;
				applicationBar.userGroupsCB.selectedIndex = int(j);
				return
			}
		}	
	}
}


private function getGroup(group:int):Container{
	var userView:Container;
	/*var views:Object = {};
	views[TuskitModelLocator.ADMIN] = adminBox;
	views[TuskitModelLocator.CUSTOMER] = customerBox;
	views[TuskitModelLocator.DEVELOPER] = developerBox;
	return 	views[group];*/
	if (group == TuskitModelLocator.ADMIN) userView = adminBox
	else if (group == TuskitModelLocator.DEVELOPER) userView = developerBox
	else userView = customerBox;
	return userView;
}    		
