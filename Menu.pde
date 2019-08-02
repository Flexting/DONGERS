
public class Menu extends PopupWindow {

    private int lastWidth;

    public Menu() {
        this.lastWidth = 0;
        show();
    }

    public void addItem(MenuButton item) {
        add(item);
        updateMenuPositions();
    }

    protected void display_i() {
        if (elements.isEmpty()) return;

        // Only re-calculate the positions if the width has changed
        if (width != lastWidth) {
            updateMenuPositions();
        }

        stroke(0);
        strokeWeight(2);
        fill(255);
        menuRect.display();
        for (MenuElement element : elements) {
            element.display();
        }
    }
    
    private void updateMenuPositions() {
        int count = elements.size();
        menuRect.w = count * MenuButton.size + spacing * (count - 1) + borderHorizontal * 2;
        menuRect.h = MenuButton.size + borderVertical * 2;
        menuRect.x = (width - menuRect.w)/2.0;
        menuRect.y = 0;

        updateItemPositions();
        lastWidth = width;
    }

    private void updateItemPositions() {
        for (int i = 0; i < elements.size(); ++i) {
            MenuButton item = (MenuButton) elements.get(i);
            float itemX = borderHorizontal/2.0 + (MenuButton.size + spacing) * (i + 0.5);
            item.setPos(itemX, menuRect.h/2);
            item.setOffset(menuRect.x, menuRect.y);
        }
    }
    
}
