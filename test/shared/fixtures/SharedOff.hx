import mui.App;
import mui.View;
import mui.ui.Text;

/** A shared cell in a build that did not opt into carrying: refused, naming the define. **/
class SharedOff extends App {
	@:state(shared(Phone)) var goal:Int = 0;
	override function body():View return new Text('$goal');
	static function main() {}
}
