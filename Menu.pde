
public class Menu {
    ArrayList<MenuItem> items;
    float borderHorizontal = 5;
    float borderVertical = 5;
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
        
        int itemSize = items.size();
        float w = itemSize * MenuItem.size + spacing * (itemSize - 1) + borderHorizontal * 2,
              h = MenuItem.size + borderVertical * 2,
              x = width / 2 - w / 2,
              y = 0;
        
        for (int i = 0; i < itemSize; i++) {
            MenuItem item = items.get(i);
            float itemX = x + borderHorizontal/2.0 + (MenuItem.size + spacing) * (i + 0.5);
            item.setPos(itemX, y + h/2);
        }
    }
    
    public void display() {
        if (items.isEmpty()) return;
        
        int itemSize = items.size();
        float w = itemSize * MenuItem.size + spacing * (itemSize - 1) + borderHorizontal * 2,
              h = MenuItem.size + borderVertical * 2,
              x = width/2.0- w/2.0,
              y = 0;
              
        stroke(0);
        strokeWeight(2);
        fill(255);
        rect(x, y, w, h, 0, 0, borderHorizontal * 2, borderHorizontal * 2);
        
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
