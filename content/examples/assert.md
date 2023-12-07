---
title: "assert"
date: 2023-06-10T15:57:25-06:00
draft: false
---

to ensure some property holds true, use `assert(...)`

```rust {.codebox}
fn main(x : Field, y : pub Field) {
    assert(x != y);
}

#[test]
fn test_main() {
    main(1, 2);
}
```

to test a given input fails, use the `#[test(should_fail)]` decorator

```rust {.codebox}
#[test(should_fail)]
fn test_main_fails() {
    main(1, 1);
}
```

often there's multiple assertions that could've failed.  adding a message helps to target a specific statement in your tests

```rust {.codebox}
fn main(x : Field, y : pub Field) {
    assert(x != y);

    // optionally include an error message
    assert(x + y == 3, "Must sum to three");
}

#[test(should_fail_with = "Must sum to three")]
fn test_main_fails_with_message() {
    main(3, 4);
}
```