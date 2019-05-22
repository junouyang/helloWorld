package test.generic;

import java.util.List;

/**
 * Created by jun.ouyang on 9/19/16.
 */
public class Implementation<T extends Integer> implements GInterface<T> {

    T list;

    public Implementation(T list) {

    }

    @Override
    public void test(T list) {

    }

    @Override
    public Class<T> getClazz() {
        return (Class<T>) list.getClass();
    }


}
