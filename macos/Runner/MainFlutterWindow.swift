import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    
    // Enable full screen support
    self.collectionBehavior = [.fullScreenPrimary]

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
