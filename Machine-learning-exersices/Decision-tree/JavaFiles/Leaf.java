package main;
/**
 * A leaf node in the decision tree.
 * */
public class Leaf implements DT{
	
	private String result;
	private double prob;
	
	public Leaf(String r, double p){
		this.result = r;
		this.prob = p;
	}

	public String getResult() {
		return result;
	}

	public double getProb() {
		return prob;
	}
	
	public void report(String indent){
		System.out.println(indent + "Class = " + result +", prob = " + prob);
	}



}
