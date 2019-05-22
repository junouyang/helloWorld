package unit;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import org.mockito.Mockito;

import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

/**
 * Created by jun.ouyang on 7/7/16.
 */

@RunWith(JUnit4.class)
public class TestSpy {

    @Test
    public void testVerify()
    {
        A a = Mockito.spy(new A());

        a.getA();
        verify(a, times(2)).getB();
    }

    public static class A {
        public void getA( ) {
            System.out.println(getB());
        }

        public String getB() {
            return "this is b";
        }
    }
}
