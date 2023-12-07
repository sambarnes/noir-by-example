use dep::std::option::Option;

fn returns_none() -> Option<Field>{
    Option::none()
}

fn returns_some() -> Option<Field>{
    Option::some(3)
}

#[test]
fn test_optionals() {
    let none = returns_none();
    let some = returns_some();
    
    assert(none.is_none() == true);
    assert(none.is_some() == false);

    assert(some.is_none() == false);
    assert(some.is_some() == true);
}

#[test]
fn test_unwrap() {
    let none = returns_none();
    let some = returns_some();

    // only a Some(T) can be unwrapped
    assert(some.unwrap() == 3);

    // this would error since it's not Some
    // none.unwrap()

    // instead, we can give a default for the None case
    assert(none.unwrap_or(2) == 2);
    assert(some.unwrap_or(2) == 3);

    // or provide a function to call when None 
    let foo = || 5;
    assert(none.unwrap_or_else(foo) == 5);
    assert(some.unwrap_or_else(foo) == 3);
}
