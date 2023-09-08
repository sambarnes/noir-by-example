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
