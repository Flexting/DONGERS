
public abstract class MenuElement {

    protected PopupWindow window;

    protected boolean hovered = false;
    protected PVector pos = new PVector();
    protected PVector offset = new PVector();

    public abstract void display();

    protected abstract boolean checkHovered();

    public final void displayToolTip() {
        if (hovered) {
            onDisplayToolTip();
        }
    }
    // Overridable
    public void onDisplayToolTip() {}

    /* Mouse functions */

    public final boolean mousePressed() {
        hovered = checkHovered();
        if (hovered) {
            onPressed();
        }
        return hovered;
    }

    // Overridable
    public void onPressed() {}
    public void onDragged() {}

    /* Getters and Setters */

    public final void setPos(float x, float y) {
        this.pos.set(x, y);
    }

    public final void setOffset(float x, float y) {
        this.offset.set(x, y);
    }

    public final void setWindow(PopupWindow window) {
        this.window = window;
    }

    public final PopupWindow getWindow() {
        return this.window;
    }

    protected final PVector getRealPos() {
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

    private static final int size = 32; // Icon size
    private static final int ttOffset = 10; // Tool-tip X/Y offset
    private static final int ttPadding = 5; // Tool-tip X/Y padding

    private PImage img;
    private String toolTip;

    public MenuButton(String imgPath) {
        this(imgPath, null);
    }

    public MenuButton(String imgPath, String toolTip) {
        this.img = loadImage(sketchPath() + "/data/images/" + imgPath);
        this.toolTip = toolTip;
    }

    public abstract void onPressed();

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

        displayToolTip();
    }

    protected boolean checkHovered() {
        PVector realPos = getRealPos();
        float dist = PVector.dist(realPos, new PVector(mouseX, mouseY));
        hovered = (dist < size/2.0);
        return hovered;
    }

    @Override
    public void onDisplayToolTip() {
        // Display if a tool-tip exists
        if (toolTip != null) {
            int x = mouseX + ttOffset;
            int y = mouseY + ttOffset;
            float h = 10;
            textSize(h);
            float w = textWidth(toolTip);

            fill(255);
            rect(x, y, w + 2*ttPadding, h + 2*ttPadding);

            fill(0);
            textAlign(LEFT, TOP);
            text(toolTip, x + ttPadding, y + ttPadding);
        }
    }
}

public abstract class MenuSlider extends MenuElement {

    protected Number min, max, step, value;
    private PVector dimensions;
    private float barStart, barEnd, barWidth;

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

        PVector realPos = getRealPos();
        float x1 = realPos.x + barStart;
        float x2 = realPos.x + barEnd;

        // Debug outline
        //strokeWeight(1); fill(255); rect(realPos.x, realPos.y, dimensions.x, dimensions.y);

        // Scrollbar
        strokeWeight(2);
        line(x1, y, x2, y);

        // Value pin
        Float adjusted = getAdjustedValue();
        if (adjusted != null) {
            float valueX = x1 + adjusted * barWidth;

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
        PVector realPos = getRealPos();
        float x1 = realPos.x + barStart;
        float x2 = realPos.x + barEnd;

        float min = this.min.floatValue();
        float max = this.max.floatValue();

        float selection = (mouseX - x1) / barWidth;
        selection = selection * (max - min) + min;
        selection = (selection < min) ? min : (selection > max) ? max : selection;

        if (setValue(selection)) {
            window.writeValues();
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
        barStart = y/2;
        barEnd = x - y/2;
        barWidth = barEnd - barStart;
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
