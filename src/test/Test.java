package test;

import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.concurrent.TimeUnit;

/**
 * Created by jun.ouyang on 8/18/16.
 */


public class Test {
    public static void main(String[] args) {

        Set<Long> hashSet = new LinkedHashSet<>();

        hashSet.add(1l);
        hashSet.add(2l);

        System.out.print(hashSet);
//
//        System.out.println(System.currentTimeMillis());
//        System.out.println(System.currentTimeMillis() - TimeUnit.HOURS.toMillis(3));
    }
}