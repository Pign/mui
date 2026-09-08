import mui.App;
import mui.View;
import mui.ui.Text;

/** A static intent: refused, an intent runs against the application's state. **/
class IntentStatic extends App {
	@:state(shared(Watch)) var steps:Int = 0;
	@:intent(Watch) static function reset():Void {}
	override function body():View return new Text('$steps');
	static function main() {}
}
