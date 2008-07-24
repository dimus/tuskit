import mx.events.DropdownEvent;
import org.tuskit.model.TuskitModelLocator;
import mx.controls.ComboBox;

private const OPEN_REMOTE_TASKS:String = "External Tasks";

private const CLOSE_REMOTE_TASKS:String = "Close"; 

[Bindable]
private var _model: TuskitModelLocator = TuskitModelLocator.getInstance();


private function init():void {
}

private function handleSelectView(event:DropdownEvent):void {
 	var idx:int =  event.currentTarget.selectedIndex;
 	_model.currentGroupId = _model.currentUserGroups[idx].id;
}

private function setExternalTasksIcon(currentIcon:int):String {
	var icons:Object = {};
	icons[_model.EXT_TASKS_ICON_EMPTY] = '/org/tuskit/assets/b_empty.png';
	icons[_model.EXT_TASKS_ICON_FULL] = '/org/tuskit/assets/b_full.png';
	icons[_model.EXT_TASKS_ICON_NEW] = '/org/tuskit/assets/b_new.png';
	return icons[currentIcon];
}

private function logout():void {
	var urlRequest:URLRequest = new URLRequest("/bin/tuskit.html");
    navigateToURL(urlRequest, "_top");
}