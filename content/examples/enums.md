---
title: "enums"
date: 2023-06-15T14:07:59-06:00
draft: false
---

currently, there's no official enum support in the language 

however, a submodule with globals can kinda compensate

```rust {.codebox}
mod OrderType {
    global FULL_OPEN: Field = 0;
    global PARTIAL_OPEN: Field = 1;
    global FULL_RESTRICTED: Field = 2;
    global PARTIAL_RESTRICTED: Field = 3;
    global CONTRACT: Field = 4;
}

fn main(order_type: Field) {
    assert(order_type != OrderType::FULL_OPEN);
}

#[test]
fn test_main() {
    main(OrderType::PARTIAL_OPEN);
}
```
