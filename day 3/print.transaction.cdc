import Artist from "contract.cdc"

transaction() {
  
  let pixels: String
  let width: UInt8
  let height: UInt8
  let picture: @Artist.Picture?
  let collectionRef: &Artist.Collection?

  prepare(account: AuthAccount) {
    let printerRef = getAccount(0x01cf0e2f2f715450).getCapability<&Artist.Printer>(/public/ArtistPicturePrinterCapability).borrow()
      ?? panic("Couldn't borrow printer reference.")
    self.collectionRef = account.getCapability<&Artist.Collection>(/public/CollectionCapability).borrow()
      ?? panic("Couldn't borrow collection reference.")
    
    self.pixels = "**  * * *   *   * * *   *"
    let canvas = Artist.Canvas(
      width: printerRef.width,
      height: printerRef.height,
      pixels: self.pixels
    )
    
    self.picture <- printerRef.print(canvas: canvas)
    self.width = canvas.width
    self.height = canvas.height
  }

  execute {
    if (self.picture == nil) {
        log("Picture with ".concat(self.pixels).concat(" already exists!"))
        destroy self.picture
    }   else {
            self.collectionRef?.deposit(picture: <- self.picture!)
            let frameTopBottom = "+-----+"
            let frameSide = "|"
            var i = 0
            var stringNum = 0
            let intHeight = Int(self.height)
            let intWidth = Int(self.width)
            log(frameTopBottom)
            while i < intHeight {
                let line = frameSide.concat(self.pixels.slice(from: stringNum, upTo: stringNum + intWidth).concat(frameSide))
                stringNum =  stringNum + intWidth
                i = i + 1
                log(line)
            }
            log(frameTopBottom)
        }
  }
}