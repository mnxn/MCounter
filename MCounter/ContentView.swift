import SwiftUI

struct ContentView: View {
    @ObservedObject var counter : Counter

    init(_ statusItem: NSStatusItem? = nil) {
        self.counter = Counter(statusItem)
    }

    var body: some View {
        HStack(spacing: 0) {
            Button(
                action: { self.counter.intValue -= 1 },
                label: { nsImage(name: NSImage.removeTemplateName) }
            ).buttonStyle(SquareButtonStyle())

            TextField("", text: $counter.textValue)
                .font(.system(size: 16, weight: .regular, design: .monospaced))
                .padding(3)
                .multilineTextAlignment(.center)
                .textFieldStyle(PlainTextFieldStyle())

            Button(
                action: { self.counter.intValue += 1 },
                label: { nsImage(name: NSImage.addTemplateName) }
            ).buttonStyle(SquareButtonStyle())
        }
    }
}

class Counter: ObservableObject {
    var statusItem : NSStatusItem?

    init(_ statusItem: NSStatusItem?) {
        self.statusItem = statusItem
    }

    @Published var textValue = UserDefaults.standard.string(forKey: "currentValue") ?? "0" {
        didSet {
            if !textValue.allSatisfy("1234567890-".contains) || textValue.count > 4 {
                textValue = oldValue
            }
            if textValue == "" {
                textValue = "0"
            }
            self.statusItem?.button?.title = textValue
            UserDefaults.standard.setValue(textValue, forKey: "currentValue")
        }
    }

    var intValue : Int {
        get { Int(self.textValue)! }
        set { self.textValue = String(newValue) }
    }
}

func nsImage(name: String) -> some View {
    let image = NSImage(imageLiteralResourceName: name)
    image.size = NSSize(width: 16, height: 16)
    return Image(nsImage: image)
        .frame(width: 50, height: 50)
}

struct SquareButtonStyle: ButtonStyle {
    var foregroundColor = Color(NSColor.controlTextColor)
    var backgroundColor = Color(NSColor.controlColor)
    var pressedColor = Color(NSColor.controlAccentColor)

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.largeTitle)
            .foregroundColor(foregroundColor)
            .background(configuration.isPressed ? pressedColor : backgroundColor)
            .padding(0)
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 150, height: 50)
    }
}
