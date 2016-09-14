# MTCoordinatorView

![Code](https://img.shields.io/badge/code-Swift2.3-blue.svg)
[![Version](https://img.shields.io/cocoapods/v/MTCoordinatorView.svg?style=flat)](http://cocoapods.org/pods/MTCoordinatorView)
[![License](https://img.shields.io/cocoapods/l/MTCoordinatorView.svg?style=flat)](http://cocoapods.org/pods/MTCoordinatorView)
[![Platform](https://img.shields.io/cocoapods/p/MTCoordinatorView.svg?style=flat)](http://cocoapods.org/pods/MTCoordinatorView)

![img_gif](https://github.com/mittsuu/MTCoordinatorView/blob/master/mtcoordinate.gif)


## Introduction

The view coordinate arranged to the scrolling is adjusted.

## Usage

```Swift
// ViewController

import MTCoordinatorView

class ViewController: UIViewController {

    private var coordinateManager: MTCoordinateManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ・・・ 'TableView' and 'Custom Header' are made beforehand. ・・・

        // set header view
        coordinateManager = MTCoordinateManager.init(vc: self, scrollView: tableView, header: headerView)

        // create view
        let childView = UIView.init(frame: CGRectMake(100, 100, 0, 0))
        let coordinateContainer = MTCoordinateContainer.init(view: childView, endForm: CGRectMake(100, 100, 50, 50), mode: .FIXITY, completion: {
            // tap event callback.
        })

        // set views...
        coordinateManager?.setContainer(tableView, views: coordinateContainer)

        self.view.addSubview(tableView)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let manager = coordinateManager else {
            return
        }
        manager.scrolledDetection(scrollView)
    }

```


## Installation

```ruby
pod 'MTCoordinatorView'
```


## Requirements

* iOS   8.0+
* Xcode 8.0+
* Swift 2.3


## See Also

* MTCoordinatorView for Objective-C  
https://github.com/mittsuu/MTCoordinatorView-objc


## License

MTCoordinatorView-objc is available under the MIT license. See the [LICENSE](https://github.com/mittsuu/MTCoordinatorView/blob/master/LICENSE) file for more info.
