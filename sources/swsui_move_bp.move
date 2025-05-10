// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

// public struct Grid has store {
//     id: u8,
//     value: u8,
// }
// public struct GridLi has key, store {
//     id: UID,
//     grids: vector<Grid>,
//     gameover: bool,
// }

// fun random_number(r: &Random, len: u64, ctx: &mut TxContext): u8 {
//     let mut generator = new_generator(r, ctx); // generator is a PRG
//     generate_u8_in_range(&mut generator, 1, (len as u8))
// }

// fun add_random_tile(grid_li: &mut GridLi, rand: &Random, ctx: &mut TxContext) {
//     let grids = &mut grid_li.grids;
//     let mut empty_positions = vector::empty<u8>();
//     let len = vector::length(grids);
//     let mut i = 0;
//     while (i < len) {
//         if (grids[i].value == 0) {
//             vector::push_back(&mut empty_positions, i as u8);
//         };
//         i = i + 1;
//     };
//     let pos_len = vector::length(&empty_positions);
//     if (pos_len == 0) {
//         return
//     };

//     let rand_index = random_number(rand, pos_len as u64, ctx);
//     let index = *vector::borrow(&empty_positions, rand_index as u64);
//     let val = if (random_number(rand, 2, ctx) == 0) { 2 } else { 4 };
//     grids[index as u64].value = val;
// }

// entry fun create_grid_list(rand: &Random, ctx: &mut TxContext) {
//     let mut new_grids = vector::empty<Grid>();

//     let mut i: u8 = 1;

//     while (i <= 16) {
//         let grid = Grid {
//             id: i,
//             value: 0,
//         };
//         vector::push_back(&mut new_grids, grid);
//         i = i + 1;
//     };

//     let mut my_GridLi = GridLi {
//         id: object::new(ctx),
//         grids: new_grids,
//         gameover: false,
//     };
//     add_random_tile(&mut my_GridLi, rand, ctx);
//     add_random_tile(&mut my_GridLi, rand, ctx);
//     transfer::public_transfer(my_GridLi, tx_context::sender(ctx));
// }

// entry fun move_left(grid_li: &mut GridLi) {
//     let (row1, row2, row3, row4) = (0, 4, 8, 12);
//     move_left_process(grid_li, row1);
//     move_left_process(grid_li, row2);
//     move_left_process(grid_li, row3);
//     move_left_process(grid_li, row4);
// }

// entry fun move_left_process(grid_li: &mut GridLi, row: u64) {
//     let mut row1 = row;
//     let end = row+3;
//     let mut move_step: u8 = 0;
//     let mut cur: u8 = 0;
//     let mut last_index: u64 = 0;
//     let grids = &mut grid_li.grids;
//     while (row1 <= end) {
//         if (grids[row1].value==0) {
//             move_step = move_step+1;
//         } else {
//             if (cur!=0&&cur==grids[row1].value) {
//                 grids[row1].value = 0;
//                 grids[last_index].value = cur*2;
//                 move_step = move_step+1;
//                 cur = 0;
//             } else {
//                 cur = grids[row1].value
//             };
//             if (move_step>0&&grids[row1].value!=0) {
//                 last_index = row1-((move_step*1) as u64);
//                 grids[last_index].value = grids[row1].value;
//                 grids[row1].value = 0;
//             } else if (move_step==0&&grids[row1].value!=0) {
//                 last_index = row1-((move_step*1) as u64);
//             }
//         };
//         if (row1 == end) break;
//         row1 = row1+1
//     }
// }

// entry fun move_right(grid_li: &mut GridLi) {
//     let (row1, row2, row3, row4) = (3, 7, 11, 15);
//     move_right_process(grid_li, row1);
//     move_right_process(grid_li, row2);
//     move_right_process(grid_li, row3);
//     move_right_process(grid_li, row4);
// }

// entry fun move_right_process(grid_li: &mut GridLi, row: u64) {
//     let mut row1 = row;
//     let end = row-3;
//     let mut move_step: u8 = 0;
//     let mut cur: u8 = 0;
//     let mut last_index: u64 = 0;
//     let grids = &mut grid_li.grids;
//     while (row1 >= end) {
//         if (grids[row1].value==0) {
//             move_step = move_step+1;
//         } else {
//             if (cur!=0&&cur==grids[row1].value) {
//                 grids[row1].value = 0;
//                 grids[last_index].value = cur*2;
//                 move_step = move_step+1;
//                 cur = 0;
//             } else {
//                 cur = grids[row1].value
//             };
//             if (move_step>0&&grids[row1].value!=0) {
//                 last_index = row1+((move_step*1) as u64);
//                 grids[last_index].value = grids[row1].value;
//                 grids[row1].value = 0;
//             } else if (move_step==0&&grids[row1].value!=0) {
//                 last_index = row1-((move_step*1) as u64);
//             };
//         };
//         if (row1 == end) break;
//         row1 = row1-1
//     }
// }

