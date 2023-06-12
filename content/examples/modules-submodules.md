---
title: "submodules"
date: 2023-06-10T18:37:40-06:00
draft: false
---

not to be confused with [nested modules](/examples/modules-nested), a submodule has in-line implementation

```rust
use mysubmodule::foo;

fn main() {
    // call it directly if imported with `use`
    foo();

    // otherwise, include the full path
    mysubmodule::bar();
}

mod mysubmodule {
    use dep::std; // <-- imports can be scoped to a submodule

    fn foo() { std::println("foo") }
    fn bar() { std::println("bar") }
}

#[test]
fn test_main() {
    main();
}
```
