mod OrderType {
    global FULL_OPEN: Field = 0;
    global PARTIAL_OPEN: Field = 1;
    global FULL_RESTRICTED: Field = 2;
    global PARTIAL_RESTRICTED: Field = 3;
    global CONTRACT: Field = 4;
}

fn main(order_type: Field) {
    assert(order_type != OrderType::FULL_OPEN);
}

#[test]
fn test_main() {
    main(OrderType::PARTIAL_OPEN);
}
