
public class Grid {
    private static final float minGridSize = 10;

    private Image grid; // Grid displayed over the top of the image

    private PVector gridPos; // Grid x/y position
    private PVector gridTempPos; // Grid temp x/y position used for dragging

    private boolean showGrid = true;
    private float gridSize = 60; // Size of the overlay grid
    private float gridWeight = 2; // Width of the lines

    private int gridHue = 0;
    private int gridSaturation = 255;
    private int gridBrightness = 0;
    private int gridOpacity = 255;

    public Grid() {
        grid = new Image();
        gridPos = new PVector();
        gridTempPos = new PVector();
    }

    public void display(float x, float y) {
        if (showGrid) {
            grid.setPos(x + gridTempPos.x, y + gridTempPos.y);
            grid.display();
        }
    }

    public void toggle() {
        showGrid = !showGrid;
    }

    public void setTempPos(PVector pos) {
        this.gridTempPos = pos;
    }

    public boolean setWeight(float weight) {
        // Don't recreate the grid for the same weight
        if (weight == this.gridWeight) {
            return false;
        }

        this.gridWeight = weight;
        createGrid();
        return true;
    }

    public boolean setHue(int hue) {
        // Don't recreate the grid for the same hue
        if (hue == this.gridHue) {
            return false;
        }

        this.gridHue = hue;
        createGrid();
        return true;
    }

    public boolean setBrightness(int brightness) {
        // Don't recreate the grid for the same brightness
        if (brightness == this.gridBrightness) {
            return false;
        }

        this.gridBrightness = brightness;
        createGrid();
        return true;
    }

    public boolean setOpacity(int opacity) {
        // Don't recreate the grid for the same opacity
        if (opacity == this.gridOpacity) {
            return false;
        }

        this.gridOpacity = opacity;
        createGrid();
        return true;
    }

    public boolean setSize(float size) {
        size = max(size, minGridSize);
        // Don't recreate the grid for the same size
        if (size == this.gridSize) {
            return false;
        }

        this.gridSize = size;
        updateGridPosition(false);
        createGrid();
        return true;
    }

    public boolean updateGridPosition(boolean redraw) {
        PVector newPos = new PVector((gridPos.x + gridTempPos.x / zoom) % gridSize, (gridPos.y + gridTempPos.y / zoom) % gridSize);
        // Don't recreate the grid for the same size
        if (gridPos.equals(newPos)) {
            return false;
        }

        gridPos = newPos;
        gridTempPos = new PVector();
        if (redraw) {
            createGrid();
        }
        return true;
    }

    public void createGrid() {
        PGraphics grid = createGraphics(inputImage.img.width, inputImage.img.height);
        grid.beginDraw();

        grid.strokeWeight(gridWeight);
        grid.colorMode(HSB);
        grid.stroke(gridHue, gridSaturation, gridBrightness, gridOpacity);

        for (int i = 0; i <= grid.width / gridSize; ++i) {
            float x = gridSize * i + gridPos.x;
            grid.line(x, 0, x, grid.height);
        }

        for (int i = 0; i <= grid.height / gridSize; ++i) {
            float y = gridSize * i + gridPos.y;
            grid.line(0, y, grid.width, y);
        }

        grid.endDraw();
        this.grid.setImage(grid);
        updateGridMenu();
    }

    private void updateGridMenu() {
        if (gridMenu != null) {
            gridMenu.updateValues();
        }
    }

    public boolean isVisible() {
        return this.showGrid;
    }

    public float getWeight() {
        return this.gridWeight;
    }

    public int getHue() {
        return this.gridHue;
    }

    public int getBrightness() {
        return this.gridBrightness;
    }

    public int getOpacity() {
        return this.gridOpacity;
    }

    public float getSize() {
        return this.gridSize;
    }
}
