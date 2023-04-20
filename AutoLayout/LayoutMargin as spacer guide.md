It can also be use as spacer between views. Alternatively we can use `UIStackView` to achieve the same behaviour, but before `UIStackView` UILayoutGuide was used as invisible spacer between views. It is as similar putting a view between spaces, but it is more optimized as it don't get rendered in the view heirarchy and does not contain any space in the memory.

### Example behaviour
![[UILayoutGuideAsSpacer.png | 250]]

### Example Code
```swift
	func setupViews() {
        navigationItem.title = "Spacer Views"

        // create controls
        let leadingGuide = UILayoutGuide()
        let okButton = makeButton(withText: "OK", color: UIColor.darkBlue)
        let middleGuide = UILayoutGuide()
        let cancelButton = makeButton(withText: "Cancel", color: UIColor.darkGreen)
        let trailingGuide = UILayoutGuide()

        // add to subView and layoutGuide
        view.addSubview(okButton)
        view.addSubview(cancelButton)
        view.addLayoutGuide(leadingGuide)
        view.addLayoutGuide(middleGuide)
        view.addLayoutGuide(trailingGuide)

        // setup constraints
        let margins = view.layoutMarginsGuide

        // leading guide
        leadingGuide.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        leadingGuide.trailingAnchor.constraint(equalTo: okButton.leadingAnchor).isActive = true

        // middle guide
        okButton.trailingAnchor.constraint(equalTo: middleGuide.leadingAnchor).isActive = true
        middleGuide.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor).isActive = true

        // trailing guide
        cancelButton.trailingAnchor.constraint(equalTo: trailingGuide.leadingAnchor).isActive = true
        trailingGuide.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        // equal widths
        okButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        leadingGuide.widthAnchor.constraint(equalTo: middleGuide.widthAnchor).isActive = true
        leadingGuide.widthAnchor.constraint(equalTo: trailingGuide.widthAnchor).isActive = true

        // vertical position
        leadingGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        middleGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        trailingGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
```