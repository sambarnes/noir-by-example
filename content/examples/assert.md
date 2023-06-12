---
title: "assert"
date: 2023-06-10T15:57:25-06:00
draft: false
---

to ensure some property holds true, use `assert(...)`

```rust
fn main(x : Field, y : pub Field) {
    assert(x != y);
}

#[test]
fn test_main() {
    main(1, 2);
}
```

try changing it so the test fails
