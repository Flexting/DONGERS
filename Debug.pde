
public class Debug {

    private Long lastTime;
    private String out;

    public Debug(String name) {
        out = "[" + name + "] ";
        lastTime = System.currentTimeMillis();
    }

    public void checkpoint(String key) {
        Long time = System.currentTimeMillis();
        out += key + ":" + (time - lastTime) + "ms, ";
        lastTime = time;
    }

    public void end() {
        checkpoint("END");
        println(out);
    }
}
