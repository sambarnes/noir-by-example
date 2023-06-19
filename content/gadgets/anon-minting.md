---
title: "anon minting"
date: 2023-06-18T15:57:25-06:00
draft: true
og: "https://github.com/whitenois3/huh"
disableTryItOut: true
---

a solution to mint things anonymously

#### off-chain circuit

the entrypoint accepts two private inputs (`nullifier` and `secret`) and two public inputs (`nullifierHash` and `recipient`)

it validates the relationship between these parameters to ensure the user minting the token is the same one who paid for it

```rust {.codebox}
fn main(
    nullifier: Field,
    secret: Field,
    nullifierHash: pub Field,
    recipient: pub Field
) {
    let r = commitment(nullifier, secret);
    assert(r[1] == nullifierHash);
    assert(recipient == recipient);
}
```

the `commitmentHasher` generates the commitment and nullifier hash. It leverages the Pedersen hash function, an elliptic curve-based cryptographic hash function:

```rust {.codebox}
fn commitment(nullifier: Field, secret: Field) -> [Field; 2] {
    let commitment = std::hash::pedersen([nullifier, secret]);
    let nullifierHash = std::hash::pedersen([nullifier]);
    [commitment[0], nullifierHash[0]]
}
```

The `main` function uses `commitmentHasher` to create a commitment and nullifier hash, which it then verifies against the provided public inputs (`nullifierHash` and `recipient`).


#### token contract

when minting your thing, split the process into two steps: deposit and claim

```solidity {.codebox}
abstract contract Minter is TurboVerifier {
    // Contract initialization and mappings...
    function _deposit(bytes32 commitment) internal {...}
    function _claim(bytes calldata proof) internal returns (bool success, address recipient) {...}
}
```

The `_deposit` function allows a user to deposit a commitment, which is stored in the `commitments` mapping. It ensures the same commitment isn't used twice.

The `_claim` function verifies the zero-knowledge proof. If valid, it updates the `nullifierHashes` mapping and returns the recipient's address. The function also includes checks to ensure the claim isn't made too early and that the same nullifier isn't used more than once.

```solidity {.codebox}
pragma solidity ^0.8.15;

import {TurboVerifier} from "./Verifier.sol";

abstract contract Minter is TurboVerifier {

    /// @notice Time after which claims can be executed.
    /// @notice Should better anonynimty.
    uint256 public immutable START;
    mapping(bytes32 => bool) public nullifierHashes;
    mapping(bytes32 => bool) public commitments;

    constructor(uint256 start) {
        START = start;
    }
    
    /// @notice Deposit.
    /// @param commitment The commitment.
    function _deposit(bytes32 commitment) internal {
        require(!commitments[commitment], "Commitment already used");
        commitments[commitment] = true;
    }

    /// @notice Claim ... well ... anything?
    /// @param proof The proof.
    /// @return success If verification of proof was successful (will revert if not anyways).
    /// @return recipient The address of the recipient.
    function _claim(bytes calldata proof) internal returns (bool success, address recipient) {
        require(block.timestamp >= START, "Too early");
        (bytes32 nullifierHash, address _recipient) = abi.decode(proof, (bytes32, address));
        require(!nullifierHashes[nullifierHash], "Nullifier already used");
        require(this.verify(proof), "Invalid proof");
        nullifierHashes[nullifierHash] = true;
        return (true, _recipient);
    }
}
```
