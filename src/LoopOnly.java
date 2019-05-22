class LoopOnly {
    public static void main(String[] args) {

        int i = 0;
        while (true){
            try{
                System.out.println(i++);
                Thread.sleep(2000);
            }catch(InterruptedException e){
                System.out.println(e);
            }
        }
    }
}