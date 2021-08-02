import LocalArtist from "../../LocalArtist/contract.cdc"
import LocalArtistMarket from "../contract.cdc"
import FungibleToken from 0x9a0766d93b6608b7
import FlowToken from 0x7e60df042a9c0868

transaction(listingIndex: Int) {
    let buyer: Address
    let marketRef: &{LocalArtistMarket.MarketInterface}
    let tokenVault: @FungibleToken.vault
    prepare(account: AuthAccount) {
        self.marketRef = getAccount(${process.env.REACT_APP_ARTIST_CONTRACT_HOST_ACCOUNT})
            .getCapability(/public/LocalArtistMarket).borrow<&{LocalArtistMarket.MarketInterface}>()
                ?? panic("Couldn't borrow market reference.")
        self.buyer = account.address

        let listings = self.marketRef.getListings()
        let price = listings[listingIndex].price

        self.tokenVault <- account.borrow<&FlowToken.Vault{FungibleToken.Provider}>(from: /storage/flowTokenVault)!
            .withdraw(amount: price)
    }
    execute {
        self.marketRef.buy(listing: listingIndex, with: <- self.vault, buyer: self.buyer)
    }
}