import Artist from "./contract.cdc"

transaction() {
    prepare(account: AuthAccount) {
        let collection <- Artist.createEmptyCollection()

        account.save<@Artist.Collection>(<- collection, to: /storage/Collection)
        account.link<&Artist.Collection>(/public/CollectionCapability, target: /storage/Collection)
    }
}
 