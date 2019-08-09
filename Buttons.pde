
public class ToggleGridButton extends MenuButton {
    public ToggleGridButton() {
        super("grid-icon.png");
    }

    @Override
    public void onPressed() {
        toggleGrid();
    }
}

public class LoadImageButton extends MenuButton {
    public LoadImageButton() {
        super("open-icon.png");
    }

    @Override
    public void onPressed() {
        chooseImage();
    }
}

public class RotateImageRightButton extends MenuButton {
    public RotateImageRightButton() {
        super("rotate-right-icon.png");
    }

    @Override
    public void onPressed() {
        rotateImageRight();
    }
}

public class ResetButton extends MenuButton {
    public ResetButton() {
        super("reset-icon.png");
    }

    @Override
    public void onPressed() {
        resetImage();
    }
}

public class GridMenuButton extends MenuButton {
    public GridMenuButton() {
        super("gear-icon.png");
    }

    @Override
    public void onPressed() {
        showGridMenu();
    }
}
