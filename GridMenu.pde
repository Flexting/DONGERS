
import java.util.Collections;

public class GridMenu extends DraggableWindow {

    private Grid grid;

    private MenuLabel hueLabel;
    private MenuIntSlider hueSlider;
    private MenuLabel saturLabel;
    private MenuIntSlider saturSlider;
    private MenuLabel brightLabel;
    private MenuIntSlider brightSlider;
    private MenuLabel opacityLabel;
    private MenuIntSlider opacitySlider;
    private MenuLabel weightLabel;
    private MenuFloatSlider weightSlider;

    private int startHue;
    private int startSatur;
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
        saturLabel = new MenuLabel("Satur.");
        brightLabel = new MenuLabel("Bright");
        opacityLabel = new MenuLabel("Alpha");
        weightLabel = new MenuLabel("Weight");

        hueSlider = new MenuIntSlider(0, 255, 8);
        saturSlider = new MenuIntSlider(0, 255, 16);
        brightSlider = new MenuIntSlider(0, 255, 16);
        opacitySlider = new MenuIntSlider(0, 255, 32);
        weightSlider = new MenuFloatSlider(1.0, 10.0, 0.5);

        cancelButton = new CancelButton();
        revertButton = new RevertButton();
        applyButton = new ApplyButton();

        addAll(hueLabel, saturLabel, brightLabel, opacityLabel, weightLabel,
            hueSlider, saturSlider, brightSlider, opacitySlider, weightSlider,
            cancelButton, revertButton, applyButton);

        createMenuPositions();
    }

    @Override
    public void onShow() {
        startHue = grid.getHue();
        startSatur = grid.getSaturation();
        startBright = grid.getBrightness();
        startOpacity = grid.getOpacity();
        startWeight = grid.getWeight();
    }

    @Override
    protected void onReadValues() {
        hueSlider.setValue(grid.getHue());
        saturSlider.setValue(grid.getSaturation());
        brightSlider.setValue(grid.getBrightness());
        opacitySlider.setValue(grid.getOpacity());
        weightSlider.setValue(grid.getWeight());
    }

    @Override
    protected void onWriteValues() {
        grid.setHue(hueSlider.getValue());
        grid.setSaturation(saturSlider.getValue());
        grid.setBrightness(brightSlider.getValue());
        grid.setOpacity(opacitySlider.getValue());
        grid.setWeight(weightSlider.getValue());
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

        saturLabel.setPos(x, y + sliderHeight / 2);
        saturSlider.setDimensions(sliderW, sliderHeight);
        saturSlider.setPos(sliderX, y);
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
        resetWindowPos();
    }

    protected PVector getPreferredWindowPos() {
        float x = (width - menuRect.w) / 2.0;
        float y = (height - menuRect.h) / 2.0;
        return new PVector(x, y);
    }

    public void cancel() {
        revert();
        hide();
    }

    public void revert() {
        grid.setHue(startHue);
        grid.setSaturation(startSatur);
        grid.setBrightness(startBright);
        grid.setOpacity(startOpacity);
        grid.setWeight(startWeight);
    }

    public void apply() {
        hide();
    }

    private class CancelButton extends MenuButton {
        public CancelButton() {
            super("cancel-icon.png", "Revert changes and close window");
        }

        public void onPressed() {
            cancel();
        }
    }

    private class RevertButton extends MenuButton {
        public RevertButton() {
            super("revert-icon.png", "Revert changes");
        }

        public void onPressed() {
            revert();  
        }
    }

    private class ApplyButton extends MenuButton {
        public ApplyButton() {
            super("apply-icon.png", "Apply changes and close window");
        }

        public void onPressed() {
            apply();  
        }
    }

}
