---
title: "basic contract syntax"
date: 2023-06-10T09:06:14-06:00
draft: false
---

`TODO: flesh out the concept of these pages -- follow along the with new releases of noir, documenting how the contract functionality evolves leading up to mainnet launch`

---

[feat: Implement basic contracts (#944)](https://github.com/noir-lang/noir/pull/944)

a `nargo compile --contracts` command was included to compile all functions declared in a `contrac`t as if they were a separate main function

```rust
fn main(x : Field, y : pub Field) {
    assert(x * 2 == y * 3);
}

contract Foo {
    fn double(x: Field) -> pub Field { x * 2 }
    fn triple(x: Field) -> pub Field { x * 3 }
}
```
