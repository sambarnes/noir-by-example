fn main(pair: (Field, Field)) {
    assert(pair.0 == 1);
    assert(pair.1 == 0);

    // tuples can be unpacked into separate vars
    let (a, b) = if true { (0, 1) } else { (2, 3) };
    assert(a == 0);
    assert(b == 1);

    // by default, individual elements cannot be mutated
    // pair.0 = 5;

    // with mut, individual elemets can be mutated
    let mut mutable = ((0, 0), 1, 2, 3);
    mutable.0 = pair;
    mutable.2 = 7;
    assert(mutable.0.0 == 1);
    assert(mutable.0.1 == 0);
    assert(mutable.1 == 1);
    assert(mutable.2 == 7);
    assert(mutable.3 == 3);
}

#[test]
fn test_main() {
    let pair = (1, 0);
    main(pair);
}
