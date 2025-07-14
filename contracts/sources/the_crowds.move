module the_crowds_addr::the_crowds {
    use aptos_framework::primary_fungible_store;
    use aptos_framework::fungible_asset::{Self, MintRef, TransferRef, BurnRef, Metadata, FungibleStore, FungibleAsset, ConcurrentSupply};
    use std::option;
    use std::signer;
    use std::string::{Self, String};
    use aptos_framework::object::{Self, Object};
    use aptos_framework::aptos_account;
    use 0x1::event; 

   #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct AssetManager has key {
        mint_ref: MintRef,
        transfer_ref: TransferRef,
        burn_ref: BurnRef,
    }

    const BASE_PRICE: u64 = 1000; // 0.1 APT
    const SLOPE: u64 = 100;       // Increase price by 0.01 APT per token

    #[event]
    struct CreateAssetEvent has drop, store {
        name: String,
        symbol: String,
        icon_uri: String,
        project_uri: String,
        decimal: u8,
        asset_address: address,
        price: u64
    }

    #[event]
    struct BuyAssetEvent has drop, store {
        asset_address: address,
        buyer_address: address,
        apt_amount: u64,
        amount_bought: u64,
        new_supply: u64,
        new_price: u64
    }

    #[event]
    struct SellAssetEvent has drop, store {
        asset_address: address,
        seller_address: address,
        apt_amount: u64,
        amount_sold: u64,
        new_supply: u64,
        new_price: u64
    }

    public fun get_price(supply: u128, base_price: u64, slope: u64): u64 {
        base_price + (slope * (supply as u64))
    }

    public entry fun create_asset(deployer: &signer, name: String, symbol: String, icon_uri: String, project_uri: String) {
        let metadata_constructor_ref = &object::create_named_object(deployer, *string::bytes(&symbol));
        let max_supply = option::none();

        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            metadata_constructor_ref,
            max_supply,
            name,
            symbol,
            6,
            icon_uri,
            project_uri,
        );
        let deployer_addr = signer::address_of(deployer);

        let create_asset_event = CreateAssetEvent {
            name: name,
            symbol: symbol,
            icon_uri: icon_uri,
            project_uri: project_uri,
            decimal: 6,
            price: BASE_PRICE,
            asset_address: asset_address(deployer_addr, symbol)
        };

        event::emit<CreateAssetEvent>(create_asset_event);

        let mint_ref = fungible_asset::generate_mint_ref(metadata_constructor_ref);
        let transfer_ref = fungible_asset::generate_transfer_ref(metadata_constructor_ref);
        let burn_ref = fungible_asset::generate_burn_ref(metadata_constructor_ref);
        let metadata_object_signer = &object::generate_signer(metadata_constructor_ref);

        move_to(
            metadata_object_signer,
            AssetManager { mint_ref, transfer_ref, burn_ref }
        );

    }

    // Amount is number of tokens to buy
    public entry fun buy(buyer: &signer, asset_addr: address, amount: u64) acquires AssetManager {
        let mint_ref = &borrow_global<AssetManager>(asset_addr).mint_ref;
        let buyer_addr = signer::address_of(buyer);

        let supply = option::borrow(&fungible_asset::supply(asset_metadata(asset_addr)));

        let price = get_price(*supply, BASE_PRICE, SLOPE);
        let apt_amount = (amount * price) as u64;

        aptos_account::transfer(buyer, @the_crowds_addr, apt_amount);
        primary_fungible_store::mint(mint_ref, buyer_addr, amount);

        let supply = option::borrow(&fungible_asset::supply(asset_metadata(asset_addr)));
        let price = get_price(*supply, BASE_PRICE, SLOPE);

        let buy_asset_event = BuyAssetEvent {
            asset_address: asset_addr,
            buyer_address: buyer_addr,
            apt_amount: apt_amount,
            amount_bought: amount,
            new_supply: *supply as u64,
            new_price: price
        };

        event::emit<BuyAssetEvent>(buy_asset_event);
    }

    // Amount is the amount of tokens to sell
    public entry fun sell(seller: &signer, asset_addr: address, amount: u64) acquires AssetManager {
        let seller_addr = signer::address_of(seller);
        let burn_ref = &borrow_global<AssetManager>(asset_addr).burn_ref;


        // TODO: Add transfer APT to seller
        primary_fungible_store::burn(burn_ref, seller_addr, amount);

        let supply = option::borrow(&fungible_asset::supply(asset_metadata(asset_addr)));
        let price = get_price(*supply, BASE_PRICE, SLOPE);

        let sell_asset_event = SellAssetEvent {
            asset_address: asset_addr,
            seller_address: seller_addr,
            apt_amount: price * amount,
            amount_sold: amount,
            new_supply: *supply as u64,
            new_price: price
        };

        event::emit<SellAssetEvent>(sell_asset_event);

    }

    #[view]
    public fun check_price(asset_addr: address): u64 {
        let supply = option::borrow(&fungible_asset::supply(asset_metadata(asset_addr)));
        let price = get_price(*supply, BASE_PRICE, SLOPE);
        price
    }

    #[view]
    public fun asset_address(deployer: address, symbol: String): address {
        object::create_object_address(&deployer, *string::bytes(&symbol))
    }
    
    #[view]
    public fun asset_metadata(asset_address: address): Object<Metadata> {
        object::address_to_object(asset_address)
    }

    #[test(deployer=@0x123)]
    fun test_function(deployer: signer) {
        create_asset(&deployer, string::utf8(b"name"), string::utf8(b"symbol"), string::utf8(b"icon_uri"), string::utf8(b"project_uri"));
    }
}
