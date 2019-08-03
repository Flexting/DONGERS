
import java.util.List;

public abstract class PopupWindow {

    protected final MenuRect menuRect;
    protected final List<MenuElement> elements;

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
            onDisplay();
        }
    }

    protected abstract void onDisplay();

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
        deselectWindow();
        selectedElement = null;
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
        if (pos.x != menuRect.x || pos.y != menuRect.y) {
            menuRect.x = pos.x;
            menuRect.y = pos.y;
            updateOffsets();
        }
    }

    protected abstract PVector getPreferredWindowPos();

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
            menuRect.x = startPos.x + mouseX - mouseDownPos.x;
            menuRect.y = startPos.y + mouseY - mouseDownPos.y;
            updateOffsets();
        } else {
            super.mouseDragged();
        }
    }
}
