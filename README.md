# hndlSegue

hndlSegue it is a cocoapod which allows to use blocks in performSegueWithIdentifier. Then you import hndlSegue to you project this pod exten functionality of UIViewController.

You can also:
- use performSegueWithIdentifier without handler and use prepareForSegue by default
- send handler to performSegueWithIdentifier. This handler will invoke after default method prepareForSegue.

### Version
0.2

### Installation
```swift
pod 'hndlSegue', '~> 0.1'
```
### Addition in project
```swift
import hndlSegue
```
> You need import hndlSegue pod in all source file where this functionality used

### Using
```swift
self.performSegueWithIdentifier(segueID, sender: someSender) { segue, sender in
// some code
}
```

### Example
```swift
self.performSegueWithIdentifier("ShowStations", sender: nil) { segue, sender in
let controller = segue.destinationViewController as! StationsListViewController
controller.directionType = "citiesTo"
}
```

### More info

When you call performSegueWithIdentifier add use handler, this pos save your handler in dictionary. After that method prepareForSegue swizzled on swizledPrepareForSegue method. In swizledPrepareForSegue I call origin prepareForSegue and find your handler in dictionary by segueID. If handler not nil, this handler will invoked.