
public abstract class MenuItem {
    static final int diameter = 32;
    String buttonName;
    PImage img = loadImage(sketchPath() + "/images/RotateLeft.png");
    PGraphics maskImg;
    PVector pos = null;
    boolean hovered = false;
    
    public MenuItem(String imgPath) {
        img = loadImage(sketchPath() + "/images/" + imgPath);
        createMask();
    }
    
    // Create a mask used to make the images used display circular.
    private void createMask() {
        maskImg = createGraphics(img.width, img.height);
        maskImg.beginDraw();
            maskImg.stroke(0);
            maskImg.fill(255);
            maskImg.ellipse(img.width/2.0, img.height/2.0, img.width, img.height);
            maskImg.endDraw();
        img.mask(maskImg);
    }
    
    public void display() {
        isHovered();
        if (hovered) {
            stroke(200, 200, 0);
        } else {
            stroke(0);
        }
        imageMode(CENTER);
        image(img, pos.x, pos.y, diameter, diameter);
        noFill();
        strokeWeight(2);
        ellipse(pos.x, pos.y, diameter, diameter);
    }
    
    boolean isHovered() {
        boolean isHovered = false;
        
        if (pos != null) {
            float dist = PVector.dist(pos, new PVector(mouseX, mouseY));
            isHovered = (dist < diameter / 2.0);
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
