use dep::std;

fn main() {
    // loop over a range
    for i in 0..5 {
        std::println(i);
    }

    // over a list, by index
    let foo = [123, 456, 789];
    for i in 0..foo.len() {
        let elem = foo[i];
        std::println(elem);
    }

    // or using for-each style
    for elem in foo {
        std::println(elem);
    }
}

#[test]
fn test_main() {
    main();
}
