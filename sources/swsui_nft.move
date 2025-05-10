// / Module: swsui
module swsui::swsui_nft;

use std::string::{Self, String};
use sui::display;
use sui::event;
use sui::package;
use sui::url::{Self, Url};

public struct Oka_Token has key, store {
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
        b"OKA1".to_string(),
        // For `link` one can build a URL using an `id` property
        // For `image_url` use an IPFS template + `image_url` property.
        b"ipfs://bafkreiakul5pov7ajwuf3ubunhx62vqiivsty2jkyzaai3xhcjotee3fcu".to_string(),
        b"ipfs://bafkreiakul5pov7ajwuf3ubunhx62vqiivsty2jkyzaai3xhcjotee3fcu".to_string(),
        // Description is static for all `Hero` objects.
        b"Oka Test 2025-05-08".to_string(),
        // Project URL is usually static
        // Creator field can be any
        b"Oka".to_string(),
    ];

    // Claim the `Publisher` for the package!
    let publisher = package::claim(otw, ctx);

    // Get a new `Display` object for the `Hero` type.
    let mut display = display::new_with_fields<Oka_Token>(
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

public fun name(nft: &Oka_Token): &String {
    &nft.name
}

public fun description(nft: &Oka_Token): &String {
    &nft.description
}

public fun url(nft: &Oka_Token): &Url {
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
    let sender = ctx.sender();
    let nft = Oka_Token {
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

public fun transfer(nft: Oka_Token, recipient: address, _: &mut TxContext) {
    transfer::public_transfer(nft, recipient)
}

public fun update_description(nft: &mut Oka_Token, new_description: vector<u8>, _: &mut TxContext) {
    nft.description = string::utf8(new_description)
}

public fun burn(nft: Oka_Token, _: &mut TxContext) {
    let Oka_Token { id, name: _, description: _, image_url: _, thumbnail_url: _ } = nft;
    id.delete()
}
