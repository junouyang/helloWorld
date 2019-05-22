import org.apache.commons.io.IOUtils;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * Created by jun.ouyang on 6/7/16.
 */
public class TestHelloWorld {
    private int count = 0;
    private String[] ports;
    long totalTime = 0;

    public static void main(String[] args) throws InterruptedException, IOException, URISyntaxException {
        TestHelloWorld testHelloWorld = new TestHelloWorld();
        testHelloWorld.ports = args;

        final String[] btNames = new String[]{repeat('a', 30), repeat('b', 30), repeat('c', 30), repeat('d', 30)};

        int i = 0;

        while (true) {
            final String btName = btNames[i++];
            i = i % btNames.length;
            new Thread() {
                public void run() {
                    try {
                        testHelloWorld.connectApp(btName, "client-" + System.currentTimeMillis() % 10);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }.start();
            TimeUnit.SECONDS.sleep(2);
        }

    }

    private void connectApp(String btName, String username) throws IOException, URISyntaxException {
//        URI url = new URI("http://localhost:8888");

        long start = System.currentTimeMillis();
        String port = ports[count++ % ports.length];
//        String port = "8988";
        URL url = new URL("http://localhost:" + port + "/backend?name=" + username);
        try {
            System.out.println(count + ", port-" + port + " : " + IOUtils.toString(url.openConnection().getInputStream(), "utf-8"));
        } catch (Exception e) {
            System.out.println("==================== connect to " + port + ":" + e.getLocalizedMessage() );
            throw new RuntimeException(e.getMessage());
        }
        totalTime += System.currentTimeMillis() - start;
        System.out.println("average : " + (totalTime / count));
        System.out.println(btName);
        if (count == 60) {
            count = 0;
            totalTime = 0;
        }
    }

    private static String repeat(char c, int times) {
        StringBuilder builder = new StringBuilder();
        for( int i = 0; i < times;i++) {
            builder.append(c);
        }
        return builder.toString();
    }
}
