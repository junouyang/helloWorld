package test.generic;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Created by jun.ouyang on 9/19/16.
 */
public class GIntefaceCollection {

    private List<? extends Integer> lists = new LinkedList<>();
    private Map<Class<? extends Integer>, Implementation<?>> test = new HashMap<>();

    public void test( ) {
        for(Integer list : lists ) {
            create(list);
        }
    }

    //Have to use this helper method
    public <T extends Integer> void create( T list ) {
        Implementation<T> impl = (Implementation<T>) test.get(list.getClass());
        if( impl == null ) {
            impl = new Implementation<>(list);
            test.put(list.getClass(), impl);
        }
    }
}
