
public class Grid {
    private static final float minGridSize = 10;

    private Image grid; // Grid displayed over the top of the image

    private PVector gridPos; // Grid x/y position
    private PVector gridTempPos; // Grid temp x/y position used for dragging

    private float gridSize = 60; // Size of the overlay grid
    private boolean showGrid = true;
    private float gridWeight = 2;

    public Grid() {
        grid = new Image();
        gridPos = new PVector();
        gridTempPos = new PVector();
        createGrid();
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
        grid.stroke(0, 255);
        for (int i = 0; i <= grid.width / gridSize; ++i) {
            float x = gridSize * i + gridPos.x;
            grid.line(x, 0, x, inputImage.img.height);
        }
        for (int i = 0; i <= grid.height / gridSize; ++i) {
            float y = gridSize * i + gridPos.y;
            grid.line(0, y, inputImage.img.width, y);
        }
        grid.endDraw();
        this.grid.setImage(grid);
    }

    public boolean isVisible() {
        return this.showGrid;
    }

    public float getSize() {
        return this.gridSize;
    }
}
