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
}

#[test]
fn test_main() {
    main();
}
```

now, run the tests with `nargo test`

```bash
Running 1 test functions...
Testing test_main...
ok
All tests passed
```

add a `--show-output` flag to display the logs

```bash
Running 1 test functions...
Testing test_main...
👋 hello world
ok
All tests passed
```
