import java.util.LinkedList;
import java.util.List;

/**
 * Created by jun.ouyang on 6/23/16.
 */
public class DiagnoseBean {

    public TreeNode original, newRoot, database1, database2;

    public DiagnoseBean() {
        original = createOriginal();
        newRoot = createNew();
    }

    private TreeNode createOriginal() {
        TreeNode root = new TreeNode("web tier", 512, 30);
        TreeNode webToService = new TreeNode("transmission from web tier to service tier", 510, 30);
        TreeNode bookService = new TreeNode("book service tier", 508, 30);
        TreeNode serviceToDatabase = new TreeNode("transmission from service tier to database tier", 507, 30);
        database1 = new TreeNode("database tier", 505, 30);
        root.addChild(webToService);
        webToService.addChild(bookService);
        bookService.addChild(serviceToDatabase);
        serviceToDatabase.addChild(database1);
        return root;
    }

    private TreeNode createNew() {
        TreeNode root = new TreeNode("web tier", 1013, 30);
        TreeNode webToService = new TreeNode("transmission from web tier to service tier", 1012, 30);
        TreeNode bookService = new TreeNode("book service tier", 842, 60);
        TreeNode serviceToDatabase = new TreeNode("transmission from service tier to database tier", 758, 60);
        database2 = new TreeNode("database tier", 757, 60);
        root.addChild(webToService);
        webToService.addChild(bookService);
        bookService.addChild(serviceToDatabase);
        serviceToDatabase.addChild(database2);
        return root;
    }

    public String getAlert() {
        return "alerts from bean";
    }

    public String getCause() {
        StringBuilder sb = new StringBuilder();
        TreeNode start1 = database1, start2 = database2;
        TreeNode responseRoot1 = null, responseRoot2 = null;
        while (start1 != null && start2 != null) {
            if (start2.responseTime > (long) (start1.responseTime * 1.05) && start1 != database1) {
                responseRoot1 = start1;
                responseRoot2 = start2;
            }
            if (start1.nodes.size() > 0) {
                start1 = start1.nodes.get(0);
                start2 = start2.nodes.get(0);
            } else {
                start1 = null;
                start2 = null;
            }
        }

        start1 = database1;
        start2 = database2;
        TreeNode loadRoot1 = null, loadRoot2 = null;

        while (start1 != null && start2 != null) {
            if (start2.count >= (long) (start1.count * 1.05)) {
                loadRoot1 = start1;
                loadRoot2 = start2;
            }
            start1 = start1.parent;
            start2 = start2.parent;
        }

        sb.append("Possible causes are :");
        if( responseRoot1 != null ) {
            sb.append("Response time of " + responseRoot1.name + " increased from " + responseRoot1.responseTime + " to " + responseRoot2.responseTime + ";");
        }
        if( loadRoot1 != null ) {
            sb.append("Request count of " + loadRoot1.name + " increased from " + loadRoot1.count + " to " + loadRoot2.count + ";");
        }
        return sb.toString();
    }

    public String getSolution() {
        return "solution from bean";
    }

    private class TreeNode {
        private List<TreeNode> nodes = new LinkedList<>();

        public String name;

        public long responseTime;

        public int count;

        public TreeNode parent;

        public TreeNode(String name, long responseTime, int count) {
            this.name = name;
            this.responseTime = responseTime;
            this.count = count;
        }

        public void addChild(TreeNode child) {
            nodes.add(child);
            child.parent = this;
        }
    }

    public static void main(String[] args) {
        System.out.println( new DiagnoseBean().getCause() );
    }
}
