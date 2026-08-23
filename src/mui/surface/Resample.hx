package mui.surface;

/**
	How a backend takes a new sample of a **snapshot** surface.

	A register, not an API. Applications never call anything here: a snapshot
	surface follows its own state, the same way a live one does — the
	declaration is evaluated inside an effect, and a write to any cell it read
	re-samples it. `sui.mui.GlancePublish.follow`, `aui.mui.GlanceBridge.follow`
	and `cafos.nui.NuiProjector` are the three that do it.

	## What used to be here, and why it is gone

	`Resample.request(Glance)` was a macro an application called after changing
	state, because a snapshot surface has no host reactivity — there is no
	SwiftUI and no Compose on our side of a widget's boundary to hand a value
	to — and something had to say *now*. Lacking a reactive host, that something
	could only be the developer.

	It was a guarantee that depended on remembering, which is not a guarantee.
	The `Counter` example proved it: its `+` button called `request` and its `-`
	button did not, so subtracting left the widget showing a number nobody had,
	and nothing anywhere said so.

	The framework knows perfectly well when the content changed — it is what the
	thunk read. `rui.macros.ViewRule` already refuses a declaration that reads
	anything other than an immutable or an observable, so there is nothing a
	manual call could serve that a cell does not.

	## The register itself

	Each backend signs it at construction, the same shape as
	`mui.surface.Describe.impl`: shared code calls the hook, never a backend.
	A backend that hosts the role but installs nothing says so with a word —
	that hole belongs to the backend, not to the application.
**/
class Resample {
	/**
		How this backend takes a new sample. Installed by the backend's
		`mui.App`, the same shape as `mui.surface.Describe.impl`: shared code
		calls the hook, never a backend.
	**/
	public static var impl:Null<(SurfaceRole, Null<String>) -> Void> = null;

	/**
		Take a new sample now.

		Called by whatever is following the surface — never by an application.
		A backend hosting the role with no resampler installed is answered with
		a word rather than silence: that hole is the backend's.
	**/
	public static function now(role:SurfaceRole, ?id:String):Void {
		if (impl == null) {
			trace("mui.surface.Resample: this backend hosts " + role
				+ " but installed no resampler; the surface will not refresh");
			return;
		}
		impl(role, id);
	}
}
