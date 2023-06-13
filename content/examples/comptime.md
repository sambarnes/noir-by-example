---
title: "comptime variables"
date: 2023-06-10T17:15:32-06:00
draft: false
---

while witness variables are expected to change per proof, any `comptime` values are known at compile time

```rust
fn main() -> pub Field {
    let known_at_compile_time: comptime Field = 1;

    // `comptime Field` can also be inferred
    let inferred_known = 2;

    // cannot be mutable tho, so this would fail
    // let mut bad_var: comptime Field = 3;

    known_at_compile_time + inferred_known
}

#[test]
fn test_main() {
   let result =  main();
    assert(result == 3);
}
```

when comptime values are changed, the circuit itself also changes
