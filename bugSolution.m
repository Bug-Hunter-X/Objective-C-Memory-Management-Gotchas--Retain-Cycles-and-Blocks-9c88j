The solution focuses on proper use of `weak` properties to avoid retain cycles and ensuring that blocks are handled correctly to prevent crashes. 

Revised `MyClass`:
```objectivec
@interface MyClass : NSObject <MyProtocol> {
  MyDelegate *delegate;
}
@property (nonatomic, weak) MyDelegate *delegate; // Use weak to prevent retain cycle

@implementation MyClass

- (void)someMethod {
    // ... some code ...
    MyDelegate *newDelegate = [[MyDelegate alloc] init]; 
    [newDelegate someMethod:self]; // Delegate object's life-cycle is managed by caller. 
}
@end
```

Handling blocks safely, consider using `__weak` to avoid strong references within the block:
```objectivec
- (void)doSomethingWithCompletion:(void (^)(BOOL success))completion {
  __weak typeof(self) weakSelf = self; // Create a weak reference to self
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
    if (weakSelf) { //Check if self is still alive before executing block
      // ... some long running task ...
      if (completion) completion(YES);
    }
  });
}
```
By using `__weak` and checking for `nil` before accessing `self` within the block, we prevent crashes that would occur due to accessing deallocated memory.