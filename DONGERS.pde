
import java.io.File;

// Can Modify
float zoom = 1;    // Zoom level of the image

// Don't Modify
Menu menu;
Image inputImage;    // Image displayed on screen
Grid grid;

PVector imgPos = new PVector(0, 0);    // Image x/y position
PVector imgTempPos = new PVector(0, 0);    // Image temp x/y position used for drawing

PVector mouseDownPos, mouseUpPos;    // Track the location of the mouse being pressed and released
boolean shiftHeld = false;

public void setup() {
    size(600, 600);
    noSmooth();
    surface.setResizable(true);
    initialise();
}

private void initialise() {
    inputImage = new Image();
    //selectInput("Select an image", "imageChosen");  
    // ***** Remove these lines in final version
    inputImage.setImage(loadImage(sketchPath() + "/Forest.png"));
    // ***** Remove these lines in final version
    grid = new Grid();
    
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
        
        grid.display(imgOffset.x, imgOffset.y);
    }

    menu.display();
    //text("FPS: " + (int)frameRate, 16, 16);
}

// Zooming the image / grid
public void mouseWheel(MouseEvent event) {
    float count = event.getCount() * -1;
    boolean imageZoom = !shiftHeld;

    if (imageZoom) {
        zoom += count / 10.0;
    } else {
        float size = grid.getSize() + 5 * count;
        grid.setSize(size);
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
        grid.setTempPos(tempPos);
    } else {    
        imgTempPos = tempPos;
    }
}

// Set the imgPos to the imgTempPos and reset the imgTempPos
public void mouseReleased() {
    if (mouseDownPos == null) return;

    imgPos = new PVector(imgPos.x + imgTempPos.x, imgPos.y + imgTempPos.y);
    imgTempPos = new PVector();

    if (grid.updateGridPosition()) {
        grid.createGrid();
    }
}

public void keyPressed() {
    switch (keyCode) {
        // Shift
        case 16: shiftHeld = true; break;
        // G
        case 71: toggleGrid(); break;
    }
    if (keyCode >= 49 && keyCode <= 57) {
        float weight = (keyCode - 48) / 2.0 + 0.5; 
        grid.setWeight(weight);
    }
}

public void keyReleased() {
    //println("keyReleased: ", keyCode);
    switch (keyCode) {
        // Shift
        case 16: shiftHeld = false; break;
    }
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
        grid.createGrid();
    }
}

public void toggleGrid() {
    grid.toggle();
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
    grid.createGrid();
}

public void resetImage() {
    zoom = 1;
    imgPos = new PVector(0, 0);
    scaleImageToScreen();
}
