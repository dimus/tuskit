import org.tuskit.model.Iteration;
import lib.TuskitLib;

[Bindable]
public var iteration:Iteration = new Iteration();

[Bindable]
private var _defaultStartDate:Date = new Date();

[Bindable]
private var _defaultEndDate:Date = new Date(_defaultStartDate.valueOf() + getIterationLength());
	

private function getIterationLength():int {
	var iterationLength:int = iteration.project.iterationLength; 
	return (iterationLength * TuskitLib.MSEC_PER_DAY);
}
