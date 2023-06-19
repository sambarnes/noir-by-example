---
title: "variables"
date: 2023-06-10T16:13:55-06:00
draft: false
---

store data in variables with the `let` keyword

if you need to change that data, it must be marked "mutable" with `mut`

```rust {.codebox}
fn main() {
    let immutable_var = 17;
    // immutable_var = 38;  <-- fails to compile

    // but this is legal:
    let mut mutable_var = immutable_var;
    mutable_var = 38;

    assert(mutable_var != immutable_var);
}

#[test]
fn test_main() {
    main();
}
```
