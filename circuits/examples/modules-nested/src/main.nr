mod foo; // <-- declare the foo module

fn main(x: Field) {
    assert(foo::hello(x) != foo::bar::goodbye(x));
}

#[test]
fn test_main() {
    main(1);
}
