
public abstract class MenuItem {
    static final int size = 32;
    String buttonName;
    PImage img;
    PGraphics maskImg;
    PVector pos = null;
    boolean hovered = false;
    
    public MenuItem(String imgPath) {
        img = loadImage(sketchPath() + "/images/" + imgPath);
    }
    
    public void display() {
        isHovered();
        if (hovered) {
            stroke(0);
            fill(0);
            rect(pos.x - size/2.0, pos.y - size/2.0, size, size);
        }
        
        imageMode(CENTER);
        image(img, pos.x, pos.y, size, size);
    }
    
    boolean isHovered() {
        boolean isHovered = false;
        
        if (pos != null) {
            float dist = PVector.dist(pos, new PVector(mouseX, mouseY));
            isHovered = (dist < size/2.0);
        }
        
        this.hovered = isHovered;
        return isHovered;
    }
    
    void setPos(float x, float y) {
        this.pos = new PVector(x, y);  
    }
    
    public boolean mousePressed() {
        if (hovered) {
            onPressed();
            return true;
        }
        return false;
    }
    
    public abstract void onPressed();
}
