// / Module: swsui
module swsui::swsui;

use sui::display;
use sui::package;

public struct Grid has copy, drop, store {
    row: u8,
    col: u8,
    value: u64,
}
public struct GridLi has key, store {
    id: UID,
    grids: vector<Grid>,
    keys: vector<KeyConfirm>,
    gameover: bool,
    minted: bool,
    score: u64,
    move_step: u64,
}
public struct SWSUI has drop {}

public struct KeyConfirm has copy, drop, store {
    grids: vector<Grid>,
    score: u64,
    move_step: u64,
}

fun init(otw: SWSUI, ctx: &mut TxContext) {
    let keys = vector[
        b"name".to_string(),
        b"image_url".to_string(),
        b"thumbnail_url".to_string(),
        b"description".to_string(),
        b"creator".to_string(),
    ];

    let values = vector[
        b"2048 game board".to_string(),
        b"ipfs://bafybeighr4vxio3ibq56caivcfcck6vdngydexx6xylip26ksch7gmcvpa".to_string(),
        b"https://ipfs.io/ipfs/bafybeighr4vxio3ib56caivcfcck6vdngydexx6xylip26ksch7gmcvpa".to_string(),
        b"SwSui 2048 board".to_string(),
        b"SwSui".to_string(),
    ];

    let publisher = package::claim(otw, ctx);

    let mut display = display::new_with_fields<GridLi>(
        &publisher,
        keys,
        values,
        ctx,
    );

    display.update_version();

    transfer::public_transfer(publisher, ctx.sender());
    transfer::public_transfer(display, ctx.sender());
}
#[allow(lint(self_transfer))]
public fun mint_to_sender(grid_li: GridLi, ctx: &mut TxContext) {
    let sender = ctx.sender();
    let nft: GridLi = grid_li;
    transfer::public_transfer(nft, sender);
}

entry fun create_grid_list(ctx: &mut TxContext) {
    let mut new_grids = vector::empty<Grid>();
    let mut i = 0;
    while (i < 16) {
        let grid = Grid {
            row: i / 4,
            col: i % 4,
            value: 0,
        };
        vector::push_back(&mut new_grids, grid);
        i = i + 1;
    };
    let my_GridLi = GridLi {
        id: object::new(ctx),
        grids: new_grids,
        keys: vector::empty<KeyConfirm>(),
        gameover: false,
        minted: false,
        move_step: 0,
        score: 0,
    };
    transfer::public_transfer(my_GridLi, ctx.sender());
}

entry fun async_grid_list(
    old_grid_li: &mut GridLi,
    col: vector<u8>,
    row: vector<u8>,
    value: vector<u64>,
    gameover: bool,
    score: u64,
    move_step: u64,
) {
    let len = vector::length(&col);
    assert!(len == vector::length(&row), 0);
    assert!(len == vector::length(&value), 1);
    let mut new_grids = vector::empty<Grid>();
    let mut i = 0;
    while (i < len) {
        let grid = Grid {
            row: *vector::borrow(&row, i),
            col: *vector::borrow(&col, i),
            value: *vector::borrow(&value, i),
        };
        vector::push_back(&mut new_grids, grid);
        i = i + 1;
    };

    let key_confirm = KeyConfirm {
        grids: new_grids,
        score: score,
        move_step: move_step,
    };
    old_grid_li.grids = key_confirm.grids;
    old_grid_li.gameover = gameover;
    old_grid_li.score = score;
    old_grid_li.move_step = move_step;
    vector::push_back(&mut old_grid_li.keys, key_confirm);
}
