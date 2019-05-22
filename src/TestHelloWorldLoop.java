import org.apache.commons.io.IOUtils;
import org.eclipse.jetty.server.Server;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.concurrent.TimeUnit;

/**
 * Created by jun.ouyang on 6/7/16.
 */
public class TestHelloWorldLoop {
    private int count = 0;
    private String[] ports;
    long totalTime = 0;

    public TestHelloWorldLoop(String... ports) {
        this.ports = ports;
    }

    public static void main(String[] args) throws Exception {
        Thread requestMaker1 = makeRequest("8987", "bt1_start");
        Thread requestMaker2 = makeRequest("8989", "bt2_start");
        Thread requestMaker3 = makeRequest("8999", "bt3_start");
        requestMaker1.join();
        requestMaker2.join();
        requestMaker3.join();
    }

    private static Thread makeRequest(String port, String bt) {
        TestHelloWorldLoop testHelloWorld = new TestHelloWorldLoop(port);

        final String[] btNames = new String[]{bt};

        Thread requestMaker = new Thread() {
            public void run() {
                int i = 0;
                while (true) {
                    final String btName = btNames[i++];
                    i = i % btNames.length;
                    try {
                        testHelloWorld.connectApp(btName, "client-" + System.currentTimeMillis() % 10000);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    try {
                        TimeUnit.SECONDS.sleep(2);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        };
        requestMaker.start();
        return requestMaker;
    }

    private void connectApp(String btName, String username) throws IOException, URISyntaxException {
//        URI url = new URI("http://localhost:8888");

        long start = System.currentTimeMillis();
        String port = ports[count++ % ports.length];
//        String port = "8988";
        URL url = new URL("http://localhost:" + port + "/" +
                btName +
                "?name=" + username);
        try {
            System.out.println(count + ", port-" + port + " : " + IOUtils.toString(url.openConnection().getInputStream(), "utf-8"));
        } catch (Exception e) {
            System.out.println("==================== " + e.getLocalizedMessage() );
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
