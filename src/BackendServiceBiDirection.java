import org.apache.commons.io.IOUtils;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.TimeUnit;

/**
 * Created by jun.ouyang on 6/16/16.
 */
public class BackendServiceBiDirection extends HttpServlet {

    int port;
    Integer backendPort;
    volatile long sleepTime = 100;
    volatile int requestCount = 1;
    SetSleepTime setSleepTime = new SetSleepTime();
    SetRequestCount setRequestCount = new SetRequestCount();
    int count = 0;
    long totalTime = 0;

    public BackendServiceBiDirection(int port, Integer backendPort) {
        this.port = port;
        this.backendPort = backendPort;
//        if (backendPorts != null && backendPorts.length != 0) backendPort = backendPorts[0];
    }

    public void setSleepTime(long sleepTime ) {
        this.sleepTime = sleepTime;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        count++;
        long start = System.currentTimeMillis();

//        if(true) {
//            throw new RuntimeException(UUID.randomUUID().toString());
//        }
//        if( true ) {
//            System.out.println("throwwwwwwwwwwwwwwwwwwwwwwwwww");
//            throw new RuntimeException("twitter.com/poo\uD83D\uDCA9.html");
//        }

        String name = request.getParameter("name");
        System.out.println("Received request : " + String.valueOf(name));
        // Declare response encoding and types
        response.setContentType("text/html; charset=utf-8");

        // Write back response
        PrintWriter writer = response.getWriter();
        writer.println("<h1>From port " + port +
                " </h1>" + String.valueOf(name));
        if (backendPort != null && !name.contains("-relay")) {
            List<Thread> threads = new ArrayList<>();
            for (int i = 0; i < requestCount; i++) {
//                Thread thread = new Thread() {
//                    public void run() {
                        try {
                            connectToDatabase(writer, name + "-relay-from-" + port + "-to-" + backendPort );
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
//                    }
//                };
//                threads.add(thread);
//                thread.start();
            }
//            threads.stream().forEach(thread -> {
//                try {
//                    thread.join();
//                } catch (InterruptedException e) {
//                    e.printStackTrace();
//                }
//            });
        }

        // Declare response status code
        response.setStatus(HttpServletResponse.SC_OK);
//        if (backendPort != null && sleepTime > 0) {
            try {
                int timeToSleep = count % 10 == 1 ? 1000: 100;
                TimeUnit.MILLISECONDS.sleep(new Random().nextInt(timeToSleep));
            } catch (InterruptedException e) {
            }
//        }
        totalTime += System.currentTimeMillis() - start;
        System.out.println("average : " + (totalTime / count));
        if (count == 60) {
//            count = 0;
            totalTime = 0;
        }
        if( count == 60000 ) {
            count = 0;
        }
    }

    private void connectToDatabase(PrintWriter writer, String name ) throws IOException {
        URL url = new URL("http://localhost:" + backendPort+ "/backend?name="+name);
        writer.println("--" + IOUtils.toString(url.openConnection().getInputStream(), "utf-8"));
    }

    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(args[0]);
        Server server = new Server(port);

        ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
        context.setContextPath("/");
        server.setHandler(context);

        Integer backendPort = args.length >= 2 ? Integer.parseInt(args[1]) : null;
        BackendServiceBiDirection backendService = new BackendServiceBiDirection(port, backendPort);
        if( args.length > 2 ) {
            backendService.setSleepTime(Long.parseLong(args[2]));
        }
        context.addServlet(new ServletHolder(backendService), "/backend");
        context.addServlet(new ServletHolder(backendService.setSleepTime), "/sleeptime");
        context.addServlet(new ServletHolder(backendService.setRequestCount), "/requests");

        server.start();
        server.join();
    }

    public class SetSleepTime extends HttpServlet {
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            BackendServiceBiDirection.this.sleepTime = Long.parseLong(request.getParameter("s"));
        }
    }

    public class SetRequestCount extends HttpServlet {
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            BackendServiceBiDirection.this.requestCount = Integer.parseInt(request.getParameter("c"));
        }
    }
}