// entry fun move_down(grid_li: &mut GridLi) {
//     let (row1, row2, row3, row4) = (12, 13, 14, 15);
//     move_down_process(grid_li, row1);
//     move_down_process(grid_li, row2);
//     move_down_process(grid_li, row3);
//     move_down_process(grid_li, row4);
// }

// entry fun move_down_process(grid_li: &mut GridLi, row: u64) {
//     let mut row1 = row;
//     let end = row-12;
//     let mut move_step: u8 = 0;
//     let mut cur: u8 = 0;
//     let mut last_index: u64 = 0;
//     let grids = &mut grid_li.grids;
//     while (row1 >= end) {
//         if (grids[row1].value==0) {
//             move_step = move_step+1;
//         } else {
//             if (cur!=0&&cur==grids[row1].value) {
//                 grids[row1].value = 0;
//                 grids[last_index].value = cur*2;
//                 move_step = move_step+1;
//                 cur = 0;
//             } else {
//                 cur = grids[row1].value
//             };
//             if (move_step>0&&grids[row1].value!=0) {
//                 last_index = row1+((move_step*4) as u64);
//                 grids[last_index].value = grids[row1].value;
//                 grids[row1].value = 0;
//             } else if (move_step==0&&grids[row1].value!=0) {
//                 last_index = row1-((move_step*1) as u64);
//             };
//         };
//         if (row1 == end) break;
//         row1 = row1-4
//     }
// }

// entry fun move_up(grid_li: &mut GridLi) {
//     let (row1, row2, row3, row4) = (0, 1, 2, 3);
//     move_up_process(grid_li, row1);
//     move_up_process(grid_li, row2);
//     move_up_process(grid_li, row3);
//     move_up_process(grid_li, row4);
// }

// entry fun move_up_process(grid_li: &mut GridLi, row: u64) {
//     let mut row1 = row;
//     let end = row+12;
//     let mut move_step: u8 = 0;
//     let mut cur: u8 = 0;
//     let mut last_index: u64 = 0;
//     let grids = &mut grid_li.grids;
//     while (row1 <= end) {
//         if (grids[row1].value==0) {
//             move_step = move_step+1;
//         } else {
//             if (cur!=0&&cur==grids[row1].value) {
//                 grids[row1].value = 0;
//                 grids[last_index].value = cur*2;
//                 move_step = move_step+1;
//                 cur = 0;
//             } else {
//                 cur = grids[row1].value
//             };
//             if (move_step>0&&grids[row1].value!=0) {
//                 last_index = row1-((move_step*4) as u64);
//                 grids[last_index].value = grids[row1].value;
//                 grids[row1].value = 0;
//             } else if (move_step==0&&grids[row1].value!=0) {
//                 last_index = row1-((move_step*1) as u64);
//             };
//         };
//         if (row1 == end) break;
//         row1 = row1+4
//     }
// }

// entry fun new_number(grid_li: &mut GridLi) {
//     let grids = &mut grid_li.grids;
//     let mut positions: vector<u8> = vector[];
//     let mut i = 0;
//     let len = vector::length(grids);
//     while (i < len) {
//         if (grids[i].value == 0) {
//             positions.push_back((i as u8));
//             i = i+1;
//         }
//     };
//     let new_len = vector::length(&positions);
//     // let r_num = random_number(tx.object.random(),new_len,tx.object.txContext());
// }
// #[test]
// entry fun test_create_and_move_left(): GridLi {
//     let mut ctx = tx_context::dummy();
//     let mut grid_li = create_grid_list(&mut ctx);

//     // Set initial values
//     {
//         let grids = &mut grid_li.grids;
//         grids[0].value = 2;
//         grids[1].value = 2;
//         grids[2].value = 0;
//         grids[3].value = 2;
//         grids[4].value = 2;
//         grids[8].value = 4;
//         // The mutable borrow ends here
//     };

//     // Now it's safe to call move_left
//     move_down(&mut grid_li);

//     // Assert after move_left
//     let grids = &grid_li.grids;
//     assert!(grids[0].value == 0, 0);
//     assert!(grids[1].value == 0, 1);
//     assert!(grids[12].value == 4, 3);
//     assert!(grids[8].value == 4, 4);
//     assert!(grids[13].value == 2, 4);

//     grid_li
// }
