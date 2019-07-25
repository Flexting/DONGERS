
public class ToggleGridButton extends MenuItem {
    public ToggleGridButton() {
        super("grid-icon.png");
    }
    
    @Override
    public void onPressed() {
        toggleGrid();
    }
}

public class LoadImageButton extends MenuItem {
    public LoadImageButton() {
        super("open-icon.png");
    }
    
    @Override
    public void onPressed() {
        selectInput("Select an image", "imageChosen");  
    }
}

public class RotateImageRightButton extends MenuItem {
    public RotateImageRightButton() {
        super("rotate-right-icon.png");
    }
    
    @Override
    public void onPressed() {
        rotateImageRight();  
    }
}

public class ResetButton extends MenuItem {
    public ResetButton() {
        super("reset-icon.png");
    }
    
    @Override
    public void onPressed() {
        resetImage();  
    }
}
