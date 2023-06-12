---
title: "functions"
date: 2023-06-10T16:32:52-06:00
draft: false
---

a simple way to organize your logic

to return a value, remove the semicolon at the end of the line

```rust
// they take inputs and -> return outputs
fn add_one(x: Field) -> Field {
    x + 1
}

// function calls can be nested
fn add_two(x: Field) -> Field {
    add_one(x + 1)
}

// entrypoint fn outputs must be public (to be verifiable)
fn main(x : Field) -> pub Field {
    add_two(x)
}

// it can be a good idea to test functions individually
#[test]
fn test_add_one() {
    let got = add_one(0);
    assert(got == 1);
}

#[test]
fn test_add_two() {
    let got = add_two(17);
    assert(got == 19);
}

// as well as testing the larger unit
#[test]
fn test_main() {
    let got = main(0);
    assert(got == 2);
}
```
