
public abstract class MenuItem {
    private static final int size = 32;
    private PImage img;
    private PVector pos = null;
    private boolean hovered = false;

    public MenuItem(String imgPath) {
        this.img = loadImage(sketchPath() + "/images/" + imgPath);
    }

    public abstract void onPressed();

    public void display() {
        checkHovered();
        if (hovered) {
            stroke(0);
            fill(0);
            rect(pos.x - size/2.0, pos.y - size/2.0, size, size);
        }

        imageMode(CENTER);
        image(img, pos.x, pos.y, size, size);
    }

    public boolean mousePressed() {
        if (hovered) {
            onPressed();
        }
        return hovered;
    }

    private boolean checkHovered() {
        boolean hovered = false;

        if (pos != null) {
            float dist = PVector.dist(pos, new PVector(mouseX, mouseY));
            hovered = (dist < size/2.0);
        }

        this.hovered = hovered;
        return hovered;
    }

    private void setPos(float x, float y) {
        this.pos = new PVector(x, y);
    }
}
