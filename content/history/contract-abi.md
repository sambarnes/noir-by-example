---
title: "contract abi"
date: 2023-06-10T09:07:14-06:00
draft: false
---

[feat(nargo): save program ABI alongside ACIR (#922)](https://github.com/noir-lang/noir/pull/922)

each function in a contract is compiled as a separate noir program

```rust
contract Foo {
    fn double(x: Field) -> pub Field { x * 2 }
    fn triple(x: pub Field) -> pub Field { x * 3 }
}
```

running `nargo compile --contracts basic-contracts` would produce its ABI as json:

```json
{
    "name": "Foo",
    "backend": "acvm-backend-barretenberg",
    "functions": [
        {
            "name": "triple",
            "function_type": "Secret",
            "abi": {
                "parameters": [
                    {
                        "name": "x",
                        "type": {"kind": "field"},
                        "visibility": "public"
                    }
                ],
                "param_witnesses": {"x": [1]},
                "return_type": {"kind": "field"},
                "return_witnesses": [2]
            },
            "bytecode": [...],
            "proving_key": [...],
            "verification_key": [...]
        },
        {
            "name": "double",
            "function_type": "Secret",
            "abi": {
                "parameters": [
                    {
                        "name": "x",
                        "type": {"kind": "field"},
                        "visibility": "private"
                    }
                ],
                "param_witnesses": {"x": [1]},
                "return_type": {"kind": "field"},
                "return_witnesses": [2]
            },
            "bytecode": [...],
            "proving_key": [...],
            "verification_key": [...]
        }
    ]
}
```
