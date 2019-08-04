
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
        this.pos = new PVector(pos.x + draggedPos.x, pos.y + draggedPos.y);
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
    
    public final boolean isHovering() {
        PVector center = new PVector(width/2, height/2);
        PVector imgPos = new PVector(pos.x + draggedPos.x, pos.y + draggedPos.y);
        PVector mousePos = new PVector(mouseX - center.x, mouseY - center.y);
        float imgWidth = img.width * zoom;
        float imgHeight = img.height * zoom;
        
        return (mousePos.x > imgPos.x - imgWidth/2.0 && mousePos.x < imgPos.x + imgWidth/2.0)
            && (mousePos.y > imgPos.y - imgHeight/2.0 && mousePos.y < imgPos.y + imgHeight/2.0);
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
        if (!dragging) return;
        PVector mouseCurrentPos = new PVector(mouseX, mouseY),
            tempPos = new PVector(mouseCurrentPos.x - mouseDownPos.x, mouseCurrentPos.y - mouseDownPos.y); 
            
        setDraggedPos(tempPos);
    }

    public final void mouseReleased() {
        updatePos();
    }
}
