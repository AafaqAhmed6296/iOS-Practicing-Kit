A unified, declarative API for processing events over time. Events we are talking about is here is mostly asynchoronous ones. They kinda fires continously when our app is running. What combine does, it takes all asynchoronous events that is happening in our application and combines them in to one single stream of logic.

Combine is built around three main abstractions: 
- Publishers
- Operators and
- Subscribers

## Publishers

Publishers is anything that can fire events in combine. Say for example that we want to be notified everything a new blog post is ready to be published. We could use a create a `NotificationCenter` based publisher and then fire it when the publish button is pressed.

```swift
extension Notification.Name {
    static let newBlogPost = Notification.Name("newPost")
}

struct BlogPost {
    let title: String
}

// Create a publisher
let publisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)
 .map { (notification) -> String? in
     return (notification.object as? BlogPost)?.title ?? ""
}

```

## Operators

Operators take the output of publishers, and transform them into other dataType downstream subscribers can understand. Like transforming the output to string in above example with `map` operator.

In this case for example, our `NotificationCenter` emits `Notification` as it's ouput. We need to convert that into string based off title of the blog post. 

![[operators.png ]]

Operators do that through operations like `map`, which can conveniently tack on to the publishers with a closure.

```swift
.map { (notification) -> String? in
     return (notification.object as? BlogPost)?.title ?? ""
}
```

## Subscribers

	Once we have our publishers and operators mapped, we are ready to subscribe. Subscription is two step process. 
1. First we need to create the subscriber
2. Then we need to subscribe that subscriber to the publisher

```swift 
let subscriber = Subscriber.Assign(object: subscribedLabel, keyPath: \.text)
publisher.subscribe(subscriber)
```

## Fire the event 

We can fire the notification when the user taps the publish button. We grab the text field, create a BlogPost using the text, and then fire it through the `NotficationCenter` which will in turn update label.

```swift
@objc func publishButtonTapped(_ sender: UIButton) {
    // Post the notification
    let title = blogTextField.text ?? "Coming soon"
    let blogPost = BlogPost(title: title)
    NotificationCenter.default.post(name: .newBlogPost, object: blogPost)
}
```

![[combine_demo_1.gif]]

## Source
**ViewController.swift**

```swift

```