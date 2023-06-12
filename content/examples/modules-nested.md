---
title: "nested modules"
date: 2023-06-10T17:49:18-06:00
draft: false
---

nesting modules allow for more complex package structures

in this example project,

```bash
├── Nargo.toml
└── src
   ├── foo
   │  └── bar.nr
   ├── foo.nr
   └── main.nr
```

we declare the `foo` module in our main entrypoint

```rust
mod foo; // <-- declare the foo module

fn main(x: Field) {
    assert(foo::hello(x) != foo::bar::goodbye(x));
}

#[test]
fn test_main() {
    main(1);
}
```

its implementation lives in `foo.nr` at the same folder depth,

```rust
mod bar; // <-- declare the nested bar module

fn hello(x : Field) -> Field {
    x
}
```

while the `bar` module's implementation goes under a `foo` folder, inside `bar.nr`

```rust
fn goodbye(x : Field) -> Field {
    x - 1
}
```