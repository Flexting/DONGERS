
import java.util.Collections;

public class GridMenu extends PopupWindow {

    private Grid grid;

    private MenuLabel hueLabel;
    private MenuIntSlider hueSlider;
    private MenuLabel brightLabel;
    private MenuIntSlider brightSlider;
    private MenuLabel opacityLabel;
    private MenuIntSlider opacitySlider;
    private MenuLabel weightLabel;
    private MenuFloatSlider weightSlider;

    private int startHue;
    private int startBright;
    private int startOpacity;
    private float startWeight;

    private MenuButton cancelButton;
    private MenuButton revertButton;
    private MenuButton applyButton;

    private float sliderHeight = 30;
    private float labelWidth = 40;

    public GridMenu(Grid grid) {
        this.grid = grid;

        hueLabel = new MenuLabel("Hue");
        brightLabel = new MenuLabel("Bright");
        opacityLabel = new MenuLabel("Alpha");
        weightLabel = new MenuLabel("Weight");

        hueSlider = new MenuIntSlider(0, 255, 8);
        brightSlider = new MenuIntSlider(0, 255, 8);
        opacitySlider = new MenuIntSlider(0, 255, 32);
        weightSlider = new MenuFloatSlider(1.0, 10.0, 0.5);

        cancelButton = new CancelButton();
        revertButton = new RevertButton();
        applyButton = new ApplyButton();

        addAll(hueLabel, brightLabel, opacityLabel, weightLabel,
            hueSlider, brightSlider, opacitySlider, weightSlider,
            cancelButton, revertButton, applyButton);

        createMenuPositions();
    }

    @Override
    public void show_i() {
        startHue = grid.getHue();
        startBright = grid.getBrightness();
        startOpacity = grid.getOpacity();
        startWeight = grid.getWeight();
    }

    protected void display_i() {
        stroke(0);
        strokeWeight(2);
        fill(255);

        menuRect.display();
        for (MenuElement element : elements) {
            element.display();
        }
    }

    public void updateValues_i() {
        hueSlider.setValue(grid.getHue());
        brightSlider.setValue(grid.getBrightness());
        opacitySlider.setValue(grid.getOpacity());
        weightSlider.setValue(grid.getWeight());
    }

    @Override
    public void collectValues() {
        grid.setHue(hueSlider.getValue());
        grid.setBrightness(brightSlider.getValue());
        grid.setOpacity(opacitySlider.getValue());
        grid.setWeight(weightSlider.getValue());
    }

    public void updateOffsets() {
        for (MenuElement element : elements) {
            element.setOffset(menuRect.x, menuRect.y);
        }
    }

    private void createMenuPositions() {
        float w = 200;
        float x = borderHorizontal;
        float y = borderVertical;

        float sliderX = x + labelWidth;
        float sliderW = w - labelWidth;

        hueLabel.setPos(x, y + sliderHeight / 2);
        hueSlider.setDimensions(sliderW, sliderHeight);
        hueSlider.setPos(sliderX, y);
        y += sliderHeight + spacing;

        brightLabel.setPos(x, y + sliderHeight / 2);
        brightSlider.setDimensions(sliderW, sliderHeight);
        brightSlider.setPos(sliderX, y);
        y += sliderHeight + spacing;

        opacityLabel.setPos(x, y + sliderHeight / 2);
        opacitySlider.setDimensions(sliderW, sliderHeight);
        opacitySlider.setPos(sliderX, y);
        y += sliderHeight + spacing;

        weightLabel.setPos(x, y + sliderHeight / 2);
        weightSlider.setDimensions(sliderW, sliderHeight);
        weightSlider.setPos(sliderX, y);
        y += sliderHeight + spacing;

        int halfSize = MenuButton.size/2;
        float yPos = y + halfSize;
        cancelButton.setPos(x + halfSize, yPos);
        revertButton.setPos(x + w * 0.50, yPos);
        applyButton.setPos (x + w - halfSize, yPos);
        y += MenuButton.size;

        y += borderVertical;

        menuRect.w = w + borderHorizontal * 2;
        menuRect.h = y;
        menuRect.x = (width - menuRect.w) / 2.0;
        menuRect.y = (height - menuRect.h) / 2.0;

        updateOffsets();
    }

    public void cancel() {
        revert();
        hide();
    }

    public void revert() {
        grid.setHue(startHue);
        grid.setBrightness(startBright);
        grid.setOpacity(startOpacity);
        grid.setWeight(startWeight);
    }

    public void apply() {
        hide();
    }



    private class CancelButton extends MenuButton {
        public CancelButton() {
            super("cancel-icon.png");
        }

        @Override
        public void onPressed() {
            cancel();
        }
    }

    private class RevertButton extends MenuButton {
        public RevertButton() {
            super("revert-icon.png");
        }

        @Override
        public void onPressed() {
            revert();  
        }
    }

    private class ApplyButton extends MenuButton {
        public ApplyButton() {
            super("apply-icon.png");
        }

        @Override
        public void onPressed() {
            apply();  
        }
    }

}
