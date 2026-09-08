#!/usr/bin/env bash
#
# Checks `@:state(shared(Party))` and `@:intent(Party)`: what the macros
# refuse, and what the generated code does against the registry.
#
# Same discipline as the durable runner next door: each fixture is compiled
# on its own and judged on the exit code, and a refusal must name what it
# refused. `Owned` is also *run* under the interpreter -- the registry needs
# no wire to show which writes land, which are refused, and how a call by
# name reaches a body. The wire itself is dui's to prove (dui/test/Check.hx).
#
# The fixtures bind against `cui`, the lightest real backend; what is checked
# is `rui.macros.DurableState` and `mui.macros.Intents`, which every backend
# shares.
#
#   ./test/shared/run.sh

set -u
cd "$(dirname "$0")/fixtures"

failures=0

# `-D mui_carry` is the opt-in a shared cell requires, like a Companion
# surface; `SharedOff` is the one fixture built without it.
EXTRA="-D mui_carry"
compile() {
	haxe -cp . -cp ../../../src \
		-lib cui -lib kui -lib rui -lib nui $EXTRA \
		-D mui_backend=cui \
		--macro "mui.macros.Bind.all()" \
		--macro "cui.kui.Platform.registerWithKui()" \
		-main "$1" "${@:2}" 2>&1
}

check() {
	local fixture="$1" expect="$2" text="${3:-}"
	local out code

	out=$(compile "$fixture" --no-output)
	code=$?

	if [ "$expect" = "pass" ]; then
		if [ $code -eq 0 ]; then
			echo "  ok   $fixture compile"
		else
			failures=$((failures + 1))
			echo "  FAIL $fixture should have compiled"
			echo "$out" | sed 's/^/         /'
		fi
		return
	fi

	if [ $code -eq 0 ]; then
		failures=$((failures + 1))
		echo "  FAIL $fixture should have been refused"
	elif ! echo "$out" | grep -qF -- "$text"; then
		failures=$((failures + 1))
		echo "  FAIL $fixture refused, but not for the stated reason ($text)"
		echo "$out" | sed 's/^/         /'
	else
		echo "  ok   $fixture refused ($text)"
	fi
}

echo "Shared cells and intents"

check Owned pass
out=$(compile Owned --interp)
if echo "$out" | grep -q "ALL OK"; then
	echo "  ok   Owned runs: owned writes land, foreign ones do not, calls reach bodies"
else
	failures=$((failures + 1))
	echo "  FAIL Owned did not run clean"
	echo "$out" | sed 's/^/         /'
fi

check SharedBadType reject "Int, Float, Bool or String"
check SharedTwoParties reject "ONE party"
check IntentReturns reject "must return Void"
check IntentStatic reject "cannot be static"

EXTRA=""
check SharedOff reject "-D mui_carry"

echo
if [ $failures -eq 0 ]; then
	echo "all good"
else
	echo "$failures failed"
	exit 1
fi
