pub struct Canvas {

  pub let width: UInt8
  pub let height: UInt8
  pub let pixels: String

  init(width: UInt8, height: UInt8, pixels: String) {
    self.width = width
    self.height = height
    self.pixels = pixels
  }
}

pub fun serializeStringArray(_ lines: [String]): String {
  var buffer = ""
  for line in lines {
    buffer = buffer.concat(line)
  }

  return buffer
}

pub fun display(canvas: Canvas) {
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

pub resource Picture {
  pub let canvas: Canvas

  init(canvas: Canvas) {
    self.canvas = canvas
  }
}

pub resource Printer {
  pub fun print(canvas: Canvas): @Picture? {
    let pic <- create Picture(canvas: canvas)
    display(canvas: canvas)

    return <- pic 
  }
}

pub fun main() {
  let pixelsX = [
    "*   *",
    " * * ",
    "  *  ",
    " * * ",
    "*   *"
  ]
  let letterX = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray(pixelsX)
  )
  log("Quest 1 Output:")
  display(canvas: letterX)
  
  log("Quest 2 Output:")
  let picX <- create Picture(canvas: letterX)
  let printer <- create Printer()
  let printPicX <- printer.print(canvas: letterX)

  destroy  picX
  destroy printer
  destroy printPicX
}
 