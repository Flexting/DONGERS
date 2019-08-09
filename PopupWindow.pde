
import java.util.List;

public abstract class PopupWindow {

    protected final MenuRect menuRect;
    protected final List<MenuElement> elements;

    private int lastWidth = 0;
    private int lastHeight = 0;
    protected boolean visible = false;
    protected MenuElement selectedElement = null;

    protected float borderHorizontal = 5;
    protected float borderVertical = 5;
    protected float spacing = 10;

    public PopupWindow() {
        this.menuRect = new MenuRect();
        this.elements = new ArrayList<MenuElement>();
    }

    /* Display functions */

    public final void display() {
        if (visible && !elements.isEmpty()) {
            if (width != lastWidth || height != lastHeight) {
                onResize();
                lastWidth = width;
                lastHeight = height;
            }

            stroke(0);
            strokeWeight(2);
            fill(255);
            menuRect.display();
            for (MenuElement element : elements) {
                element.display();
            }
            // Check for tooltips
            for (MenuElement element : elements) {
                element.displayToolTip();
            }
            //onDisplay();
        }
    }

    // Overridable, currently unused. Uncomment when required.
    //protected void onDisplay() {}

    /* Mouse functions */

    public final boolean mousePressed() {
        if (visible) {
            for (MenuElement element : elements) {
                if (element.mousePressed()) {
                    selectedElement = element;
                    return true;
                }
            }
            if (menuRectPressed()) {
                selectWindow();
                return true;
            }
        }
        return false;
    }

    public void mouseDragged() {
        if (selectedElement != null) {
            selectedElement.onDragged();
        }
    }

    public final void mouseReleased() {
        if (selectedElement != null) {
            selectedElement.mouseReleased();
            selectedElement = null;
        } else {
            deselectWindow();
        }
    }

    private boolean menuRectPressed() {
        return (menuRect.x < mouseX && mouseX < menuRect.x + menuRect.w
            &&  menuRect.y < mouseY && mouseY < menuRect.y + menuRect.h);
    }

    protected void selectWindow() {}
    protected void deselectWindow() {}

    /* Reading and writing from the model */

    public final void readValues() {
        if (visible) {
            onReadValues();
        }
    }

    public final void writeValues() {
        onWriteValues();
    }

    // Overridable
    protected void onReadValues() {}
    protected void onWriteValues() {}

    /* Showing and hiding of the window */

    public final void show() {
        resetWindowPos();
        if (!visible) {
            visible = true;
            onShow();
            onReadValues();
        }
    }

    public final void hide() {
        if (visible) {
            visible = false;
            onHide();
        }
    }

    // Overridable
    protected void onShow() {}
    protected void onHide() {}

    /* Window elements & positions */

    protected final void addAll(MenuElement... list) {
        for (MenuElement element : list) {
            add(element);
        }
    }

    protected final void add(MenuElement element) {
        elements.add(element);
        element.setWindow(this);
    }

    protected final void updateOffsets() {
        for (MenuElement element : elements) {
            element.setOffset(menuRect.x, menuRect.y);
        }
    }

    public final void resetWindowPos() {
        PVector pos = getPreferredWindowPos();
        setWindowPos(pos.x, pos.y);
    }

    protected final void setWindowPos(float x, float y) {
        x = (x < 0) ? 0 : (x > width - menuRect.w) ? width - menuRect.w : x;
        y = (y < 0) ? 0 : (y > height - menuRect.h) ? height - menuRect.h : y;

        if (x != menuRect.x || y != menuRect.y) {
            menuRect.x = x;
            menuRect.y = y;
            updateOffsets();
        }
    }

    protected abstract PVector getPreferredWindowPos();
    protected abstract void onResize();

    // Protected inner class
    protected class MenuRect {
        float x, y, w, h;
        public void display() {
            float curve = borderHorizontal * 2;
            rect(x, y, w, h, curve, curve, curve, curve);
        }
    }
}

public abstract class DraggableWindow extends PopupWindow {

    private boolean selectedWindow = false;
    private PVector startPos;

    @Override
    protected void selectWindow() {
        selectedWindow = true;
        startPos = new PVector(menuRect.x, menuRect.y);
    }

    @Override
    protected void deselectWindow() {
        selectedWindow = false;
        startPos = null;
    }

    @Override
    public void mouseDragged() {
        if (selectedWindow) {
            float x = startPos.x + mouseX - mouseDownPos.x;
            float y = startPos.y + mouseY - mouseDownPos.y;
            setWindowPos(x, y);
        } else {
            super.mouseDragged();
        }
    }
    
    protected void onResize() {
        // Force window to be in the bounds of the screen, for all draggable menus
        setWindowPos(menuRect.x, menuRect.y);
    }
}
