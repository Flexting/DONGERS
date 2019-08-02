
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
        this.elements = new ArrayList();
    }

    public final void display() {
        if (visible) {
            display_i();
        }
    }

    protected abstract void display_i();

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

    public final void updateValues() {
        if (visible) {
            updateValues_i();
        }
    }

    // Overridable
    protected void updateValues_i() {}
    protected void collectValues() {}

    public final void show() {
        if (!visible) {
            visible = true;
            show_i();
            updateValues_i();
        }
    }

    // Overridable
    protected void show_i() {}

    public final void hide() {
        visible = false;
    }

    protected void selectWindow() {}
    protected void deselectWindow() {}

    protected final void addAll(MenuElement... elements) {
        for (MenuElement element : elements) {
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

    private boolean menuRectPressed() {
        return (menuRect.x < mouseX && mouseX < menuRect.x + menuRect.w
            &&  menuRect.y < mouseY && mouseY < menuRect.y + menuRect.h);
    }

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
    private PVector startPos = new PVector();

    @Override
    protected void selectWindow() {
        selectedWindow = true;
        startPos.set(menuRect.x, menuRect.y);
    }

    @Override
    protected void deselectWindow() {
        selectedWindow = false;
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