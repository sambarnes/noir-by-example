---
title: "private counter"
date: 2023-09-09-T15:57:25-06:00
draft: false
---

a contract for users to `increment()` or `get()` their own secret counter

🤫 🧮

---

before we get started, go through Aztec's [installation instructions](https://docs.aztec.network/dev_docs/getting_started/quickstart) for the developer sandbox

make sure you're on the right version of noir, and create the project

```shell {.codebox}
noirup -v v0.18.0-aztec.5
nargo new --contract --name private_co private-counter
```

add the contract framework deps to your Nargo.toml

```toml {.codebox}
[dependencies]
aztec = { git="https://github.com/AztecProtocol/aztec-packages", tag="aztec-packages-v0.16.7", directory="yarn-project/aztec-nr/aztec" }

# These ones are helpers for private state:
value_note = { git="https://github.com/AztecProtocol/aztec-packages", tag="aztec-packages-v0.16.7", directory="yarn-project/aztec-nr/value-note"}
easy_private_state = { git="https://github.com/AztecProtocol/aztec-packages", tag="aztec-packages-v0.16.7", directory="yarn-project/aztec-nr/easy-private-state"}
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
    fn increment(owner: Field) {
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
        preimage: [Field; VALUE_NOTE_LEN]
    ) -> [Field; 4] {
        let note_header = NoteHeader::new(contract_address, nonce, storage_slot);
        note_utils::compute_note_hash_and_nullifier(ValueNoteMethods, note_header, preimage)
    }
}
```

now we'll compile our source & produce a "contract artifacts" file (similar to ABIs you've seen on Ethereum)

```shell {.codebox}
$ aztec-cli compile .
Compiling . with wasm backend...
Writing PrivateCounter artifact to target/PrivateCounter.json
```

finally, we can deploy it and verify the counter's behavior

---

### deploy & test

take the first address in your local accounts

```shell {.codebox}
$ aztec-cli get-accounts
Accounts found:
 Address: 0x06357cc85cb8fc561adbf741f63cd75efa26ffba1c80d431ec77d036d8edf022
 ...
```

and deploy our code, specifying a headstart of 100 for the deployer

```shell {.codebox}
$ aztec-cli deploy target/PrivateCounter.json --args 100 0x06357cc85cb8fc561adbf741f63cd75efa26ffba1c80d431ec77d036d8edf022

Contract deployed at 0x1776ab04d4df75147e1ba7e02ba9173da2bf9da693711c32742ffbbc027b88af

Contract partial address 0x08f6e28ee4dfc8ed387c106b86991fdaa36647006123565138eaf5903b8c54e8
```

checking current counts, we see that the deployer has 100 while some other address is at zero

```shell {.codebox}
$ aztec-cli call get \                  
--args 0x06357cc85cb8fc561adbf741f63cd75efa26ffba1c80d431ec77d036d8edf022 \
--contract-artifact target/PrivateCounter.json \
--contract-address 0x1776ab04d4df75147e1ba7e02ba9173da2bf9da693711c32742ffbbc027b88af        

View result:  100n 

$ private-counter git:(main) ✗ aztec-cli call get \
--args 0x1b18a972d54db0283a04abaace5f7b03c3fca5a4b2c0cf113b457de6ea4991e7 \
--contract-artifact target/PrivateCounter.json \
--contract-address 0x1776ab04d4df75147e1ba7e02ba9173da2bf9da693711c32742ffbbc027b88af 

View result:  0n 
```

now see if you can increment a user's counter with `aztec-cli`

*(hint: feel free to go back to the [aztec-cli quickstart](https://docs.aztec.network/dev_docs/getting_started/quickstart) for the command's usage)*
