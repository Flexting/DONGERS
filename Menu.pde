
public class Menu {
    ArrayList<MenuItem> items;
    float border = 10;
    float spacing = 10;
    
    public Menu() {
        items = new ArrayList<MenuItem>();    
    }
    
    public void addItem(MenuItem item) {
        items.add(item);   
        updateItemPositions();
    }
    
    public void updateItemPositions() {
        if (items.isEmpty()) return;
        
        float w = (items.size()) * MenuItem.diameter + spacing * (items.size() - 1) + border,
              h = MenuItem.diameter + border,
              x = width / 2 - w / 2,
              y = 0;
        
        for (int i = 0; i < items.size(); i++) {
            MenuItem item = items.get(i);
            float itemX = x + (MenuItem.diameter + spacing) * (i + 0.5);
            item.setPos(itemX, y + h/2);
        }
    }
    
    public void display() {
        if (items.isEmpty()) return;
        float w = (items.size()) * MenuItem.diameter + spacing * (items.size() - 1) + border,
              h = MenuItem.diameter + border,
              x = width / 2 - w / 2,
              y = 0;
              
        stroke(0);
        strokeWeight(2);
        fill(80);
        rect(x, y, w, h, 0, 0, h/2, h/2);
        
        for (MenuItem item : items) {
            item.display();    
        }
    }
    
    public boolean mousePressed() {
        boolean itemPressed = false;
        for (MenuItem item : items) {
            if (item.mousePressed()) {
                itemPressed = true;    
            }
        }
        return itemPressed;
    }
    
}
