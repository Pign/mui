import mui.App;
import mui.View;
import mui.ui.Text;
import mui.ui.VStack;
import mui.ui.HStack;
import mui.ui.Button;
import mui.ui.Spacer;
import mui.ui.ProgressView;

// A dashboard with tabs, progress indicators, and stats.
//
// Tabs and tables are heavily backend-specific, so this example
// uses #if blocks for the tab container while sharing the
// content views.

class DashboardApp extends App {
    @:state var activeTab:Int = 0;

    public function new() {
        super();
        #if (mui_backend == "sui")
        appName = "Dashboard";
        bundleIdentifier = "com.mui.dashboard";
        #end
    }

    #if (mui_backend == "wui")
    override function appName():String return "Dashboard";
    #end

    override function body():View {
        #if (mui_backend == "sui")
        return new sui.ui.TabView([
            { label: "Overview", systemImage: "chart.bar", content: overviewTab() },
            { label: "Services", systemImage: "server.rack", content: servicesTab() },
        ]);

        #elseif (mui_backend == "wui")
        return new wui.ui.TabView([
            { label: "Overview", content: overviewTab() },
            { label: "Services", content: servicesTab() },
        ]);

        #elseif (mui_backend == "cui")
        return new VStack([
            new HStack([
                new Text(" Dashboard ")
                    .bold()
                    .foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Cyan)),
                new Spacer(),
                new Text("←→: tabs | Ctrl+C: quit ").dim(),
            ], 0),
            cast(new cui.ui.Tabs([
                { label: "Overview", content: overviewTab() },
                { label: "Services", content: servicesTab() },
            ], cui.ui.Tabs.TabSelection.fromState(activeTab)), View)
                .border(cui.render.BorderStyle.Single),
        ], 0).padding(1).border(cui.render.BorderStyle.Rounded);
        #end
    }

    function overviewTab():View {
        #if (mui_backend == "sui")
        return new VStack(null, 20, [
            new Text("System Status")
                .font(sui.View.FontStyle.Title)
                .padding(),
            new VStack(null, 12, [
                statusRow("CPU", 0.73),
                statusRow("Memory", 0.45),
                statusRow("Disk", 0.89),
            ]).padding(),
            new VStack(null, 8, [
                infoRow("Uptime", "14d 3h 22m"),
                infoRow("Requests/s", "1,247"),
                infoRow("Latency p99", "142ms"),
                infoRow("Error rate", "0.03%"),
            ]).padding(),
        ]);

        #elseif (mui_backend == "wui")
        return new VStack([
            new Text("System Status")
                .font(wui.modifiers.ViewModifier.FontStyle.Title)
                .padding(),
            new VStack([
                statusRow("CPU", 0.73),
                statusRow("Memory", 0.45),
                statusRow("Disk", 0.89),
            ]).padding(),
            new VStack([
                infoRow("Uptime", "14d 3h 22m"),
                infoRow("Requests/s", "1,247"),
                infoRow("Latency p99", "142ms"),
                infoRow("Error rate", "0.03%"),
            ]).padding(),
        ]);

        #elseif (mui_backend == "cui")
        return new VStack([
            new Text("System Status").bold(),
            new Spacer(),
            new HStack([
                new VStack([
                    new Text("CPU").foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Yellow)),
                    new cui.ui.ProgressBar(0.73, ""),
                ], 0).border(cui.render.BorderStyle.Single).padding(0, 1, 0, 1),
                new VStack([
                    new Text("Memory").foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Yellow)),
                    new cui.ui.ProgressBar(0.45, ""),
                ], 0).border(cui.render.BorderStyle.Single).padding(0, 1, 0, 1),
                new VStack([
                    new Text("Disk").foregroundColor(cui.render.Color.Named(cui.render.Color.NamedColor.Yellow)),
                    new cui.ui.ProgressBar(0.89, ""),
                ], 0).border(cui.render.BorderStyle.Single).padding(0, 1, 0, 1),
            ], 1),
            new Spacer(),
            new cui.ui.Table(
                ["Metric", "Value", "Status"],
                [
                    ["Uptime", "14d 3h 22m", "OK"],
                    ["Requests/s", "1,247", "OK"],
                    ["Latency p99", "142ms", "WARN"],
                    ["Error rate", "0.03%", "OK"],
                ]
            ),
        ], 1);
        #end
    }

    function servicesTab():View {
        #if (mui_backend == "sui")
        return new sui.ui.List([
            serviceRow("api-gateway", "Running", "3/3"),
            serviceRow("auth-service", "Running", "2/2"),
            serviceRow("data-pipeline", "Degraded", "1/3"),
            serviceRow("cache-layer", "Running", "4/4"),
            serviceRow("worker-pool", "Running", "5/5"),
            serviceRow("notification", "Stopped", "0/2"),
        ]);

        #elseif (mui_backend == "wui")
        return new VStack([
            serviceRow("api-gateway", "Running", "3/3"),
            serviceRow("auth-service", "Running", "2/2"),
            serviceRow("data-pipeline", "Degraded", "1/3"),
            serviceRow("cache-layer", "Running", "4/4"),
            serviceRow("worker-pool", "Running", "5/5"),
            serviceRow("notification", "Stopped", "0/2"),
        ]).padding();

        #elseif (mui_backend == "cui")
        return new cui.ui.Table(
            ["Service", "Status", "Instances"],
            [
                ["api-gateway", "Running", "3/3"],
                ["auth-service", "Running", "2/2"],
                ["data-pipeline", "Degraded", "1/3"],
                ["cache-layer", "Running", "4/4"],
                ["worker-pool", "Running", "5/5"],
                ["notification", "Stopped", "0/2"],
            ]
        );
        #end
    }

    function statusRow(label:String, value:Float):View {
        #if (mui_backend == "sui")
        return new HStack([
            new Text(label).frame(80, null, null),
            new ProgressView(null, null, 1.0),
            new Text('${Std.int(value * 100)}%'),
        ]);
        #elseif (mui_backend == "wui")
        return new HStack([
            new Text(label).width(80),
            new ProgressView(null, value),
            new Text('${Std.int(value * 100)}%'),
        ]);
        #elseif (mui_backend == "cui")
        return new HStack([
            new Text(label),
            new cui.ui.ProgressBar(value, ""),
            new Text('${Std.int(value * 100)}%'),
        ], 1);
        #end
    }

    function infoRow(label:String, value:String):View {
        return new HStack([
            new Text(label),
            new Spacer(),
            new Text(value),
        ]
        #if (mui_backend == "cui")
        , 1
        #end
        );
    }

    function serviceRow(name:String, status:String, instances:String):View {
        #if (mui_backend == "sui")
        return new HStack([
            new Text(name).font(sui.View.FontStyle.Body),
            new Spacer(),
            new Text(status)
                .foregroundColor(status == "Running" ? sui.View.ColorValue.Green :
                    status == "Degraded" ? sui.View.ColorValue.Orange : sui.View.ColorValue.Red),
            new Text(instances)
                .foregroundColor(sui.View.ColorValue.Secondary),
        ]);
        #elseif (mui_backend == "wui")
        return new HStack([
            new Text(name),
            new Spacer(),
            new Text(status),
            new Text(instances),
        ]).padding();
        #elseif (mui_backend == "cui")
        // cui uses Table for services, so this shouldn't be called
        return new Text('$name: $status ($instances)');
        #end
    }

    #if (mui_backend == "cui")
    override function handleEvent(event:cui.event.Event):Bool {
        switch (event) {
            case Key(key):
                switch (key.code) {
                    case Char("q") if (key.ctrl): quit(); return true;
                    default:
                }
            default:
        }
        return false;
    }
    #end

    static function main() {
        #if (mui_backend == "cui")
        new DashboardApp().run();
        #end
    }
}
