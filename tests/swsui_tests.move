/// Module: swsui
module swsui::swsui_tests;

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

public struct Grid has store {
    row: u8,
    col: u8,
    value: u64,
}

public struct GridLi has store {
    grids: vector<Grid>,
}
#[test]
public fun create_grid_list(): GridLi {
    let mut grids = vector::empty<Grid>();

    let mut i = 0;
    while (i < 16) {
        let grid = Grid {
            row: (i / 4) as u8,
            col: (i % 4) as u8,
            value: 0,
        };
        vector::push_back(&mut grids, grid);
        i = i + 1;
    };

    GridLi { grids }
}
