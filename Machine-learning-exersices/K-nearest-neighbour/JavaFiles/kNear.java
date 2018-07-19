package main;

import java.util.ArrayList;

public class kNear {

	private ArrayList<Iris> trainingSet;
	private ArrayList<Iris> testSet;
	private ArrayList<Iris> nieghbours;
	private int k = 1;
	/**
	 * These are all the values for the ranges for each parameter, the min max and range.
	 * */
	private double lowSepalL = 1000;
	private double highSepalL = -1;
	private double rangeSepalL = 0;
	
	private double lowSepalW = 1000;
	private double highSepalW = -1;
	private double rangeSepalW = 0;
	
	private double lowPetalL = 1000;
	private double highPetalL = -1;
	private double rangePetalL = 0;
	
	private double lowPetalW = 1000;
	private double highPetalW = -1;
	private double rangePetalW = 0;


	public kNear(ArrayList<Iris> train, ArrayList<Iris> test, int i) {
		this.trainingSet = train;
		this.testSet = test;
		this.k = i;
	}
	
	public void start(){
		getRanges();
		for(Iris iris : testSet){
			getNieghbours(iris);
			getNearest(iris);
		}
	}
	
	
	/**
	 * This method finds all the ranges in the training set
	 * */
	private void getRanges(){
		for(Iris iris : trainingSet){
			
			if(iris.getSepalL()<lowSepalL)lowSepalL = iris.getSepalL();
			if(iris.getSepalL()>highSepalL)highSepalL = iris.getSepalL();
			rangeSepalL = highSepalL - lowSepalL;
			
			if(iris.getSepalW()<lowSepalW)lowSepalW = iris.getSepalW();
			if(iris.getSepalW()>highSepalW)highSepalW = iris.getSepalW();
			rangeSepalW = highSepalW - lowSepalW;
			
			if(iris.getPetalL()<lowPetalL)lowPetalL = iris.getPetalL();
			if(iris.getPetalL()>highPetalL)highPetalL = iris.getPetalL();
			rangePetalL = highPetalL - lowPetalL;
			
			if(iris.getPetalW()<lowPetalW)lowPetalW = iris.getPetalW();
			if(iris.getPetalW()>highPetalW)highPetalW = iris.getPetalW();
			rangePetalW = highPetalW - lowPetalW;
		}
	}
	/**
	 * This s the method used to find the k nearest neighbors for a given test instance.
	 * For each instance in the test data it creates a copy of the training set.
	 * It then goes through the temporary list and finds the nearest neighbor.
	 * When it finds the nearest neighbor it adds it to the neighbors list and removes it from the temporary list.
	 * It repeats this until it finds the k nearest neighbors.
	 * */
	private void getNieghbours(Iris testIris){
		nieghbours = new ArrayList<Iris>();
		ArrayList<Iris> temp = new ArrayList<Iris>();
		temp.addAll(trainingSet);
		for(int i = 0; i < k; i++){
			double minDist = 1000;
			int minIris = 0;
			for(int j= 0; j < temp.size(); j++){
				double dist = getDist(testIris, temp.get(j));
				if(dist < minDist){
					minDist = dist;
					minIris = j;
				}
			}
			nieghbours.add(temp.get(minIris));
			temp.remove(minIris);
		}
	}
	/**
	 * This is the method used to find the distance between two instances.
	 * It uses ranges to normalize the data. It also updates the ranges for each new test instance.
	 * */
	private double getDist(Iris testIris, Iris tempIris){
		if(testIris.getSepalL()<lowSepalL)lowSepalL = testIris.getSepalL();
		if(testIris.getSepalL()>highSepalL)highSepalL = testIris.getSepalL();
		rangeSepalL = highSepalL - lowSepalL;
		double w = ( Math.pow(testIris.getSepalL() - tempIris.getSepalL(), 2) ) / ( Math.pow(rangeSepalL, 2) );
		
		if(testIris.getSepalW() < lowSepalW)lowSepalW = testIris.getSepalW();
		if(testIris.getSepalW() > highSepalW)highSepalW = testIris.getSepalW();
		rangeSepalW = highSepalW - lowSepalW;
		double x = ( Math.pow(testIris.getSepalW() - tempIris.getSepalW(), 2) ) / ( Math.pow(rangeSepalW, 2));
		
		if(testIris.getPetalL() < lowPetalL)lowPetalL = testIris.getPetalL();
		if(testIris.getPetalL() > highPetalL)highPetalL = testIris.getPetalL();
		rangePetalL = highPetalL - lowPetalL;
		double y = ( Math.pow(testIris.getPetalL() - tempIris.getPetalL(), 2) ) / ( Math.pow(rangePetalL, 2));
		
		if(testIris.getPetalW() < lowPetalW)lowPetalW = testIris.getPetalW();
		if(testIris.getPetalW() > highPetalW)highPetalW = testIris.getPetalW();
		rangePetalW = highPetalW - lowPetalW;
		double z = ( Math.pow(testIris.getPetalW() - tempIris.getPetalW(), 2) ) / ( Math.pow(rangePetalW, 2));
		
		double dist = Math.sqrt(w+x+y+z);
		
		return dist;
	}
	/**
	 * This method finds the majority class for all the instances in the neighbor list.
	 * If their is a tie then it picks the one which is closest and uses its class.
	 * */
	private void getNearest(Iris iris){
		int setosa = 0;
		int versicolor = 0;
		int virginica = 0;
		
		for(Iris nieghbour : nieghbours){
			if(nieghbour.getGivenType().equals("Iris-setosa")) setosa++;
			else if(nieghbour.getGivenType().equals("Iris-versicolor")) versicolor++;
			else virginica++;
		}
		
		if((setosa > versicolor) && (setosa > virginica)){iris.guessType("Iris-setosa");}
		else if((versicolor > setosa) && (versicolor > virginica)){iris.guessType("Iris-versicolor");}
		else if((virginica > setosa) && (virginica > versicolor)){iris.guessType("Iris-virginica");}
		else {iris.guessType(nieghbours.get(0).getGivenType());}
	}

}
