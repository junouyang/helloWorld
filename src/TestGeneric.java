import java.lang.reflect.ParameterizedType;
import java.lang.reflect.TypeVariable;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by jun.ouyang on 9/16/16.
 */
public class TestGeneric<T extends Object> {

    List<T> b = new LinkedList<>();

    public void add(List<T> lists ) {
        b.addAll(lists);
    }

    public static void main(String[] args) {
        TestGeneric<String> t = new TestGeneric<>();
//        Class aClass = (Class) ((ParameterizedType) t.getClass()
//                .getGenericSuperclass()).getActualTypeArguments()[0];
//        Class clazz = (Class)(((ParameterizedType)(t.getClass().getGenericSuperclass())).getActualTypeArguments()[0]);
//        System.out.println(aClass);
        TypeVariable<? extends Class<? extends TestGeneric>>[] typeParameters = t.getClass().getTypeParameters();
        for(TypeVariable<? extends Class<? extends TestGeneric>> type : typeParameters ) {
            System.out.println(type.getGenericDeclaration());
        }
    }
}
