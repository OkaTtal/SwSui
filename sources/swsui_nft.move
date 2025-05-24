// / Module: swsui
module swsui::swsui_nft;

use std::string::{Self, String};
use sui::display;
use sui::event;
use sui::package;
use sui::url::{Self, Url};

// use swsui::swsui::GridLi;

public struct SwSui_NFT has key, store {
    id: UID,
    name: String,
    description: String,
    image_url: Url,
    thumbnail_url: Url,
}

public struct SWSUI_NFT has drop {}

fun init(otw: SWSUI_NFT, ctx: &mut TxContext) {
    let keys = vector[
        b"name".to_string(),
        b"image_url".to_string(),
        b"thumbnail_url".to_string(),
        b"description".to_string(),
        b"creator".to_string(),
    ];

    let values = vector[
        // For `name` one can use the `Hero.name` property
        b"Waves".to_string(),
        // For `link` one can build a URL using an `id` property
        // For `image_url` use an IPFS template + `image_url` property.
        b"https://i.postimg.cc/hjJ4Zt8x/swsui-nft.jpg".to_string(),
        b"https://i.postimg.cc/hjJ4Zt8x/swsui-nft.jpg".to_string(),
        // Description is static for all `Hero` objects.
        b"SwSui NFT".to_string(),
        // Project URL is usually static
        // Creator field can be any
        b"SwSui".to_string(),
    ];

    // Claim the `Publisher` for the package!
    let publisher = package::claim(otw, ctx);

    // Get a new `Display` object for the `Hero` type.
    let mut display = display::new_with_fields<SwSui_NFT>(
        &publisher,
        keys,
        values,
        ctx,
    );

    // Commit first version of `Display` to apply changes.
    display.update_version();

    transfer::public_transfer(publisher, ctx.sender());
    transfer::public_transfer(display, ctx.sender());
}

public struct NFTMinted has copy, drop {
    object_id: ID,
    creator: address,
    name: String,
}

public fun name(nft: &SwSui_NFT): &String {
    &nft.name
}

public fun description(nft: &SwSui_NFT): &String {
    &nft.description
}

public fun url(nft: &SwSui_NFT): &Url {
    &nft.image_url
}

#[allow(lint(self_transfer))]
public fun mint_to_sender(
    name: vector<u8>,
    description: vector<u8>,
    image_url: vector<u8>,
    thumbnail_url: vector<u8>,
    ctx: &mut TxContext,
) {
    // let grids_confirm = move_from<GridLi>(grid_li_id);
    let sender = ctx.sender();
    let nft = SwSui_NFT {
        id: object::new(ctx),
        name: string::utf8(name),
        description: string::utf8(description),
        image_url: url::new_unsafe_from_bytes(image_url),
        thumbnail_url: url::new_unsafe_from_bytes(thumbnail_url),
    };

    event::emit(NFTMinted {
        object_id: object::id(&nft),
        creator: sender,
        name: nft.name,
    });

    transfer::public_transfer(nft, sender);
}

public fun transfer(nft: SwSui_NFT, recipient: address, _: &mut TxContext) {
    transfer::public_transfer(nft, recipient)
}

public fun update_description(nft: &mut SwSui_NFT, new_description: vector<u8>, _: &mut TxContext) {
    nft.description = string::utf8(new_description)
}

// public fun burn(nft: SwSui_NFT, _: &mut TxContext) {
//     let SwSui_NFT { id, name: _, description: _, image_url: _, thumbnail_url: _, grids_confirm } =nft;
//     id.delete()
// }
