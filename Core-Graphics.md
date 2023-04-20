Core graphics is a library for drawing things on apple's iOS and Mac. 
We often don't work with it directly in iOS. Most of work is done in a higher level frameworks and libraries. It is the basic of every thing is build upon.

> In `CGFloat`, `CGSize`, CG stands for Core Graphics!

## How does it work? 
---
There are two ways:
1. Override `drawRect` in `UIView`
2. Load via UIImageView

### 1. Override drawRect
> The most standard way to create an image in CG is to ovveride the `drawRect` in `UIView`

```swift
class MyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        //1
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        // Define the painting area
        // A square below is defined
        let rect = CGRect(x: 0, y: 0, width: 200, height: 180).insetBy(dx: 10, dy: 10)
        ctx.setFillColor(UIColor.systemRed.cgColor)
        ctx.fill(rect)
        ctx.setStrokeColor(UIColor.systemGreen.cgColor)
        ctx.addRect(rect)
        ctx.setLineWidth(20)
        ctx.drawPath(using: .fillStroke)
        
        let rectForCircle = CGRect(x: 210, y: 0, width: 180, height: 180).insetBy(dx: 10, dy: 10)
        ctx.setFillColor(UIColor.systemGreen.cgColor)
        ctx.setStrokeColor(UIColor.cyan.cgColor)
        ctx.setLineWidth(10)
        ctx.addEllipse(in: rectForCircle)
        ctx.drawPath(using: .fillStroke)
    }
}
```

> 1. Everything in core graphics is driven by this context, think of this your pallete. Whatever you want to see drawn this pallete contains all those things.
---
**Output**
![[simulator_screenshot_026E9D9D-4371-4F9D-BA55-DC93A976EB17.png |  200 ]]


### 2. Load via UIImageView
```swift
class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .cyan
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        drawRect()
    }
    
    func drawRect() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 400))
        
        let image = renderer.image { ctx in
            let rect = CGRect(x: 0, y: 0, width: 200, height: 180).insetBy(dx: 10, dy: 10)
            
            ctx.cgContext.setFillColor(UIColor.systemRed.cgColor)
            ctx.cgContext.fill(rect)
            ctx.cgContext.setStrokeColor(UIColor.systemGreen.cgColor)
            ctx.cgContext.addRect(rect)
            ctx.cgContext.setLineWidth(20)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
}
```