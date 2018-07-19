package main;

import java.util.ArrayList;
import java.util.Random;
/**
 * The images field is the list of images
 * features contains the 50 randomly generated features
 * weights[0] is the threshold weight
 * cuttoff is the number of times the perceptron had to go through the data
 * wrong is the number of images still guessed wrong when the percptron has finished learning
 * Acc is the accuracy of the percptron
 * */
public class Perceptron {
	
	private ArrayList<Image> images;
	private ArrayList<Feature> features = new ArrayList<Feature>();
	private double[] weights = new double[51];
	private Random random = new Random();
	int cuttoff = 0;
	int wrong = 1;
	double Acc = 0;
	
	
	public Perceptron(ArrayList<Image> i){
		this.images = i;
	}
	/***
	 * generates all the features and the weights then continues to train the perceptron until either all the training
	 * examples are correctly guessed or the cuttoff is reached
	 */
	public void start(){
		createFeatures();
		setWeights();
				
		while((cuttoff < 1000) && (wrong !=0)){
			wrong = train();
			cuttoff++;
		}
		double w = wrong;
		Acc = 1 - w/images.size();
		print();
		
	}
	/**
	 * creates 50 randomly generated features then process the features for each image
	 * */
	public void createFeatures(){
		for(int i = 0; i < 50; i++){
			int[] row = {random.nextInt(10), random.nextInt(10), random.nextInt(10), random.nextInt(10)};
			int[] col = {random.nextInt(10), random.nextInt(10), random.nextInt(10), random.nextInt(10)};
			boolean[] sign = {random.nextBoolean(), random.nextBoolean(), random.nextBoolean(), random.nextBoolean()};
			features.add(new Feature(row, col, sign));
		}
		
		for(Image img : images){img.findValues(features);}
	}
	/**
	 * creates the randomly generated weights
	 * */
	private void setWeights() {
		for(int i = 0; i < 51; i++){
			if(random.nextDouble() >= 0.5){weights[i] = -random.nextDouble();}
			else{ weights[i] = random.nextDouble();}
		}
	}
	/**
	 * This is a simgle pass through of the data, this method is called multiple time by the start() method.
	 * Goes through each of the images, compares the given image class to the predicted one and adjusts the weights accordingly.
	 * */
	public int train(){
		int wrong = 0;
		for(Image img : images){
			double sum = 0;
			for(int i = 0; i < 51; i++){
				sum = sum + weights[i]*img.getValue(i);
			}
			if( (sum > 0) && (img.getCategory().equals("other")) ){
				subtract(img);
				wrong++;
			}
			else if( (sum < 0 ) && (img.getCategory().equals("Yes")) ){
				
				add(img);
				wrong++;
			}
			else if(sum==0){
				
				wrong++;
				}
		}
		return wrong;
	}
	/**
	 * Used to subtract the feature values from the weights
	 * */
	public void subtract(Image img){
		for(int i = 0; i < 51; i++){
			weights[i] = weights[i] - img.getValue(i);
		}
	}
	/**
	 * Used to add the feature values from the weights
	 * */
	public void add(Image img){
		for(int i = 0; i < 51; i++){
			weights[i] = weights[i] + img.getValue(i);
		}
	}
	/**
	 * Prints info about the algorithm such as:
	 * The feature generated
	 * the cuttoff value reached
	 * the accuracy of the final perceptron
	 * */
	public void print(){
		System.out.println("Features Generated:");
		for(Feature feat : features){feat.print();}
		System.out.println("Final weights:");
		for(int i = 0; i < 51; i++){
			System.out.println("w(" +i+ "): "+weights[i]);
		}
		System.out.println("Reached cut-off value of: " +cuttoff);
		
		System.out.println("Guessed "+wrong +" incorrectly," + " Accuracy = "+ Acc );
	}

}
