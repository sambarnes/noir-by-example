fn main() {
    let immutable_var = 17;
    // immutable_var = 38;  <-- fails to compile

    // but this is legal:
    let mut mutable_var = immutable_var;
    mutable_var = 38;

    assert(mutable_var != immutable_var);
}

#[test]
fn test_main() {
    main();
}
