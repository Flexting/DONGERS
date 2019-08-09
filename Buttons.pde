
public class ToggleGridButton extends MenuButton {
    public ToggleGridButton() {
        super("grid-icon.png", "Toggle the grid visiblity");
    }

    public void onPressed() {
        toggleGrid();
    }
}

public class LoadImageButton extends MenuButton {
    public LoadImageButton() {
        super("open-icon.png", "Load a new background image");
    }

    public void onPressed() {
        chooseImage();
    }
}

public class RotateImageRightButton extends MenuButton {
    public RotateImageRightButton() {
        super("rotate-right-icon.png", "Rotate the board 90 degrees clockwise");
    }

    public void onPressed() {
        rotateImageRight();
    }
}

public class ResetButton extends MenuButton {
    public ResetButton() {
        super("reset-icon.png", "Reset the board");
    }

    public void onPressed() {
        resetImage();
    }
}

public class GridMenuButton extends MenuButton {
    public GridMenuButton() {
        super("gear-icon.png", "Open the grid options menu");
    }

    public void onPressed() {
        showGridMenu();
    }
}
