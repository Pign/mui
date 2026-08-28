import mui.App;
import mui.View;
import mui.ui.Text;

/**
	The same declaration, with the networked corner switched on.

	Compiled with `-D mui_cafos`: a Companion is carried off this machine, and this
	build says it wants that. Serving still takes an explicit
	`dui.mui.CompanionServe.serve` call at runtime, plus a pairing — three deliberate acts.
**/
class CompanionOptIn extends App {
	override function body():View {
		return new Text("body");
	}

	@:surface(Companion)
	function panel():View {
		return new Text("served on demand");
	}

	static function main() {
		new CompanionOptIn();
	}
}
