
import java.io.File;
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.UIManager;

JFileChooser jfc;

// Can Modify
float zoom = 1;    // Zoom level of the image

// Don't Modify
DraggableImage inputImage;    // Image displayed on screen
Entity selectedEntity;
ArrayList<Entity> characters;
ArrayList<Thumbnail> mapThumbnails;
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
    initialiseFileChooser();
    
    inputImage = new DraggableImage();
    grid = new Grid();
    characters = new ArrayList<Entity>();
    mapThumbnails = new ArrayList<Thumbnail>();
        
    //chooseImage();
    // ***** Remove these lines in final version
    characters.add(new Entity(new DraggableImage(sketchPath() + "/data/images/playerIcons/Scott.jpg")));
    inputImage.setImage(loadImage(sketchPath() + "/data/Forest.png"));
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

public void initialiseFileChooser() {
    try {
        UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    } catch (Exception e) {}
    jfc = new JFileChooser(sketchPath());
    jfc.setAcceptAllFileFilterUsed(false);
    FileNameExtensionFilter filter = new FileNameExtensionFilter("PNG and JPG images", "png", "jpg", "jpeg", "gif");
    jfc.addChoosableFileFilter(filter);
    jfc.setMultiSelectionEnabled(true);
}

public void draw() {
    background(200);
    PVector imgPos = inputImage.getPos();
    PVector imgDraggedPos = inputImage.getDraggedPos();
    PVector imgOffset = new PVector(imgPos.x + imgDraggedPos.x, imgPos.y + imgDraggedPos.y);

    if (inputImage != null) {
        inputImage.display();
        
        grid.display(imgOffset.x, imgOffset.y);
        
        for (Entity character : characters) {
            character.display(imgOffset.x, imgOffset.y);
        }
        
        final int mapThumbnailSize = mapThumbnails.size();
        for (int i = 0; i < mapThumbnailSize && mapThumbnailSize > 1; i++) {
            Thumbnail mapThumbnail = mapThumbnails.get(i);
            boolean isHovered = mapThumbnail.isHovered();
            float thumbnailSize = mapThumbnail.imageSize;
            float spacing = 10;
            float x = (isHovered) ? thumbnailSize/2 : 0;
            float y = (thumbnailSize + spacing) * i;
            y += height/2.0 - (thumbnailSize + spacing) * mapThumbnailSize/2 + thumbnailSize/2 + spacing/2;
            mapThumbnail.display(x, y);
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
        zoomGrid(count);
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
    // Map thumnail image pressed
        Thumbnail thumbnail = mapThumbnailPressed();
        if (thumbnail != null) {
            inputImage.setImage(thumbnail.originalImage); 
            resetImage();
            grid.createGrid();
            return;
        }
        // Character pressed
        selectedEntity = null;
        for (Entity character : characters) {
            if (character.mousePressed()) {
                selectedEntity = character;
                break;
            }
        }
        
        // The image pressed
        if (selectedEntity == null) {
            dragging = true;
        }
    }
}

public void mouseDragged() {
    if (selectedWindow != null) {
        selectedWindow.mouseDragged();
        return;
    }
    
    if (selectedEntity != null) {
        selectedEntity.mouseDragged();
        return;
    }
    
    if (dragging == false) return;

    boolean dragGrid = shiftHeld;
    PVector mouseCurrentPos = new PVector(mouseX, mouseY),
            tempPos = new PVector(mouseCurrentPos.x - mouseDownPos.x, mouseCurrentPos.y - mouseDownPos.y); 

    if (dragGrid) {    
        grid.setDraggedPos(tempPos);
    } else {    
        inputImage.setDraggedPos(tempPos);
    }
}

// Set the imgPos to the imgTempPos and reset the imgTempPos
public void mouseReleased() {
    if (selectedWindow != null) {
        selectedWindow.mouseReleased();
        selectedWindow = null;
        return;
    }
    if (selectedEntity != null) {
        selectedEntity.mouseReleased();
        selectedEntity = null;
        return;
    }
    if (dragging == false) return;

    inputImage.updatePos();
    grid.updateGridPosition(true);
    dragging = false;
}

public void keyPressed() {
    switch (keyCode) {
        // Shift: For scrolling grid size
        case SHIFT: shiftHeld = true; break;
        // G: Toggle grid visibility
        case 71: toggleGrid(); break;
        // R: Reset board
        case 82: resetImage(); break;
        // Plus: Enlarge grid
        case 61: case 107: zoomGrid(1); break;
        // Minus: Shrink grid
        case 45: case 109: zoomGrid(-1); break;
        // [: Rotate anti-clockwise 90
        case 91: rotateImageLeft(); break;
        // ]: Rotate clockwise 90
        case 93: rotateImageRight(); break;
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
    
    zoom = newZoom;
}

public void zoomGrid(float amount) {
    float size = grid.getSize() + 5 * amount;
    grid.setSize(size);
}

public void moveImage(int direction, int amount) {
    inputImage.moveImage(direction, amount);
}

private void scaleImageToScreen() {
    if (inputImage.img == null) return;

    float xRatio = width / (float) inputImage.img.width;
    float yRatio = height / (float) inputImage.img.height;
    zoom = (xRatio < yRatio) ? xRatio : yRatio;
}

public void chooseImage() {
    int returnValue = jfc.showOpenDialog(null);
    if (returnValue == JFileChooser.APPROVE_OPTION) {
        File[] selectedFiles = jfc.getSelectedFiles();
        imagesChosen(selectedFiles);
    }    
}

public void imagesChosen(File[] files) {
    for (int i = 0; i < files.length; i++) {
        File file = files[i];
        if (file != null && file.exists()) {
            PImage img = loadImage(file.getAbsolutePath());
            if (i == 0) {
                inputImage.setImage(img); 
                resetImage();
                grid.createGrid();
            }
            mapThumbnails.add(new Thumbnail(img));
        }
    }
}

public void toggleGrid() {
    grid.toggle();
}

public void showGridMenu() {
    gridMenu.show();
}

public void rotateImageLeft() { rotateImage(false); }
public void rotateImageRight() { rotateImage(true); }
public void rotateImage(boolean right) {
    if (inputImage.img == null) return;

    PImage img = new PImage(inputImage.img.height, inputImage.img.width);

    img.loadPixels();
    for (int x = 0; x < inputImage.img.width; ++x) {
        for (int y = 0; y < inputImage.img.height; ++y) {
            if (right) {
                img.pixels[(img.width - 1 - y) + x * img.width] = inputImage.img.pixels[x + y * inputImage.img.width];
            } else {
                img.pixels[y + x * img.width] = inputImage.img.pixels[(inputImage.img.width - 1 - x) + y * inputImage.img.width];
            }
        }
    }
    img.updatePixels();
    inputImage.setImage(img.copy());
    grid.createGrid();

    // Move character heads given the origin of the image
    for (Entity character : characters) {
        character.rotate(right);
    }
}

public void resetImage() {
    scaleImageToScreen();
    inputImage.setPos(0, 0);
    for (Entity character : characters) {
        character.resetPos();
    }
}

public Thumbnail mapThumbnailPressed() {
    for (Thumbnail thumbnail : mapThumbnails) {
        if (thumbnail.mousePressed()) {
            return thumbnail;    
        }
    }
    return null;
}
