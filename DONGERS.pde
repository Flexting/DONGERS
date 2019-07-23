
import java.io.File;

// Can Modify
float gridSize = 60;    // Size of the overlay grid
float minGridSize = 10;
float zoom = 1;    // Zoom level of the image

// Don't Modify
PImage inputImage;    // Image displayed on screen
PGraphics grid;    // Grid displayed over the top of the image
PVector imgPos = new PVector(0, 0);    // Image x/y position
PVector imgTempPos = new PVector(0, 0);    // Image temp x/y position used for drawing
PVector mouseDownPos, mouseUpPos;    // Track the location of the mouse being pressed and released
boolean shiftHeld = false;
boolean showGrid = true;

void setup() {
    size(600, 600);
    surface.setResizable(true);
    initialise();
}

void initialise() {
    //selectInput("Select an image", "imageChosen");  
    inputImage = loadImage(sketchPath() + "/Forest.png");
    
    scaleImageToScreen(inputImage);
    createGrid();
}

void draw() {
    background(200);
    translate(imgPos.x + imgTempPos.x, imgPos.y + imgTempPos.y);
    scale(zoom);
    if (inputImage != null) {
        image(inputImage, 0, 0);  
        //image(modifiedImage, 0, 0, 100, 100, 0, 0, 100, 100);    // Only draw what you can see
        /*
        image(img, dx, dy, dw, dh, sx, sy, sw, sh);

        where
        dx, dy, dw, dh   = the area of your display that you want to draw to.
        and
        sx, sy, sw, sh  = the part of the image to draw (measured in pixels) 
        */
        if (showGrid) {
            image(grid, 0, 0);
        }
    }
}

void imageChosen(File file) {
    if(file.exists()) {
        inputImage = loadImage(file.getAbsolutePath()); 
        scaleImageToScreen(inputImage);
    }
}

// Zooming the image / grid
void mouseWheel(MouseEvent event) {
    float count = event.getCount() * -1;
    boolean imageZoom = !shiftHeld;
    
    if (imageZoom) {
        zoom += count / 10.0;
        PVector mouseOffset = new PVector(mouseX, mouseY);
    } else {
        gridSize += 5 * count;
        gridSize = max(gridSize, minGridSize);
        createGrid();
    }
}

void mousePressed() {
    mouseDownPos = new PVector(mouseX, mouseY);
}

void mouseDragged() {
    PVector mouseCurrentPos = new PVector(mouseX, mouseY);
    imgTempPos = new PVector(mouseCurrentPos.x - mouseDownPos.x, mouseCurrentPos.y - mouseDownPos.y);
}

// Set the imgPos to the imgTempPos and reset the imgTempPos
void mouseReleased() {
    mouseUpPos = new PVector(mouseX, mouseY);
    imgPos = new PVector(imgPos.x + imgTempPos.x, imgPos.y + imgTempPos.y);
    imgTempPos = new PVector(0, 0);
}

void keyPressed() {
    switch (keyCode) {
        // Shift
        case 16: shiftHeld = true; break;
        // G
        case 71: showGrid = !showGrid; break;
    }
}

void keyReleased() {
    println("keyReleased: ", keyCode);
    switch (keyCode) {
        // Shift
        case 16: shiftHeld = false; break;
    }
}

void createGrid() {
    grid = createGraphics(inputImage.width, inputImage.height);
    grid.beginDraw();
    grid.stroke(0, 40);
    for (int j = 0; j < grid.height / gridSize; j++) {
        for (int i = 0; i < grid.width / gridSize; i++) {
            float x1 = gridSize * i;
            float y1 = gridSize * j;
            float x2 = inputImage.width - 1;
            float y2 = inputImage.height - 1;
            
            grid.line(x1, y1, x2, y1);
            grid.line(x1, y1, x1, y2);
        }
    }
    grid.endDraw();
}

void scaleImageToScreen(PImage input) {
    PImage img = input.copy();
    // This function needs to change to set the zoom value not resize the image
    inputImage = img;
}
