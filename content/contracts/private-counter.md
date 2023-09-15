---
title: "private counter"
date: 2023-09-09-T15:57:25-06:00
draft: false
---

a contract for users to `increment()` or `get()` their own secret counter

---

make sure you're on the right version of noir, and create the project

```
noirup -v aztec
nargo new --contract --name private_co private-counter
```

add the contract framework deps to your Nargo.toml

```toml {.codebox}
[dependencies]
aztec = { git = "https://github.com/AztecProtocol/aztec-nr", tag = "master" , directory = "aztec" }

# These ones are helpers for private state:
easy_private_state = { git = "https://github.com/AztecProtocol/aztec-nr", tag = "master" , directory = "easy-private-state" }
value_note = { git = "https://github.com/AztecProtocol/aztec-nr", tag = "master" , directory = "value-note" }
```

at first the boilerplate looks like this:

```rust {.codebox}
contract Main {
    internal fn double(x: Field) -> pub Field { x * 2 }
    fn triple(x: Field) -> pub Field { x * 3 }
    fn quadruple(x: Field) -> pub Field { double(double(x)) }
}
```

gut the funtions, bring some deps into scope (don't worry about these just yet)

```rust {.codebox}
contract PrivateCounter {
    use dep::std::option::Option;
    use dep::aztec::{
        context::{PrivateContext, PublicContext, Context},
        note::{
            note_header::NoteHeader,
            utils as note_utils,
        },
        state_vars::map::Map,
    };
    use dep::value_note::{
            balance_utils,
            value_note::{
                ValueNoteMethods,
                VALUE_NOTE_LEN,
            },
    };
    use dep::easy_private_state::easy_private_state::EasyPrivateUint;
}
```

contracts hold their state (public or private) in a `Storage` struct

make a map to store each owner's private count

```rust {.codebox}
contract PrivateCounter {
    ...

    struct Storage {
        counts: Map<EasyPrivateUint>,
    }

    impl Storage {
        fn init(context: Context) -> pub Self {
            Storage {
                counts: Map::new(
                    context,
                    1,
                    |context, slot| {
                        EasyPrivateUint::new(context, slot)
                    },
                ),
            }
        }
    }
}
```

the `constructor` holds initialization logic

```rust {.codebox}
contract PrivateCounter {
    ...

    // Initialise storage with some secret headstart for the owner
    #[aztec(private)]
    fn constructor(headstart: u120, owner: Field) {
        let storage = Storage::init(Context::private(&mut context));
        let counts = storage.counts;
        counts.at(owner).add(headstart, owner);
    }
}
```

users can `increment` or `get` their own counter (`unconstrained` is noir for solidity's `view`)

```rust {.codebox}
contract PrivateCounter {
    ...

    // Increment the owner's counter
    #[aztec(private)]
    fn increment(owner: Field)  {
        let storage = Storage::init(Context::private(&mut context));
        let counts = storage.counts;
        counts.at(owner).add(1, owner);
    }

    // A view function to get the owner's current count
    unconstrained fn get(owner: Field) -> Field {
        let storage = Storage::init(Context::none());
        let counts = storage.counts;

        // Return the sum of all notes in the set
        balance_utils::get_balance(counts.at(owner).set)
    }
}
```

and one last function -- every contract producing logs needs this, letting us compute different notes' hashes and nullifiers in different ways.

```rust {.codebox}
contract PrivateCounter {
    ...

    // Computes note hash and nullifier
    unconstrained fn compute_note_hash_and_nullifier(
        contract_address: Field,
        nonce: Field,
        storage_slot: Field,
        preimage: [Field; VALUE_NOTE_LEN],
    ) -> [Field; 4] {
        let note_header = NoteHeader { contract_address, nonce, storage_slot };
        note_utils::compute_note_hash_and_nullifier(ValueNoteMethods, note_header, preimage)
    }
}
```

and `nargo compile` to make sure it builds

🤫 🧮
