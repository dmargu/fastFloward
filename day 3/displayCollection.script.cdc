import Artist from "./contract.cdc"
// Return an array of formatted Pictures that exist in the account with the a specific address.
// Return nil if that account doesn't have a Picture Collection.

pub fun display(canvas: Artist.Canvas) {
    let frameTopBottom = "+-----+"
    let frameSide = "|"
    // need to add frameTopBottom as first and last element
    // need to add frame side, take five letters of a string, then add another
    // can add all of these as items
    var i = 0
    var stringNum = 0
    let intHeight = Int(canvas.height)
    let intWidth = Int(canvas.width)
    log(frameTopBottom)
    while i < intHeight {
        let line = frameSide.concat(canvas.pixels.slice(from: stringNum, upTo: stringNum + intWidth).concat(frameSide))
        stringNum =  stringNum + intWidth
        i = i + 1
        log(line)
    }
    log(frameTopBottom)
}

pub fun displayPics(collection: &Artist.Collection): [String] {
    var counter = 0
    var allPixels: [String] = []
    while collection.pictures.length > counter {
        display(canvas: collection.pictures[counter].canvas)
        allPixels.append(collection.pictures[counter].canvas.pixels)
        counter = counter + 1
    }
    return allPixels
}

pub fun main(address: Address): [String]? {
    let collectRef = getAccount(address).getCapability<&Artist.Collection>(/public/CollectionCapability).borrow()!
    if collectRef != nil {
        return displayPics(collection: collectRef)
    }
    else { 
        log("No collection exists for this account.")
        return nil

    }
}