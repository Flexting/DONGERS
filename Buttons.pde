
public class ToggleGridButton extends MenuItem {
    public ToggleGridButton() {
        super("grid-icon.png");
    }

    public void onPressed() {
        toggleGrid();
    }
}

public class LoadImageButton extends MenuItem {
    public LoadImageButton() {
        super("open-icon.png");
    }

    public void onPressed() {
        selectInput("Select an image", "imageChosen");  
    }
}

public class RotateImageRightButton extends MenuItem {
    public RotateImageRightButton() {
        super("rotate-right-icon.png");
    }

    public void onPressed() {
        rotateImageRight();  
    }
}

public class ResetButton extends MenuItem {
    public ResetButton() {
        super("reset-icon.png");
    }

    public void onPressed() {
        resetImage();  
    }
}
