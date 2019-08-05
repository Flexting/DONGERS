
public class Entity {

    private Image image;

    private PVector pos;
    private PVector draggedPos;
    private PVector mouseDownPos;
    private boolean dragging = false;

    public Entity(Image image) {
        this.image = image;
        this.pos = new PVector();
        this.draggedPos = new PVector();
    }

    public void display(float x, float y) {
        image.setPos(x + draggedPos.x + pos.x * zoom, y + draggedPos.y + pos.y * zoom);
        image.display();
    }

    public void setDraggedPos(PVector pos) {
        this.draggedPos = pos;
    }

    public void updatePos() {
        pos.add(draggedPos.x / zoom, draggedPos.y / zoom);
        draggedPos.set(0, 0);
    }

    public void resetPos() {
        pos.set(0, 0);
    }

    public void rotateRight() {
        float x = pos.x;
        float y = pos.y;
        pos.set(-y, x);
    }

    /* Mouse functions */

    public final boolean mousePressed() {
        boolean hovering = image.isHovering();
        
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