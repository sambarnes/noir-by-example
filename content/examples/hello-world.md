---
title: "hello world"
date: 2023-06-09T19:38:39-06:00
draft: false
---

the `use` keyword imports a dependency into scope

```rust {.codebox}
use dep::std;

fn main() {
    std::println("👋 hello world");

    let foo = 17;
    std::println(f"some field: {foo}");
}

#[test]
fn test_main() {
    main();
}
```

now, run the tests with `nargo test`

```bash
[hello_world] Running 1 test functions
[hello_world] Testing test_main...
ok
```

add a `--show-output` flag to display the logs

```bash
[hello_world] Running 1 test functions
[hello_world] Testing test_main... "👋 hello world"
some field: 0x11
ok
```
