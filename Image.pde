
public class Image {
    PImage img;
    PVector pos;
    
    public Image() {
        this.img = null;
        this.pos = new PVector();
    }
    
    public void setImage(String path) {
        PImage img = loadImage(path); 
        this.setImage(img);
    }
    
    public void setImage(PImage img) {
        this.img = img.copy();
    }
    
    public void setPos(float x, float y) {
        this.pos = new PVector(x, y);    
    }

    public void setPos(PVector pos) {
        this.pos = pos;
    }

    public PVector getPos() {
        return this.pos;
    }
    
    public void display() {
        display(0, 0);    
    }
    
    public void display(float offsetX, float offsetY) {
        if (img == null) return;

        PVector center = new PVector(width/2, height/2);
        PVector imgCenter = new PVector(img.width/2, img.height/2);

        float x = pos.x + offsetX,    // Image pos with drawing offset
              y = pos.y + offsetY,    // Image pos with drawing offset
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
    
    public final boolean isHovering() {
        PVector center = new PVector(width/2, height/2);
        PVector mousePos = new PVector(mouseX - center.x, mouseY - center.y);
        float imgWidth = img.width * zoom;
        float imgHeight = img.height * zoom;
        
        return (mousePos.x > pos.x - imgWidth/2.0 && mousePos.x < pos.x + imgWidth/2.0)
            && (mousePos.y > pos.y - imgHeight/2.0 && mousePos.y < pos.y + imgHeight/2.0);
    }
}
