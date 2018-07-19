package main;

import java.util.ArrayList;
/**
 * USed to represent images. The values array contains the the result of mapping the features to the image.
 * It is a boolean array which says contains the result for each feature mapped to the image.
 * */
public class Image {
	
	private String category;
	private boolean[][] imgArray;
	private int[] values = new int[51];
	
	public Image(String c, boolean[][] i){
		this.category = c;
		this.imgArray = i;
	}


	public boolean[][] getImgArray() {
		return imgArray;
	}


	public String getCategory() {
		return category;
	}
	/**
	 * takes the features and maps them to the image finding the result of doing so and storing it in the values array.
	 * */
	public void findValues(ArrayList<Feature> feats){
		values[0] = 1;
		int j = 1;
		for(Feature feat : feats){
			int sum = 0;
			for(int i = 0; i < 4; i++){
				if(imgArray[feat.getRow(i)][feat.getCol(i)] == feat.getSign(i)) sum++;
			}
			values[j] = (sum>=3) ? 1:0;
			j++;
		}
	}
	
	public int getValue(int i){
		return values[i];
	}
	
	
}
