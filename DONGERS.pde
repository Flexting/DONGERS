
import java.io.File;

// Can Modify
float zoom = 1;    // Zoom level of the image

// Don't Modify
DraggableImage inputImage;    // Image displayed on screen
DraggableImage selectedDraggableImage;
ArrayList<DraggableImage> characters;
Grid grid;

Menu menu;
GridMenu gridMenu;

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
    inputImage = new DraggableImage();
    grid = new Grid();
    characters = new ArrayList<DraggableImage>();
    characters.add(new DraggableImage(sketchPath() + "/images/playerIcons/Scott.jpg"));

    //selectInput("Select an image", "imageChosen");  
    // ***** Remove these lines in final version
    inputImage.setImage(loadImage(sketchPath() + "/Forest.png"));
    grid.createGrid();
    // ***** Remove these lines in final version
    
    Menu menu = new Menu();
    menu.addItem(new LoadImageButton());
    menu.addItem(new ToggleGridButton());
    menu.addItem(new GridMenuButton());
    menu.addItem(new RotateImageRightButton());
    menu.addItem(new ResetButton());
    this.menu = menu;

    gridMenu = new GridMenu(grid);
}

public void draw() {
    background(200);
    PVector imgPos = inputImage.getPos();
    PVector imgDraggedPos = inputImage.getDraggedPos();
    PVector imgOffset = new PVector(imgPos.x + imgDraggedPos.x, imgPos.y + imgDraggedPos.y);

    if (inputImage != null) {
        inputImage.display();
        
        grid.display(imgOffset.x, imgOffset.y);
        
        for (DraggableImage character : characters) {
            character.display();
        }
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
    else {
        // Character pressed
        selectedDraggableImage = null;
        for (DraggableImage character : characters) {
            if (character.mousePressed()) {
                selectedDraggableImage = character;
                break;
            }
        }
        
        // The image pressed
        if (selectedDraggableImage == null) {
            dragging = true;
        }
    }
}

public void mouseDragged() {
    if (selectedWindow != null) {
        selectedWindow.mouseDragged();
        return;
    }
    
    if (selectedDraggableImage != null) {
        selectedDraggableImage.mouseDragged();
        return;
    }
    
    if (dragging == false) return;

    boolean dragGrid = shiftHeld;
    PVector mouseCurrentPos = new PVector(mouseX, mouseY),
            tempPos = new PVector(mouseCurrentPos.x - mouseDownPos.x, mouseCurrentPos.y - mouseDownPos.y); 

    if (dragGrid) {    
        grid.setTempPos(tempPos);
    } else {    
        inputImage.setDraggedPos(tempPos);
        for (DraggableImage character : characters) {
            character.setDraggedPos(tempPos);
        }
    }
}

// Set the imgPos to the imgTempPos and reset the imgTempPos
public void mouseReleased() {
    if (selectedWindow != null) {
        selectedWindow.mouseReleased();
        selectedWindow = null;
        return;
    }
    if (selectedDraggableImage != null) {
        selectedDraggableImage.mouseReleased();
        selectedDraggableImage = null;
        return;
    }
    if (dragging == false) return;

    inputImage.updatePos();
    for (DraggableImage character : characters) {
        character.updatePos();
    }
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
    PVector imgPos = inputImage.getPos();
    imgPos.x = imgPos.x * scale + deltaPos.x;
    imgPos.y = imgPos.y * scale + deltaPos.y;
    
    for (DraggableImage character : characters) {
        PVector characterPos = character.getPos();
        characterPos.x = characterPos.x * scale + deltaPos.x;
        characterPos.y = characterPos.y * scale + deltaPos.y;
    }
    zoom = newZoom;
}

public void moveImage(int direction, int amount) {
    PVector imgPos = inputImage.getPos();
    switch (direction) {
        case UP:    imgPos.y -= amount; break;
        case DOWN:  imgPos.y += amount; break;
        case LEFT:  imgPos.x -= amount; break;
        case RIGHT: imgPos.x += amount; break;
        //default: println("Invalid direction " + direction); break;
    }
    inputImage.setPos(imgPos);
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
        resetImage();
        grid.createGrid();
    }
}

public void toggleGrid() {
    grid.toggle();
}

public void showGridMenu() {
    gridMenu.show();
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
    inputImage.setPos(0, 0);
    scaleImageToScreen();
}
