---
title: "higher order functions"
date: 2023-06-10T19:08:00-06:00
draft: false
---

functions can be passed around like variables, just reference its name

noir also supports both lambdas and closures

```rust
fn foo(x: Field) -> Field { x }
fn bar(x: Field) -> Field { x + 1 }

fn combine_results(
    x: Field,
    f1: fn(Field) -> Field,
    f2: fn(Field) -> Field,
) -> Field {
    f1(x) + f2(x)
}

fn main() {
    // functions can be arugments to other functions
    let mut combined = combine_results(1, foo, bar);
    assert(combined == 3);

    // lambdas are anonymous functions defined inline
    combined = combine_results(1, foo, |x| x + 2);
    assert(combined == 4);

    // closures are like lambdas but capture surrounding scope
    let some_var = 42;
    let some_closure = |x| some_var - x;
    assert(some_closure(1) == 41);

    //
    // NOTE: mutable vars cannot be captured, copy them
    //       into immutable vars and capture those
    //
}

#[test]
fn test_main() {
    main();
}
```
