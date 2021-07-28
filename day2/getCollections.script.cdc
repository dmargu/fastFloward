import Artist from 0x01

// print the pictues in each collection
// if there isn't a collection resource log "No collection resource for account x yet"

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

pub fun displayPics(collection: &Artist.Collection) {
    var counter = 0
    while collection.pictures.length > counter {
        log(collection)
        display(canvas: collection.pictures[counter].canvas)
        counter = counter + 1
    }
}

pub fun main() {
    let collectRef1 = getAccount(0x01).getCapability<&Artist.Collection>(/public/CollectionCapability).borrow()
      ?? panic("Couldn't borrow collection reference.")
    displayPics(collection: collectRef1)

  let collectRef2: &Artist.Collection? = getAccount(0x02).getCapability<&Artist.Collection>(/public/CollectionCapability).borrow()
      ?? panic("Couldn't borrow collection reference 2.")

  let collectRef3: &Artist.Collection? = getAccount(0x03).getCapability<&Artist.Collection>(/public/CollectionCapability).borrow()
      ?? panic("Couldn't borrow collection reference 3.")

  let collectRef4: &Artist.Collection? = getAccount(0x04).getCapability<&Artist.Collection>(/public/CollectionCapability).borrow()
      ?? panic("Couldn't borrow collection reference 4.")

  let collectRef5: &Artist.Collection? = getAccount(0x05).getCapability<&Artist.Collection>(/public/CollectionCapability).borrow()
      ?? panic("Couldn't borrow collection reference 5.")
}

