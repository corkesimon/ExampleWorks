package main;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Scanner;
/**
 * This class is used to read the data files and construct lists for the instances as well as the attributes.
 * It also contains variable for the two classes.
 * */
public class Main {
	
	public static void main(String[] args){
		
		if(args.length != 2){
			System.err.println("Wrong argument(s)");
			System.err.println("traing-set test-set");
			System.exit(1);
		}
		
		String result1 = "";
		String result2 = "";
		
		ArrayList<Attribute> attributes = new ArrayList<Attribute>();
		ArrayList<Instance> trainingData = new ArrayList<Instance>();
		ArrayList<Instance> testData = new ArrayList<Instance>();
		
		try {
			FileInputStream fStream = new FileInputStream(args[0]);
			BufferedReader br = new BufferedReader(new InputStreamReader(fStream));
			String currentLine = br.readLine();
			Scanner sc = new Scanner(currentLine);
			result1 = sc.next();
			result2 = sc.next();
			sc.close();
			currentLine = br.readLine();
			sc = new Scanner(currentLine);
			while(sc.hasNext()){attributes.add(new Attribute(sc.next()));}
			sc.close();
			
			while ((currentLine = br.readLine())  != null){
				
				ArrayList<Attribute> attr = new ArrayList<Attribute>();
				for(Attribute att : attributes){
					Attribute a = new Attribute(att.getAttr());
					attr.add(a);
				}
				trainingData.add(new Instance(currentLine, attr));
				
			}
			
			br.close();
		}catch (FileNotFoundException e){
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			FileInputStream fStream = new FileInputStream(args[1]);
			BufferedReader br = new BufferedReader(new InputStreamReader(fStream));
			br.readLine();
			br.readLine();
			String currentLine;
			
			while ((currentLine = br.readLine())  != null){
				
				ArrayList<Attribute> attr = new ArrayList<Attribute>();
				for(Attribute att : attributes){
					Attribute a = new Attribute(att.getAttr());
					attr.add(a);
				}
				testData.add(new Instance(currentLine, attr));
				
			}
			
			br.close();
		}catch (FileNotFoundException e){
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		DTLearning algo = new DTLearning(result1, result2, attributes, trainingData, testData);
		algo.start();
	}

}
