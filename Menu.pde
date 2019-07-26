
public class Menu {
    private MenuRect menuRect;
    private int lastWidth = 0;
    private ArrayList<MenuItem> items;
    private float borderHorizontal = 5;
    private float borderVertical = 5;
    private float spacing = 10;

    public Menu() {
        this.items = new ArrayList<MenuItem>();
        this.menuRect = new MenuRect();
    }

    public void addItem(MenuItem item) {
        items.add(item);
        updateMenuPositions();
    }

    public void display() {
        if (items.isEmpty()) return;

        // Only re-calculate the positions if the width has changed
        if (width != lastWidth) {
            updateMenuPositions();
        }

        stroke(0);
        strokeWeight(2);
        fill(255);
        menuRect.display();
        for (MenuItem item : items) {
            item.display();
        }
    }
    
    private void updateMenuPositions() {
        int count = items.size();
        menuRect.w = count * MenuItem.size + spacing * (count - 1) + borderHorizontal * 2;
        menuRect.h = MenuItem.size + borderVertical * 2;
        menuRect.x = (width - menuRect.w)/2.0;
        menuRect.y = 0;

        updateItemPositions();
        lastWidth = width;
    }

    private void updateItemPositions() {
        if (items.isEmpty()) return;

        int count = items.size();
        float h = menuRect.h,
              x = menuRect.x,
              y = menuRect.y;

        for (int i = 0; i < count; ++i) {
            MenuItem item = items.get(i);
            float itemX = x + borderHorizontal/2.0 + (MenuItem.size + spacing) * (i + 0.5);
            item.setPos(itemX, y + h/2);
        }
    }

    public boolean mousePressed() {
        for (MenuItem item : items) {
            if (item.mousePressed()) {
                return true;
            }
        }
        return false;
    }
    
    // Private inner class
    private class MenuRect {
        float x, y, w, h;
        public void display() {
            rect(x, y, w, h, 0, 0, borderHorizontal * 2, borderHorizontal * 2);
        }
    }
}
