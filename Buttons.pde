
public class ToggleGridButton extends MenuItem {
    
    public ToggleGridButton() {
        super("grid-icon.png");
    }
    
    @Override
    public void onPressed() {
        toggleGrid();
    }
}
