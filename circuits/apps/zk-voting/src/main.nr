use dep::std;

fn main(
    root: pub Field,         // the "group id" for the voters
    proposal_id: pub Field,  // the individual topic being voted on
    vote: pub u8,            // yes (1) / no (0)
    index: Field,
    hash_path: [Field; 2],
    secret: Field,
    priv_key: Field,
) -> pub Field {

    // prove knowledge of some private key & group secret
    let note_commitment = std::hash::pedersen([priv_key, secret])[0];

    // ensure the voter is part of the group they claim to be voting in
    let computed_root = std::merkle::compute_merkle_root(note_commitment, index, hash_path);
    assert(root == computed_root);

    // ensure the vote is valid (only 0 or 1)
    assert(vote <= 1);

    // publicly return a hash making sure the same private key won't
    // vote multiple times for the same proposal, in the same group
    let nullifier = std::hash::pedersen([root, priv_key, proposal_id]);
    nullifier[0]
}

#[test]
fn test_main() {
    // prove a vote for the 0th voter
    let hash_path = [
        0x1053e87bed5f2a4f5144b386c5403701212f4b3c21cb14683b6ebdfed16c854d,
        0x1e8e7c1e1f6f65d0d3553e0f715c335f0ccdcc21cda1df7355e6c6e851bccf54,
    ];
    let private_key = 0;
    let group_secret = 9;

    let want_nullifier = (
        0x05c982d312d3c204160b6a692fb7b6e129235599f6c6e4077e794fe1cd7e7a63
    );
    let got_nullifier = main(
        0x20c77d6d51119d86868b3a37a64cd4510abd7bdb7f62a9e78e51fe8ca615a194,
        1,
        1,
        0,
        hash_path,
        group_secret,
        private_key,
    );
    assert(want_nullifier == got_nullifier);
}

// Helpers for getting note_commitments to build the merkle tree.
// To view: nargo test --show-output

#[test]
fn test_build_merkle_tree() {
    let secret = 9;
    let commitment_0 =  std::hash::pedersen([0, secret])[0];
    let commitment_1 =  std::hash::pedersen([1, secret])[0];
    let commitment_2 =  std::hash::pedersen([2, secret])[0];
    let commitment_3 =  std::hash::pedersen([3, secret])[0];

    let left_branch = std::hash::pedersen([commitment_0, commitment_1])[0];
    let right_branch = std::hash::pedersen([commitment_2, commitment_3])[0];

    let root = std::hash::pedersen([left_branch, right_branch])[0];

    std::println("Merkle Tree:");
    std::println([root]);
    std::println([left_branch, right_branch]);
    std::println([commitment_0, commitment_1, commitment_2, commitment_3]);
}
