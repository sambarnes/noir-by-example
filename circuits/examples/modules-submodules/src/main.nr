use mysubmodule::foo;

fn main() {
    // call it directly if imported with `use`
    foo();

    // otherwise, include the full path
    mysubmodule::bar();
}

mod mysubmodule {
    use dep::std; // <-- imports can be scoped to a submodule

    fn foo() { std::println("foo") }
    fn bar() { std::println("bar") }
}

#[test]
fn test_main() {
    main();
}
