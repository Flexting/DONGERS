
public class Menu extends PopupWindow {

    public Menu() {
        show();
    }

    public void addItem(MenuButton item) {
        add(item);
        updateItemPositions();
    }

    protected void onDisplay() {
        stroke(0);
        strokeWeight(2);
        fill(255);
        menuRect.display();
        for (MenuElement element : elements) {
            element.display();
        }
    }

    protected PVector getPreferredWindowPos() {
        float x = (width - menuRect.w) / 2.0;
        float y = 0;
        return new PVector(x, y);
    }
    
    protected void onResize() {
        // Only re-calculate the positions if the width has changed
        resetWindowPos();
    }

    private void updateItemPositions() {
        int count = elements.size();
        menuRect.w = count * MenuButton.size + spacing * (count - 1) + borderHorizontal * 2;
        menuRect.h = MenuButton.size + borderVertical * 2;

        for (int i = 0; i < elements.size(); ++i) {
            MenuButton item = (MenuButton) elements.get(i);
            float itemX = borderHorizontal/2.0 + (MenuButton.size + spacing) * (i + 0.5);
            item.setPos(itemX, menuRect.h/2);
        }
    }
    
}
