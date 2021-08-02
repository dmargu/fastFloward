import LocalArtist from "../../LocalArtist/contract.cdc"
import LocalArtistMarket from "../contract.cdc"

transaction(listingIndex: Int) {
    let seller: Address
    let marketRef: &{LocalArtistMarket.MarketInterface}
    prepare(account: AuthAccount) {
        self.marketRef = getAccount(${process.env.REACT_APP_ARTIST_CONTRACT_HOST_ACCOUNT})
            .getCapability(/public/LocalArtistMarket).borrow<&{LocalArtistMarket.MarketInterface}>()
                ?? panic("Couldn't borrow market reference.")
        self.seller = account.address
    }
    execute {
        self.marketRef.withdraw(listingIndex: listingIndex, seller: self.seller)
    }
}

