---
title: "if / else"
date: 2023-06-10T16:52:31-06:00
draft: false
---

noir supports conditionals through typical `if` / `else if` / `else` chains

```rust {.codebox}
fn main(foo: u32, mut bar: [u32; 2]) -> pub bool {
    if foo == bar[0] {
        true
    } else if foo == bar[1] {
        true
    } else {
       false
    }
}

#[test]
fn test_main() {
    let mut found = main(4, [2, 4]);
    assert(found == true);

    found = main(42, [2, 4]);
    assert(found == false);
}
```
