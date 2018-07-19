package main;
/**
 * Used to represent a feature. Contains the pixels and their randomly generated boolean values.
 * */
public class Feature {
	
	private int row[];
	private int col[];
	private boolean sign[];
	
	public Feature(int[] r, int[] c, boolean[] s){
		row = r;
		col = c;
		sign = s;
	}
	
	public int getRow(int i) {
		return row[i];
	}
	
	public int getCol(int i) {
		return col[i];
	}
	
	public boolean getSign(int i) {
		return sign[i];
	}
	
	public void print(){
		System.out.print("row = {" +row[0]+", "+row[1]+", "+row[2]+", "+row[3]+"}");
		System.out.print("| col = {"+col[0]+", "+col[1]+", "+col[2]+", "+col[3]+"}");
		System.out.print("| signs = {"+sign[0]+", "+sign[1]+", "+sign[2]+", "+sign[3]+"}\n");
	}

}
