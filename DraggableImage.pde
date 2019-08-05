
public class DraggableImage extends Image {
    PVector mouseDownPos;
    PVector draggedPos = new PVector();
    boolean dragging = false;
    
    public DraggableImage() {
        super();    
    }
    
    public DraggableImage(String imagePath) {
        this.img = loadImage(imagePath);
        this.pos = new PVector();
    }
    
    public void updatePos() {
        this.pos.add(draggedPos.x, draggedPos.y);
        this.draggedPos = new PVector();
    }
    
    public void setDragging(boolean value) {
        this.dragging = value;    
    }
    
    public void setDraggedPos(float x, float y) {
        this.draggedPos = new PVector(x, y);    
    }

    public void setDraggedPos(PVector pos) {
        this.draggedPos = pos;
    }
    
    public PVector getDraggedPos() {
        return this.draggedPos;
    }
    
    public void display() {
        display(draggedPos.x, draggedPos.y);
    }

    public void moveImage(int direction, int amount) {
        switch (direction) {
            case UP:    pos.y -= amount; break;
            case DOWN:  pos.y += amount; break;
            case LEFT:  pos.x -= amount; break;
            case RIGHT: pos.x += amount; break;
            //default: println("Invalid direction " + direction); break;
        }
    }
    
    /* Mouse functions */

    public final boolean mousePressed() {
        boolean hovering = isHovering();
        
        if (hovering) {
            mouseDownPos = new PVector(mouseX, mouseY);
            dragging = true;
        }
        
        return hovering;
    }

    public void mouseDragged() {
        if (dragging) {
            PVector draggedPos = new PVector(mouseX - mouseDownPos.x, mouseY - mouseDownPos.y); 
            setDraggedPos(draggedPos);
        }
    }

    public final void mouseReleased() {
        updatePos();
    }
}
