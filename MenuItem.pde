
public abstract class MenuElement {

    protected PopupWindow window;

    protected boolean hovered = false;
    protected PVector pos = new PVector();
    protected PVector offset = new PVector();

    public abstract void display();

    protected abstract boolean checkHovered();

    // Overridable
    public void onPressed() {}
    public void onDragged() {}

    public boolean mousePressed() {
        hovered = checkHovered();
        if (hovered) {
            onPressed();
        }
        return hovered;
    }

    public void setPos(float x, float y) {
        this.pos.set(x, y);
    }

    public void setOffset(float x, float y) {
        this.offset.set(x, y);
    }

    public void setWindow(PopupWindow window) {
        this.window = window;
    }

    public PopupWindow getWindow() {
        return this.window;
    }

    protected PVector getRealPos() {
        return PVector.add(pos, offset);
    }

}

public class MenuLabel extends MenuElement {

    private String label;

    public MenuLabel(String label) {
        this.label = label;
    }

    public void display() {
        PVector realPos = getRealPos();
        fill(0);
        textAlign(LEFT, CENTER);
        text(label, realPos.x, realPos.y);
    }

    public boolean checkHovered() {
        return false;
    }
}

public abstract class MenuButton extends MenuElement {

    private static final int size = 32;
    private PImage img;

    public MenuButton(String imgPath) {
        this.img = loadImage(sketchPath() + "/images/" + imgPath);
    }

    public void display() {
        PVector realPos = getRealPos();
        checkHovered();
        if (hovered) {
            stroke(0);
            fill(0);
            strokeWeight(2);
            rect(realPos.x - size/2.0, realPos.y - size/2.0, size, size);
        }

        imageMode(CENTER);
        image(img, realPos.x, realPos.y, size, size);
    }

    protected boolean checkHovered() {
        PVector realPos = getRealPos();
        float dist = PVector.dist(realPos, new PVector(mouseX, mouseY));
        hovered = (dist < size/2.0);
        return hovered;
    }
}

public abstract class MenuSlider extends MenuElement {

    protected Number min, max, step, value;
    private PVector dimensions;

    public MenuSlider(Number min, Number max, Number step) {
        this.min = min;
        this.max = max;
        this.step = step;
        this.value = min;
        dimensions = new PVector();
    }

    public void display() {
        stroke(0);
        float y = offset.y + pos.y + dimensions.y / 2;

        // Debug outline
        //strokeWeight(1); rect(x1, offset.y + pos.y, dimensions.x, dimensions.y);

        // Scrollbar
        float x1 = offset.x + pos.x;
        float x2 = x1 + dimensions.x;

        strokeWeight(2);
        line(x1, y, x2, y);

        // Value pin
        Float adjusted = getAdjustedValue();
        if (adjusted != null) {
            float valueX = x1 + adjusted * dimensions.x;

            fill(255);
            strokeWeight(4);
            ellipseMode(CENTER);
            circle(valueX, y, dimensions.y / 2);
        }
    }

    protected boolean checkHovered() {
        PVector realPos = getRealPos();
        return (realPos.x < mouseX && mouseX < realPos.x + dimensions.x
            &&  realPos.y < mouseY && mouseY < realPos.y + dimensions.y);
    }

    @Override
    public void onDragged() {
        float x1 = offset.x + pos.x;
        float x2 = x1 + dimensions.x;

        float min = this.min.floatValue();
        float max = this.max.floatValue();

        float selection = (mouseX - x1) / dimensions.x;
        selection = selection * (max - min) + min;
        selection = (selection < min) ? min : (selection > max) ? max : selection;

        if (setValue(selection)) {
            window.collectValues();
        }
    }

    private Float getAdjustedValue() {
        // Value between 0.0 and 1.0
        float numerator = value.floatValue() - min.floatValue();
        float divisor = max.floatValue() - min.floatValue();
        if (divisor == 0) {
            return null;
        }
        return numerator / divisor;
    }

    // -- Getters and Setters --

    public boolean setValue(Integer value) {
        if (Math.abs(this.value.intValue() - value) >= step.intValue()
            || value == max.intValue()
            || value == min.intValue()) {

            this.value = value;
            return true;
        }
        return false;
    }

    public boolean setValue(Float value) {
        if (Math.abs(this.value.floatValue() - value) >= step.floatValue()
            || value == max.floatValue()
            || value == min.floatValue()) {

            this.value = value;
            return true;
        }
        return false;
    }

    public void setDimensions(float x, float y) {
        dimensions.set(x, y);
    }
}

public class MenuIntSlider extends MenuSlider {

    public MenuIntSlider(Integer min, Integer max, Integer step) {
        super(min, max, step);
    }

    public int getValue() {
        return this.value.intValue();
    }
}

public class MenuFloatSlider extends MenuSlider {

    public MenuFloatSlider(Float min, Float max, Float step) {
        super(min, max, step);
    }

    public float getValue() {
        return this.value.floatValue();
    }
}
