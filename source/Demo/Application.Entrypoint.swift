import AppKit

@NSApplicationMain internal class AppDelegate: NSObject, NSApplicationDelegate
{
    internal func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
}
