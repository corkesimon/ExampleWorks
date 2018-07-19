package main;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;
/**
 * This class used to, read the file, create and start the algorithm.
 * There is also a test method which creates n perceptrons and finds the average cut-off value and
 * accuracy. n is set to 100 as default
 * */
public class Main {
	
	public static void main(String[] args){
		
		ArrayList<Image> images = new ArrayList<Image>();
		
		
		try {
			java.util.regex.Pattern bit = java.util.regex.Pattern.compile("[01]");
			Scanner f = new Scanner(new File(args[0]));
			while(f.hasNextLine()){
				
				String n =f.nextLine();
				
				String category = f.next().substring(1);
				
				
				int rows = Integer.parseInt(f.next());
				int col = Integer.parseInt(f.next());
				
				boolean[][] img = new boolean[rows][col];
				for(int r = 0; r < rows; r++){
					for(int c = 0; c < col; c++){
						img[r][c] = (f.findWithinHorizon(bit,0).equals("1"));
					}
				}
				
				images.add(new Image(category, img));
				if(f.hasNextLine()){f.nextLine();}
			}
			
			f.close();
		}catch (FileNotFoundException e){
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		Perceptron algo = new Perceptron(images);
		algo.start();
		
		//test(images);
		
	}
	/**
	 * This method is used to create n perceptrons and find the average accuracy and cut-off values. 
	 * */
	
	public static void test(ArrayList<Image> img){
		
		double avCutoff = 0;
		double avAcc = 0 ;
		double adjCut = 0;
		int n = 100;
		for(int i = 0; i < n; i++){
			Perceptron p = new Perceptron(img);
			p.start();
			avCutoff = avCutoff + p.cuttoff;
			avAcc = avAcc + p.Acc;
			if(p.cuttoff < 1000){adjCut = adjCut + p.cuttoff;}
		}
		System.out.println("Average cut-off of all runs: " + (avCutoff/n));
		System.out.println("Average accuracy: " + (avAcc/n));
		System.out.println("Average accuracy of successful runs: " + (adjCut/n));
	}
	
	


}
