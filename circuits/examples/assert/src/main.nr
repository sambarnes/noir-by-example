fn main(x : Field, y : pub Field) {
    assert(x != y);

    // optionally include an error message
    assert(x + y == 3, "Must sum to three");
}

#[test]
fn test_main() {
    main(1, 2);
}

#[test(should_fail)]
fn test_main_fails() {
    main(1, 1);
}

#[test(should_fail_with = "Must sum to three")]
fn test_main_fails_with_message() {
    main(3, 4);
}
