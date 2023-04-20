In Combine, we call methods that perform an operation on values coming from a publisher “operators”. Each Combine operator returns a publisher. Publisher receives upstream events, manipulates them, and then sends the manipulated events downstream to consumers.

## Transforming Operators
- collect()
- map(\_:)
- tryMap(\_:)
- 

### Collect()
The collect operator provides a convenient way to transform a stream of individual values from a publisher into a single array.

![[collect_marble_diagram.png]]

This marble diagram depicts how collect buffers a stream of individual values until the upstream publisher completes. It then emits that array downstream.

```swift
 ["A", "B", "C", "D", "E"].publisher
        .collect()
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
```

```swift
——— Output of: .collect() ———
["A", "B", "C", "D", "E"]
```

>**Note:** Be careful when working with collect() and other buffering operators that do not require specifying a count or limit. They will use an unbounded amount of memory to store received values as they won’t emit before the upstream finishes.

We can also chop the upstream in to batches.
```swift
.collect(2)
```

```swift
——— Output of: .collect(2) ———
["A", "B"]
["C", "D"]
["E"] // Note this is also and array.
```

### Map()
It works just like Swift’s standard map, except that it operates on values emitted from a publisher.

![[map_marble_diagram.png]]
> Notice how, unlike collect, this operator re-publishes values as soon as they are published by the upstream.

```swift
 let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    [123, 4, 45].publisher
        .map({ formatter.string(from: NSNumber(integerLiteral: $0)) ?? "" })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
```

```swift
——— Output of: .map() ———
one hundred twenty-three
four
forty-five
```

#### Mapping Key paths 
The map family of operators also includes three versions that can map into one, two, or three properties of a value using key paths. Their signatures are as follows:


- map\<T0\>
- map\<T0, T1\>(\_:\_:)  
- map\<T0, T1, T2\>(\_:\_:\_:)
The T represents the type of values found at the given key paths.

Example: **mapping key path**.
```swift
let publisher = PassthroughSubject<Coordinate, Never>()
    publisher
        .map(\.x, \.y)
        .sink(receiveValue: { x, y in
            print(
                "The coordinate at (\(x), \(y)) is in quadrant",
                quadrantOf(x: x, y: y)
            )
        })
        .store(in: &subscriptions)
    publisher.send(Coordinate(x: 10, y: -8))
    publisher.send(Coordinate(x: 0, y: 5))
```
You can find the definitions for Coordinate and quadrantOf(x:y:) [here](Definitions#Coordinate & quadrant).

### TryMap()
Several operators, including map, have a counterpart with a try prefix that takes a throwing closure. If you throw an error, the operator will emit that error downstream.

Example: tryMap(\_:)
```swift
let publisher = Just("Directory name")
    
    publisher
        .tryMap { directory in
            try FileManager.default.contentsOfDirectory(atPath: directory)
        }
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {
            print($0)
        })
        .store(in: &subscriptions)
```
Output:
```swift
——— Output of: tryMap ———
failure(Error Domain=NSCocoaErrorDomain Code=260 "The folder “Directory name” doesn’t exist." UserInfo={NSUserStringVariant=(
    Folder
), NSFilePath=Directory name, NSUnderlyingError=0x600003d416b0 {Error Domain=NSPOSIXErrorDomain Code=2 "No such file or directory"}})
```


### Flattening publishers

### FlatMap(maxPublishers:\_:)
The flatMap operator flattens multiple upstream publishers into a single downstream publisher — or more specifically, flatten the emissions from those publishers.
**Use case**: when you want to pass elements emitted by one publisher to a method that itself returns a publisher, and ultimately subscribe to the elements emitted by that second publisher.

Example: flatMap(maxPublishers:\_:)
```swift
func decode(_ codes: [Int]) -> AnyPublisher<String, Never> {
        
        Just(
            codes
                .compactMap({ code in
                    guard (32...255).contains(code) else { return nil }
                    return String(UnicodeScalar(code) ?? " ")
                })
                .joined()
        )
        .eraseToAnyPublisher()
    }
    
    [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
        .publisher
        .collect()
        .flatMap(decode)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
```

![[flatMap_marble_diagram.png]]
In the diagram, flatMap receives three publishers: P1, P2, and P3. Each of these publishers has a value property that is also a publisher. flatMap emits the value publishers’ values from P1 and P2, but ignores P3 because maxPublishers is set to 2.

### ReplaceNil(with:)
As depicted in the following marble diagram, replaceNil will receive optional values and replace nils with the value you specify:
![[replaceNil_marble_diagram.png]]

Example: replaceNil(with:)
```swift
["A", nil, "C"]
        .publisher
        .eraseToAnyPublisher()
        .replaceNil(with: "-")
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
```
>***Note:*** replaceNil(with:) has overloads which can confuse Swift into picking the wrong one for your use case. This results in the type remaining as Optional\<String\> instead of being fully unwrapped. The code above uses eraseToAnyPublisher() to work around that bug. You can learn more about this issue in the Swift forums: https://bit.ly/30M5Qv7

Output: replaceNil(with:)
```swift
——— Output of: replaceNil ———
A
-
C
```

### ReplaceEmpty(with:)
You can use the replaceEmpty(with:) operator to replace — or really, insert — a value if a publisher completes without emitting a value.

In the following marble diagram, the publisher completes without emitting anything, and at that point the replaceEmpty(with:) operator inserts a value and publishes it downstream:
![[replaceEmpty_marble_diagram.png]]

Example: replaceEmpty(with:)
```swift
 let empty = Empty<Int, Never>()
    
    empty
        .replaceEmpty(with: 1)
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {
            print($0)
        })
        .store(in: &subscriptions)
```

Output: 
```swift
——— Output of: replaceEmpty(with:) ———
1
```

### Scan(\_:\_:)
It will provide the current value emitted by an upstream publisher to a closure, along with the last value returned by that closure.
In the following marble diagram, scan begins by storing a starting value of 0. As it receives each value from the publisher, it adds it to the previously stored value, and then stores and emits the result:

![[scan_marble_diagram.png]]

Example: scan(\_:\_:)
```swift
var dailyGainLoss = Int.random(in: -10...10)
    
    let apr = (0..<22)
        .map { _ in
            dailyGainLoss
        }
        .publisher
    
    apr
        .scan(50) { latest, current in
            max(0, latest + current)
        }
        .sink { _ in
            
        }
        .store(in: &subscriptions)
```

Output: scan(\_:\_:)
![[scan_op_output.png]] 
This output is visualize by Xcode's playground

> There’s also an error-throwing tryScan operator that works similarly. If the closure throws an error, tryScan fails with that error.
