---
title: "strings"
date: 2023-06-10T16:53:31-06:00
draft: false
---

strings are fixed length values in noir `str<N>`

```rust {.codebox} 
use dep::std;

fn main(
    message : pub str<11>,
    hex_as_string : str<4>,
    hex_as_field : Field,
) {
    assert(message == "hello world");
    
    std::println(hex_as_string);
    std::println(hex_as_field);

    // this fails to compile, type mismatch between str[4] and Field
    // assert(hex_as_string != hex_as_field);
}

#[test]
fn test_main() {
    main("hello world", "0x41", 0x41);
}

#[test]
fn test_printing_strings() {
    let message = "hello world!";

    std::println(message);
    std::println("goodbye world");

    let array = [1, 2, 3, 5, 8];
    std::println(array);

    let hash = std::hash::pedersen(array);
    std::println(hash);

    // TODO: Printing structs currently not supported
    // let s = Test { a: 1, b: 2, c: [3, 4] };
    // std::println(s);
}

struct Test {
    a: Field,
    b: Field,
    c: [Field; 2],
}
```