---
title: "modules"
date: 2023-06-10T17:35:22-06:00
draft: false
---

related functions are often grouped in a module

in this example project,
```bash
├── Nargo.toml
└── src
   ├── foo.nr
   └── main.nr
```

the `foo` module holds some logic

```rust
fn hello(x : Field) -> Field {
    x
}

fn hi(x : Field) -> Field {
    x + 1
}
```

and the main entrypoint can call it
```rust
mod foo; // <-- declare the foo module

fn main(x: Field, y: pub Field) {
    assert(x != foo::hello(y));
    assert(x != foo::hi(y));
}

#[test]
fn test_main() {
    main(1, 3);
}
```
