---
title: "basic contract syntax"
date: 2023-06-10T09:06:14-06:00
draft: false
---

when contracts were [first implemented](https://github.com/noir-lang/noir/pull/944), the look and feel largely mimicked noir's [submodules](/examples/modules-submodules)

```rust
contract Foo {
    fn double(x: Field) -> pub Field { x * 2 }
    open fn triple(x: Field) -> pub Field { x * 3 }
}
```

they're just regular noir functions under the hood, but can have additional properties -- one of these being a function type

by default, a function is `"secret"`, meaning it's executed in a private context

the `open` keyword, however, makes a function execute publicly instead
