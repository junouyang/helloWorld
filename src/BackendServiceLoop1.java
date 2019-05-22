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
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by jun.ouyang on 6/16/16.
 */
public class BackendServiceLoop1 extends HttpServlet {

    int port;
    boolean isLast;
    volatile long sleepTime = 0;
    final static ReentrantLock lock = new ReentrantLock();
    volatile int requestCount = 1;
    SetSleepTime setSleepTime = new SetSleepTime();
    SetRequestCount setRequestCount = new SetRequestCount();
    int count = 0;
    long totalTime = 0;

    public BackendServiceLoop1(int port, boolean isLast) {
        this.port = port;
        this.isLast = isLast;
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
        if( isLast ) {
            lock.lock();
        }

        try {
            String name = request.getParameter("name");
            System.out.println("Received request : " + String.valueOf(name));
            // Declare response encoding and types
            response.setContentType("text/html; charset=utf-8");

            // Write back response
            PrintWriter writer = response.getWriter();
            writer.println("<h1>From port " + port +
                    " </h1>" + String.valueOf(name));
            if (!isLast) {
                List<Thread> threads = new ArrayList<>();
                for( int i = 0; i < requestCount; i++ ) {
                    Thread thread = new Thread() {
                        public void run() {
                            try {
                                connectToDatabase(writer, name);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    };
                    threads.add(thread);
                    thread.start();
                }
                threads.stream().forEach(thread -> {
                    try {
                        thread.join();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                });
//                connectToDatabase(writer);
            }

            // Declare response status code
            response.setStatus(HttpServletResponse.SC_OK);
            if( isLast && sleepTime > 0) {
                try {
                    TimeUnit.MILLISECONDS.sleep(sleepTime);
                } catch (InterruptedException e) {
                }
            }
        } finally {
            if( isLast ) {
                lock.unlock();
            }
        }
        totalTime += System.currentTimeMillis() - start;
        System.out.println( "average : " + (totalTime/ count));
        if( count == 60 ) {
            count = 0;
            totalTime = 0;
        }
    }

    private void connectToDatabase(PrintWriter writer, String name ) throws IOException {
        URL url = new URL("http://localhost:" + 8988 + "/bt1_end?name="+name);
        writer.println("--" + IOUtils.toString(url.openConnection().getInputStream(), "utf-8"));
    }

    public static void main(String[] args) throws Exception {
//        BackendServiceLoop1.start(args[0], Integer.parseInt(args[1]), "true".equalsIgnoreCase(args[2])).join();

        Server server1 = BackendServiceLoop1.start("bt1_start", 8987, false);
        Server server2 = BackendServiceLoop1.start("bt2_end", 8990, true);
        server1.join();
        server2.join();
    }

    public static Server start(String servletName, int port, boolean isLast) throws Exception {
        Server server = new Server(port);

        ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
        context.setContextPath("/");
        server.setHandler(context);

        BackendServiceLoop1 backendService = new BackendServiceLoop1(port, isLast);
        context.addServlet(new ServletHolder(backendService), "/" + servletName);
        context.addServlet(new ServletHolder(backendService.setSleepTime), "/sleeptime");
        context.addServlet(new ServletHolder(backendService.setRequestCount), "/requests");

        server.start();
        return server;
    }

    public class SetSleepTime extends HttpServlet {
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            BackendServiceLoop1.this.sleepTime = Long.parseLong(request.getParameter("s"));
        }
    }

    public class SetRequestCount extends HttpServlet {
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            BackendServiceLoop1.this.requestCount = Integer.parseInt(request.getParameter("c"));
        }
    }
}
