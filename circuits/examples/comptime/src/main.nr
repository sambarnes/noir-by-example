fn main() -> pub Field {
    let known_at_compile_time: comptime Field = 1;

    // `comptime Field` can also be inferred
    let inferred_known = 2;

    // cannot be mutable tho, so this would fail
    // let mut bad_var: comptime Field = 3;
    // bad_var = 4;

    known_at_compile_time + inferred_known
}

#[test]
fn test_main() {
   let result =  main();
    assert(result == 3);
}
