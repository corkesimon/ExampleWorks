package main;
/**
 * A non-leaf node in the decision tree.
 * */
public class Node implements DT{
	
	private Attribute attribute;
	private DT left;
	private DT right;
	
	public Node(Attribute a, DT l, DT r){
		this.attribute = a;
		this.left = l;
		this.right = r;
	}

	public Attribute getAttribute() {
		return attribute;
	}

	public DT getLeft() {
		return left;
	}

	public DT getRight() {
		return right;
	}
	
	public void report(String indent){
		System.out.println(indent + attribute.getAttr() + " = True:");
		left.report(indent + "\t");
		System.out.println(indent + attribute.getAttr() + " = False:");
		right.report(indent + "\t");
	}
	
	

}
