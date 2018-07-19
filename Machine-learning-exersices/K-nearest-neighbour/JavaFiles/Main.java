package main;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class Main {
	/**
	 * This is the method I used for reading the txt files and converting them into
	 * arraylists of iris's.It makes the lists of training and test instances then creates a
	 * new kNear algorithm with them.
	 * 
	 */
	public static void main(String[] args){
		
		ArrayList<Iris> trainingSet = new ArrayList<Iris>();
		ArrayList<Iris> testSet = new ArrayList<Iris>();
		
		if(args.length != 3){
			System.err.println("Wrong argument(s)");
			System.err.println("iris-taining.txt iris-test.txt k");
			System.exit(1);
		}
		
		try {
			FileInputStream fStream = new FileInputStream(args[0]);
			BufferedReader br = new BufferedReader(new InputStreamReader(fStream));
			String currentLine;
			while ((currentLine = br.readLine())  != null){
				if(currentLine.length() > 16)trainingSet.add(new Iris(currentLine,0)); // I had a weird bug where the last line was being
																					   // read as a line and returning a an Iris object 
			}																		   // with null for all its parameters.
			br.close();																   // 16 was just a random number I picked to check that 
		}catch (FileNotFoundException e){											   // the line was a proper line of data.
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			FileInputStream fStream = new FileInputStream(args[1]);
			BufferedReader br = new BufferedReader(new InputStreamReader(fStream));
			String currentLine;
			while ((currentLine = br.readLine())  != null){
				if(currentLine.length() > 16)testSet.add(new Iris(currentLine, 1));   // See above comments.
			}
			br.close();
		}catch (FileNotFoundException e){
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		int k = Integer.parseInt(args[2]);
		kNear algo = new kNear(trainingSet, testSet, k);
		algo.start();
		int wrong = 0;
		for(Iris iris : testSet){
			iris.printResults();
			if( !( iris.getGivenType().equals(iris.getGuessedType()) ) ){wrong++;}
		}
		double w = wrong;
		double accuracy =1 -  (w/testSet.size());
		System.out.println("Wrong: " + wrong + ",  Accuracy: " + accuracy);
		
	} 
}
