mod foo; // <-- declare the foo module

fn main(x: Field, y: pub Field) {
    assert(x != foo::hello(y));
    assert(x != foo::hi(y));
}

#[test]
fn test_main() {
    main(1, 3);
}
