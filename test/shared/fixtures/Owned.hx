import mui.App;
import mui.View;
import mui.ui.Button;
import mui.ui.Text;
import mui.ui.VStack;

enum Party {
	Phone;
	Watch;
}

/**
	One class, two parties. The phone owns `goal`, the watch owns `steps`,
	`showDetails` never leaves the device, and `resetSteps` runs on the watch
	whoever calls it. `body()` branches on a `final`, which the view rule
	accepts: nothing here reads a mutable that cannot notify.

	Run under the interpreter, this proves the macro's output against the
	registry without a wire: what the generated dispatch does, what the table
	holds, and that a foreign write does not land.
**/
class Owned extends App {
	@:state(shared(Phone)) var goal:Int = 10000;
	@:state(shared(Watch)) var steps:Int = 0;
	@:state var showDetails:Bool = false;

	final me:Party;

	public function new(me:Party) {
		super();
		this.me = me;
	}

	@:intent(Watch) function resetSteps():Void
		steps = 0;

	@:intent(Phone) function raiseGoal(by:Int, why:String):Void
		goal += by;

	override function body():View {
		return switch (me) {
			case Watch: new VStack([
				new Text('$steps'),
				new Button("+100", () -> steps += 100),
			]);
			case Phone: new VStack([
				new Text('$steps / $goal'),
				new Button("reset", () -> resetSteps()),
			]);
		}
	}

	static var fails = 0;

	static function check(label:String, ok:Bool) {
		if (!ok) fails++;
		Sys.println((ok ? "ok   " : "FAIL ") + label);
	}

	static function main() {
		var reg = rui.state.Shared.current;
		var words:Array<String> = [];
		reg.onRefused = w -> words.push(w);
		var app = new Owned(Phone);
		reg.me = "Phone";

		check("the table holds both intents", app.declaredIntents().length == 2);
		check("with their owners", app.declaredIntents()[0].owner == "Watch" && app.declaredIntents()[1].owner == "Phone");

		@:privateAccess app.goal = 12000;
		check("an owned write lands", @:privateAccess app.goal == 12000);
		check("and is stamped", reg.stampOf("goal").s == 1);

		@:privateAccess app.steps = 5;
		check("a foreign write does not land", @:privateAccess app.steps == 0);
		check("and is refused with a word naming the owner", words.length == 1 && words[0].indexOf("Watch") >= 0);

		@:privateAccess app.showDetails = true;
		check("a private cell is an ordinary cell", @:privateAccess app.showDetails == true && reg.owned().length == 1);

		@:privateAccess app.raiseGoal(500, "because");
		check("an intent for this party runs here", @:privateAccess app.goal == 12500);

		@:privateAccess app.resetSteps();
		check("an intent for another party is refused with a word when nobody carries it",
			words.length == 2 && words[1].indexOf("resetSteps") >= 0);

		// A call arriving by name runs the body through the table.
		for (d in app.declaredIntents()) reg.declareIntent(d);
		reg.receiveCall("raiseGoal", [1, "remote"]);
		check("a call arriving by name runs the body", @:privateAccess app.goal == 12501);

		Sys.println(fails == 0 ? "ALL OK" : '$fails failed');
		Sys.exit(fails == 0 ? 0 : 1);
	}
}
