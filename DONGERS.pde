
import java.io.File;

// Can Modify
float zoom = 1;    // Zoom level of the image

// Don't Modify
Image inputImage;    // Image displayed on screen
Grid grid;

Menu menu;
GridMenu gridMenu;

PVector imgPos = new PVector(0, 0);    // Image x/y position
PVector imgTempPos = new PVector(0, 0);    // Image temp x/y position used for drawing

PVector mouseDownPos, mouseUpPos;    // Track the location of the mouse being pressed and released
PopupWindow selectedWindow = null;
boolean dragging = false;   // If the image is being dragged

boolean shiftHeld = false;

// Constants
private static final float MIN_ZOOM = 0.05;
private static final float MAX_ZOOM = 5.0;

public void setup() {
    size(600, 600);
    noSmooth();
    surface.setResizable(true);
    initialise();
}

private void initialise() {
    inputImage = new Image();
    grid = new Grid();

    //selectInput("Select an image", "imageChosen");  
    // ***** Remove these lines in final version
    inputImage.setImage(loadImage(sketchPath() + "/Forest.png"));
    grid.createGrid();
    // ***** Remove these lines in final version
    
    Menu menu = new Menu();
    menu.addItem(new LoadImageButton());
    menu.addItem(new ToggleGridButton());
    menu.addItem(new RotateImageRightButton());
    menu.addItem(new ResetButton());
    this.menu = menu;

    gridMenu = new GridMenu(grid);
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
    gridMenu.display();
    //text("FPS: " + (int)frameRate, 16, 16);
}

// Zooming the image / grid
public void mouseWheel(MouseEvent event) {
    float count = event.getCount() * -1;
    boolean imageZoom = !shiftHeld;

    if (imageZoom) {
        zoom(count / 10.0);
    } else {
        float size = grid.getSize() + 5 * count;
        grid.setSize(size);
    }
}

public void mousePressed() {
    mouseDownPos = new PVector(mouseX, mouseY);

    // Grid menu pressed
    if (gridMenu.mousePressed()) {
        selectedWindow = gridMenu;
    }
    // Main tool menu pressed
    else if (menu.mousePressed()) {
        selectedWindow = menu;
    }
    // The image pressed
    else {
        dragging = true;
    }
}

public void mouseDragged() {
    if (selectedWindow != null) {
        selectedWindow.mouseDragged();
        return;
    }
    if (dragging == false) return;

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
    if (selectedWindow != null) {
        selectedWindow.mouseReleased();
        selectedWindow = null;
        return;
    }
    if (dragging == false) return;

    imgPos = new PVector(imgPos.x + imgTempPos.x, imgPos.y + imgTempPos.y);
    imgTempPos = new PVector();

    grid.updateGridPosition(true);
    dragging = false;
}

public void keyPressed() {
    switch (keyCode) {
        // Shift
        case SHIFT: shiftHeld = true; break;
        // G
        case 71: toggleGrid(); break;
    }
    // 1-9
    if (keyCode >= 49 && keyCode <= 57) {
        float weight = (keyCode - 48); 
        grid.setWeight(weight);
    }
    // Direction arrow
    if (keyCode >= 37 && keyCode <= 40) {
        int amount = shiftHeld ? 50 : 10;
        moveImage(keyCode, amount);
    }
}

public void keyReleased() {
    //println("keyReleased: ", keyCode);
    switch (keyCode) {
        // Shift
        case SHIFT: shiftHeld = false; break;
    }
}

public void zoom(float amount) {
    float newZoom = zoom + amount;

    // Constrain to max/min zooms
    if (newZoom < MIN_ZOOM || newZoom > MAX_ZOOM) return;

    // Where the cursor is in relation to the centre
    PVector pos = new PVector(mouseX - width/2, mouseY - height/2);
    // Zoom ratio
    float scale = newZoom / zoom;
    // Difference between zoomed position and the zoomed scaled position
    float mult = 1 - scale;
    PVector deltaPos = new PVector(pos.x * mult, pos.y * mult);

    // Apply the scale and shift by the delta
    imgPos.x = imgPos.x * scale + deltaPos.x;
    imgPos.y = imgPos.y * scale + deltaPos.y;

    zoom = newZoom;
}

public void moveImage(int direction, int amount) {
    switch (direction) {
        case UP:    imgPos.y -= amount; break;
        case DOWN:  imgPos.y += amount; break;
        case LEFT:  imgPos.x -= amount; break;
        case RIGHT: imgPos.x += amount; break;
        //default: println("Invalid direction " + direction); break;
    }
}

private void scaleImageToScreen() {
    if (inputImage == null) return;

    float xRatio = width / (float) inputImage.img.width;
    float yRatio = height / (float) inputImage.img.height;
    zoom = (xRatio < yRatio) ? xRatio : yRatio;
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
