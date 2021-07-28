pub contract Artist {
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

    pub resource Picture {

        pub let canvas: Canvas
        
        init(canvas: Canvas) {
            self.canvas = canvas
        }
    }

    pub resource Collection {
        //once a picture successfully prints it should get moved from the printer to the collection
        //unlike the printer resource where there's only one, we want each account to have their own collection
        //we need to be able to deposit pictures into a collection, no need to withdraw
        pub let pictures: @[Picture]

pub fun deposit(picture: @Picture) {
            return self.pictures.append(<- picture)
        }
        init() {
            self.pictures <- []
        }

        destroy() {
            destroy self.pictures
        }
    }

    // creates a new empty Collection resource and returns it 
    pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    pub resource Printer {

        pub let width: UInt8
        pub let height: UInt8
        pub let prints: {String: Canvas}

        init(width: UInt8, height: UInt8) {
            self.width = width;
            self.height = height;
            self.prints = {}
        }
        pub fun print(canvas: Canvas): @Picture? {
            // Canvas needs to fit Printer's dimensions.
            if canvas.pixels.length != Int(self.width * self.height) {
                return nil
            }

            // Canvas can only use visible ASCII characters.
            for symbol in canvas.pixels.utf8 {
                if symbol < 32 || symbol > 126 {
                    return nil
                }
            }

            // Printer is only allowed to print unique canvases.
            if self.prints.containsKey(canvas.pixels) == false {
                let picture <- create Picture(canvas: canvas)
                self.prints[canvas.pixels] = canvas

                return <- picture
            } else {
                return nil
            }
        }
    }
    init() {
        self.account.save(<- create Printer(width: 5, height: 5), to: /storage/ArtistPicturePrinter)
        self.account.link<&Printer>(/public/ArtistPicturePrinterCapability, target: /storage/ArtistPicturePrinter)
        
        self.account.save(<- self.createEmptyCollection(), to: /storage/Collection)
        self.account.link<&Collection>(/public/CollectionCapability, target: /storage/Collection)
    }
}