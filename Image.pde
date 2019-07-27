
public class Image {
    PImage img;
    PGraphics graphic;
    PVector pos;
    
    public Image() {
        this.img = null;
        this.pos = new PVector(0, 0);
    }
    
    public void setImage(String path) {
        PImage img = loadImage(path); 
        this.setImage(img);
    }
    
    public void setImage(PImage img) {
        this.img = img.copy();
    }
    
    public void setGraphic(PGraphics graphic) {
        this.graphic = graphic;    
    }
    
    public void setPos(float x, float y) {
        this.pos = new PVector(x, y);    
    }
    
    public void display() {
        float dx = 0,    // Draw image at x coord
              dy = 0,    // Draw image at y coord
              dw = width / zoom,    // Draw image with width
              dh = height / zoom;    // Draw image with height
        int   sx1 = (int) (-pos.x / zoom),    // Use image region x1
              sy1 = (int) (-pos.y / zoom),    // Use image region y1
              sx2 = sx1 + (int) dw,    // Use image region x2
              sy2 = sy1 + (int) dh;    // Use image region y2
              
        pushMatrix();
        scale(zoom);
        imageMode(CORNER);
        if (img != null) {
            image(img, dx, dy, dw, dh, sx1, sy1, sx2, sy2);
        } else if (graphic != null) {
            image(graphic, dx, dy, dw, dh, sx1, sy1, sx2, sy2);
        }
        popMatrix();
    }
}
