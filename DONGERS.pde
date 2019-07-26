
import java.io.File;

// Can Modify
float gridSize = 60;    // Size of the overlay grid
float minGridSize = 10;
float zoom = 1;    // Zoom level of the image

// Don't Modify
Menu menu;
PImage inputImage;    // Image displayed on screen
PGraphics grid;    // Grid displayed over the top of the image

PVector imgPos = new PVector(0, 0);    // Image x/y position
PVector imgTempPos = new PVector(0, 0);    // Image temp x/y position used for drawing
PVector gridPos = new PVector(0, 0);    // Grid x/y position
PVector gridTempPos = new PVector(0, 0);    // Grid temp x/y position used for dragging

PVector mouseDownPos, mouseUpPos;    // Track the location of the mouse being pressed and released
boolean shiftHeld = false;
boolean showGrid = true;

public void setup() {
    size(600, 600);
    surface.setResizable(true);
    initialise();
}

private void initialise() {
    //selectInput("Select an image", "imageChosen");  
    // ***** Remove these lines in final version
    inputImage = loadImage(sketchPath() + "/Forest.png");
    createGrid();
    // ***** Remove these lines in final version

    menu = new Menu();
    menu.addItem(new LoadImageButton());
    menu.addItem(new ToggleGridButton());
    menu.addItem(new RotateImageRightButton());
    menu.addItem(new ResetButton());
}

public void draw() {
    PVector imgOffset = new PVector(imgPos.x + imgTempPos.x, imgPos.y + imgTempPos.y);
    background(200);

    if (inputImage != null) {
        float dx = (imgOffset.x < 0) ? (-imgOffset.x) : 0,    // Draw image at x coord
              dy = (imgOffset.y < 0) ? (-imgOffset.y) : 0,    // Draw image at y coord
              dw = (imgOffset.x < 0) ? max(0, min(inputImage.width + imgOffset.x, width)) : max(0, (width - imgOffset.x)),    // Draw image with width
              dh = (imgOffset.y < 0) ? max(0, min(inputImage.height + imgOffset.y, height)) : max(0, (height - imgOffset.y));    // Draw image with height
        int   sx1 = (imgOffset.x < 0) ? ((int) -imgOffset.x) : 0,    // Use image region x1
              sy1 = (imgOffset.y < 0) ? ((int) -imgOffset.y) : 0,    // Use image region y1
              sx2 = sx1 + (int) dw,    // Use image region x2
              sy2 = sy1 + (int) dh;    // Use image region y2

        // Update the values to work with the zoom level
        dx /= zoom;
        dy /= zoom;
        dw /= zoom;
        dh /= zoom;
        sx1 /= zoom;
        sy1 /= zoom;
        sx2 /= zoom;
        sy2 /= zoom;

        pushMatrix();
        if (sx1 < inputImage.width && sy1 < inputImage.height && sx2 > 0 && sy2 > 0) {
            translate(imgOffset.x, imgOffset.y);
            scale(zoom);
            imageMode(CORNER);
            image(inputImage, dx, dy, dw, dh, sx1, sy1, sx2, sy2);
        }

        if (showGrid) {
            translate(gridTempPos.x, gridTempPos.y);
            image(grid, 0, 0);
        }
        popMatrix();
    }

    menu.display();
}

// Zooming the image / grid
public void mouseWheel(MouseEvent event) {
    float count = event.getCount() * -1;
    boolean imageZoom = !shiftHeld;

    if (imageZoom) {
        zoom += count / 10.0;
    } else {
        float size = gridSize + 5 * count;
        size  = max(size, minGridSize);
        // Don't recreate the grid for the same size
        if (size != gridSize) {
            gridSize = size;
            createGrid();
        }
    }
}

public void mousePressed() {
    boolean itemPressed = menu.mousePressed();
    if (itemPressed) {
        mouseDownPos = null;
    } else {
        mouseDownPos = new PVector(mouseX, mouseY);
    }
}

public void mouseDragged() {
    if (mouseDownPos == null) return;

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
public void mouseReleased() {
    if (mouseDownPos == null) return;

    mouseUpPos = new PVector(mouseX, mouseY);
    imgPos = new PVector(imgPos.x + imgTempPos.x, imgPos.y + imgTempPos.y);
    imgTempPos = new PVector(0, 0);
    gridPos = new PVector((gridSize + gridPos.x + gridTempPos.x) % gridSize, (gridSize + gridPos.y + gridTempPos.y) % gridSize);
    gridTempPos = new PVector(0, 0);    
}

public void keyPressed() {
    switch (keyCode) {
        // Shift
        case 16: shiftHeld = true; break;
        // G
        case 71: toggleGrid(); break;
    }
}

public void keyReleased() {
    //println("keyReleased: ", keyCode);
    switch (keyCode) {
        // Shift
        case 16: shiftHeld = false; break;
    }
}

private void createGrid() {
    if (gridSize == minGridSize) return;

    grid = createGraphics(inputImage.width, inputImage.height);
    grid.beginDraw();
    grid.strokeWeight(2);
    grid.stroke(0, 255);
    for (int i = 0; i <= grid.width / gridSize; ++i) {
        float x = gridSize * i + gridPos.x;
        grid.line(x, 0, x, inputImage.height);
    }
    for (int i = 0; i <= grid.height / gridSize; ++i) {
        float y = gridSize * i + gridPos.y;
        grid.line(0, y, inputImage.width, y);
    }
    grid.endDraw();
}

private void scaleImageToScreen() {
    if (inputImage == null) return;
    float ratio;
    if (inputImage.width < inputImage.height) {
        ratio = width / (float) inputImage.width;
    } else {
        ratio = height / (float) inputImage.height;
    }
    zoom = ratio;
}

public void imageChosen(File file) {
    if (file != null && file.exists()) {
        inputImage = loadImage(file.getAbsolutePath()); 
        scaleImageToScreen();
        createGrid();
    }
}

public void toggleGrid() {
    showGrid = !showGrid;
}

public void rotateImageRight() {
    PImage img = new PImage(inputImage.height, inputImage.width);

    img.loadPixels();
    for (int x = 0; x < inputImage.width; ++x) {
        for (int y = 0; y < inputImage.height; ++y) {
            img.pixels[(img.width - 1 - y) + x * img.width] = inputImage.pixels[x + y * inputImage.width];
        }
    }
    img.updatePixels();
    inputImage = img.copy();
    createGrid();
}

public void resetImage() {
    zoom = 1;
    imgPos = new PVector(0, 0);
    scaleImageToScreen();
}
