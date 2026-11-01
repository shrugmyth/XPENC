import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // XPENC's layout is phone-shaped: open at a tall, narrow size and don't
    // let the window shrink below what the screens were designed for.
    // The window remembers its last size/position after the first launch.
    self.setContentSize(NSSize(width: 480, height: 900))
    self.contentMinSize = NSSize(width: 400, height: 700)
    self.center()
    self.setFrameAutosaveName("XPENCMainWindow")
    self.title = "XPENC"

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
