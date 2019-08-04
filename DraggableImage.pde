
public class DraggableImage extends Image {
    PVector mouseDownPos;
    PVector draggedPos = new PVector();
    boolean dragging = false;
    
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
    
    public void display() {
        if (img == null) return;

        PVector center = new PVector(width/2, height/2);
        PVector imgCenter = new PVector(img.width/2, img.height/2);

        float x = pos.x + draggedPos.x,    // Image pos with drawing offset
              y = pos.y + draggedPos.y,    // Image pos with drawing offset
              dx = center.x / zoom,    // Draw image at x coord
              dy = center.y / zoom,    // Draw image at y coord
              dw = width / zoom,     // Draw image with width
              dh = height / zoom;    // Draw image with height
        int   sx1 = (int) (imgCenter.x - dx - x / zoom),    // Use image region x1
              sy1 = (int) (imgCenter.y - dy - y / zoom),    // Use image region y1
              sx2 = sx1 + (int) dw,    // Use image region x2
              sy2 = sy1 + (int) dh;    // Use image region y2
              
        pushMatrix();
        scale(zoom);
        imageMode(CENTER);
        image(img, dx, dy, dw, dh, sx1, sy1, sx2, sy2);
        popMatrix();
    }
}
