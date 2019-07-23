
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
PVector gridPos = new PVector(0, 0);    // Grid x/y position
PVector gridTempPos = new PVector(0, 0);    // Grid temp x/y position used for dragging

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
    PVector imgOffset = new PVector(imgPos.x + imgTempPos.x, imgPos.y + imgTempPos.y);
    background(200);
    translate(imgOffset.x, imgOffset.y);
    scale(zoom);
    
    if (inputImage != null) {
        // ***** After checking remove code from here
        float dx = (imgOffset.x < 0) ? (-imgOffset.x + 5) : 5,
              dy = (imgOffset.y < 0) ? (-imgOffset.y + 5) : 5,
              dw = (imgOffset.x < 0) ? max(0, min(inputImage.width + imgOffset.x, width - 10)) : max(0, (width - imgOffset.x - 10)),
              dh = (imgOffset.y < 0) ? max(0, min(inputImage.height + imgOffset.y, height - 10)) : max(0, (height - imgOffset.y - 10));
        int   sx1 = (imgOffset.x < 0) ? ((int) -imgOffset.x) : 0,
              sy1 = (imgOffset.y < 0) ? ((int) -imgOffset.y) : 0,
              sx2 = sx1 + (int) dw,
              sy2 = sy1 + (int) dh;
        println("dxy: ", dx, dy);
        println("dwh: ", dw, dh);
        println("sxy1: ", sx1, sy1);
        println("sxy2: ", sx2, sy2);
        println("zoom: ", zoom);
        // ***** To here and replace it with the commented out code below
              
        /* This one doesnt have the border
        // dx, dy, dw, dh = the area of your display that you want to draw to.
        // sx, sy, sw, sh = the part of the image to draw (measured in pixels) 
        float dx = (imgOffset.x < 0) ? (-imgOffset.x) : 0,    // Draw image at x coord
              dy = (imgOffset.y < 0) ? (-imgOffset.y) : 0,    // Draw image at y coord
              dw = (imgOffset.x < 0) ? max(0, min(inputImage.width + imgOffset.x, width)) : max(0, (width - imgOffset.x)),    // Draw image with width
              dh = (imgOffset.y < 0) ? max(0, min(inputImage.height + imgOffset.y, height)) : max(0, (height - imgOffset.y));    // Draw image with height
        int   sx1 = (imgOffset.x < 0) ? ((int) -imgOffset.x) : 0,    // Use image region x1
              sy1 = (imgOffset.y < 0) ? ((int) -imgOffset.y) : 0,    // Use image region y1
              sx2 = sx1 + (int) dw,    // Use image region x2
              sy2 = sy1 + (int) dh;    // Use image region y2
        */
        // Update the values to work with the zoom level
        dx /= zoom;
        dy /= zoom;
        dw /= zoom;
        dh /= zoom;
        sx1 /= zoom;
        sy1 /= zoom;
        sx2 /= zoom;
        sy2 /= zoom;
        
        if (sx1 < inputImage.width && sy1 < inputImage.height && sx2 > 0 && sy2 > 0) {
            println("drawing map - remove after pull request");
            image(inputImage, dx, dy, dw, dh, sx1, sy1, sx2, sy2);
        } else {
            println("not drawing map - remove after pull request");
        }
        
        if (showGrid) {
            translate(gridTempPos.x, gridTempPos.y);
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
    boolean dragGrid = shiftHeld;
    PVector mouseCurrentPos = new PVector(mouseX, mouseY),
            tempPos = new PVector(mouseCurrentPos.x - mouseDownPos.x, mouseCurrentPos.y - mouseDownPos.y); 
    
    if (dragGrid) {    
        gridTempPos = tempPos;
    } else {    
        imgTempPos = tempPos;
    }
}

// Set the imgPos to the imgTempPos and reset the imgTempPos
void mouseReleased() {
    mouseUpPos = new PVector(mouseX, mouseY);
    imgPos = new PVector(imgPos.x + imgTempPos.x, imgPos.y + imgTempPos.y);
    imgTempPos = new PVector(0, 0);
    
    gridPos = new PVector((gridSize + gridPos.x + gridTempPos.x) % gridSize, (gridSize + gridPos.y + gridTempPos.y) % gridSize);
    gridTempPos = new PVector(0, 0);
    createGrid();
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
    for (int j = -1; j < grid.height / gridSize; j++) {
        for (int i = -1; i < grid.width / gridSize; i++) {
            float x1 = gridSize * i + gridPos.x;
            float y1 = gridSize * j + gridPos.y;
            float x2 = inputImage.width - 1 + gridPos.x;
            float y2 = inputImage.height - 1 + gridPos.y;
            
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
