
public class Thumbnail {
    private PImage img;
    private PImage originalImage;
    private PVector pos;
    private int imageSize = 32;
    
    public Thumbnail(PImage img) {
        this.originalImage = img.copy(); 
        this.img = img.copy();       
        
        if (this.originalImage.width < this.originalImage.height) {
            float ratio = this.originalImage.height / (float)this.originalImage.width;
            this.img.resize(imageSize, floor(imageSize * ratio));
        } else {
            float ratio = this.originalImage.width / (float)this.originalImage.height;
            this.img.resize(floor(imageSize * ratio), imageSize);
        }
        this.img = this.img.get(0, 0, imageSize, imageSize);
    }
    
    public void display(float x, float y) {
        pos = new PVector(x, y);
        fill(0);
        rect(x - img.width/2.0 - 2, y - img.height/2.0 - 2, img.width + 4, img.height + 4);
        image(img, x, y);
    }
    
    public final boolean mousePressed() {
        return isHovered();
    }
    
    public boolean isHovered() {
        if (pos == null) return false;
        float px = pos.x - imageSize/2;
        float py = pos.y - imageSize/2;
        
        if (mouseX >= px && mouseX <= px + imageSize && mouseY >= py && mouseY <= py + imageSize) {
            return true;
        }
        return false;
    }
}
