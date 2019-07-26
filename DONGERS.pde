
import java.io.File;

// Can Modify
float gridSize = 60;    // Size of the overlay grid
float minGridSize = 10;
float zoom = 1;    // Zoom level of the image

// Don't Modify
Menu menu;
Image inputImage;    // Image displayed on screen
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
    inputImage = new Image();
    //selectInput("Select an image", "imageChosen");  
    // ***** Remove these lines in final version
    inputImage.setImage(loadImage(sketchPath() + "/Forest.png"));
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
        inputImage.setPos(imgOffset.x, imgOffset.y);
        inputImage.display();
        
        if (showGrid) {
            pushMatrix();
            scale(zoom);
            image(grid, (imgOffset.x + gridTempPos.x) / zoom, (imgOffset.y + gridTempPos.y) / zoom);
            popMatrix();
        }
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
    if (gridTempPos.x != 0 && gridTempPos.y != 0) {
        gridTempPos = new PVector(0, 0);    
        createGrid();
    } 
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

    grid = createGraphics(inputImage.img.width, inputImage.img.height);
    grid.beginDraw();
    grid.strokeWeight(2);
    grid.stroke(0, 255);
    for (int i = 0; i <= grid.width / gridSize; ++i) {
        float x = gridSize * i + gridPos.x;
        grid.line(x, 0, x, inputImage.img.height);
    }
    for (int i = 0; i <= grid.height / gridSize; ++i) {
        float y = gridSize * i + gridPos.y;
        grid.line(0, y, inputImage.img.width, y);
    }
    grid.endDraw();
}

private void scaleImageToScreen() {
    if (inputImage == null) return;
    float ratio;
    if (inputImage.img.width < inputImage.img.height) {
        ratio = width / (float) inputImage.img.width;
    } else {
        ratio = height / (float) inputImage.img.height;
    }
    zoom = ratio;
}

public void imageChosen(File file) {
    if (file != null && file.exists()) {
        inputImage.setImage(loadImage(file.getAbsolutePath())); 
        scaleImageToScreen();
        createGrid();
    }
}

public void toggleGrid() {
    showGrid = !showGrid;
}

public void rotateImageRight() {
    PImage img = new PImage(inputImage.img.height, inputImage.img.width);

    img.loadPixels();
    for (int x = 0; x < inputImage.img.width; ++x) {
        for (int y = 0; y < inputImage.img.height; ++y) {
            img.pixels[(img.width - 1 - y) + x * img.width] = inputImage.img.pixels[x + y * inputImage.img.width];
        }
    }
    img.updatePixels();
    inputImage.setImage(img.copy());
    createGrid();
}

public void resetImage() {
    zoom = 1;
    imgPos = new PVector(0, 0);
    scaleImageToScreen();
}
