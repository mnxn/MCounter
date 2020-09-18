import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    var statusItem: NSStatusItem!
    var menu : NSMenu!
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the status item
        self.statusItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        // Create the menu for the status item
        let menu = NSMenu()
        menu.delegate = self
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        self.menu = menu

        // Create the SwiftUI view
        let contentView = ContentView(statusItem)

        // Setup button
        if let button = self.statusItem.button {
            button.title = contentView.counter.textValue
            button.action = #selector(statusAction(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 150, height: 50)
        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
    }

    @objc func statusAction(_ sender: AnyObject?) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            self.statusItem.menu = self.menu
            self.statusItem.button?.performClick(sender)
        } else {
            togglePopover(sender)
        }
    }

    @objc func menuDidClose(_ menu: NSMenu) {
        self.statusItem.menu = nil
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(
                    relativeTo: button.bounds,
                    of: button,
                    preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
}
