import org.apache.commons.io.IOUtils;

import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Created by jun.ouyang on 10/12/16.
 */
public class GenerateExceptions {

    public static void main(String[] args) {

//        final String address
//                = "http://localhost:8005/GenerateErrorsApp-1.0-jdk1.8/servlet.generateexceptionservlet";

        final String address = args[0];
        ExecutorService executorService = Executors.newFixedThreadPool(100);
        for(int i = 0; i < 10; i++ ) {
            final int index = i;
            executorService.submit(new Thread() {
                public void run( ) {
                    int j = 0;
                    while(true) {
                        try {
                            Thread.sleep(300);
                            URL url = new URL(address);
                            InputStream inputStream = url.openConnection().getInputStream();
                            if( j % 100 == 0 ) {
                                System.out.print(index + "-" + j/100 + ":");
                                IOUtils.copy(inputStream, System.out);
                            }
                        } catch (Exception e) {
                            if( j % 100 == 0 ) {
                                System.out.println(index + "-" + j/100 + ":" + e.getLocalizedMessage());
                            }
                        }
                        j++;
                    }
                }
            });
        }

        executorService.shutdown();
//        try {
//            executorService.awaitTermination(1, TimeUnit.HOURS);
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
    }
}
