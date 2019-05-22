package test.generic;

import java.util.List;

/**
 * Created by jun.ouyang on 9/19/16.
 */
public interface GInterface<T extends Integer> {

    void test( T list);

    Class<T> getClazz();
}
