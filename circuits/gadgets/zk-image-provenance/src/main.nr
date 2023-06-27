use dep::std;

// Get the value at (x, y) in a 2D array of width `width`.
fn get_value<N>(src: [Field; N], width: Field, x: Field, y: Field) -> Field {
    src[x + y * width]
}


fn prove_crop<N, M, D>(
    src: [Field; N],
    src_width: Field,
    crop_origin: (Field, Field),
    dst: [Field; M],
    dst_width: Field,
    // HACK: dst_width is not a const, so it cannot be used in loops.
    //       Instead, we duplicate the data for the first row, so its generic length
    //       can be used in the loop bounds.
    dst_first_row: [Field; D],
) {
    // Only allow square images & crops for simplicity.
    assert(src_width * src_width == src.len());
    assert(dst_width * dst_width == dst.len());
    assert(dst_width == dst_first_row.len());

    // Ensure the crop is within the source image.
    let (x, y) = crop_origin;
    assert((x + dst_width) as u16 <= src_width as u16);
    assert((y + dst_width) as u16 <= src_width as u16);

    // HACK: Can't use dst_width in the range here because it's not a const.
    for i in 0..D {
        for j in 0..D {
            let got = get_value(src, src_width, x + i, y + j);
            let want = get_value(dst, dst_width, i, j);
            assert(got == want);
        }
    }
}

#[test]
fn test_get_value() {
    let src = [
        1, 0, 0,
        0, 2, 0,
        0, 0, 3
    ];
    let mut got = get_value(src, 3, 0, 0);
    assert(got == 1);

    got = get_value(src, 3, 1, 1);
    assert(got == 2);

    got = get_value(src, 3, 2, 2);
    assert(got == 3);
}

#[test]
fn test_prove_crop() {
    let src = [
        0, 0, 0,
        0, 1, 0,
        0, 0, 0
    ];
    let mut dst = [
        0, 0,
        0, 1
    ];
    let mut dst_first_row = [
        0, 0
    ];
    prove_crop(src, 3, (0, 0), dst, 2, dst_first_row);

    dst = [
        1, 0,
        0, 0
    ];
    dst_first_row = [
        1, 0
    ];
    prove_crop(src, 3, (1, 1), dst, 2, dst_first_row);
}
