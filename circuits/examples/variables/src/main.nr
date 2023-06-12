fn main() {
    let immutable_var = 17;
    // immutable_var = 38;  <-- fails to compile

    // but this is legal:
    let mut mutable_var = immutable_var;
    mutable_var = 38;

    // variables cannot go unused, try deleting this lines
    assert(immutable_var != mutable_var);
}

#[test]
fn test_main() {
    main();
}
