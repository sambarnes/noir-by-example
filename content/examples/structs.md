---
title: "structs"
date: 2023-06-10T17:16:32-06:00
draft: false
---

structs group together multiple related values, with a name for each field

define custom functions on them using `impl` blocks

```rust {.codebox}
struct Foo {
    bar: Field,
    baz: [Field; 2],
}

impl Foo {
    // implementations can be methods on struct instances
    fn some_fn(self: Self) -> Field {
        self.bar + self.baz[0] + self.baz[1]
    }

    // or static functions on the type itself
    fn default() -> Self {
        let bar = 0;
        Self { bar , baz: [1, 2] }
    }
}

// structs can be inputs to a main function, but not outputs
fn main(foo: Foo) {
    assert(foo.some_fn() == 3);
}

#[test]
fn test_main() {
    let foo = Foo::default();
    main(foo);
}
```
