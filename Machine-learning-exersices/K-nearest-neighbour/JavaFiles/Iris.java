package main;

import java.util.Scanner;
/**
 * The Iris class is used to represent the instances. It has the values of the data as well as
 * a field for the actual class and one for the class chosen by the algorithm.
 * */
public class Iris {
	
	private double sepalL;
	private double sepalW;
	private double petalL;
	private double petalW;
	private String givenType;
	private String guessedType;

	public Iris(String info, int t){

		Scanner sc = new Scanner(info);
		if(sc.hasNext()){this.sepalL = Double.parseDouble(sc.next());}
		if(sc.hasNext()){this.sepalW = Double.parseDouble(sc.next());}
		if(sc.hasNext()){this.petalL = Double.parseDouble(sc.next());}
		if(sc.hasNext()){this.petalW = Double.parseDouble(sc.next());}
		if(sc.hasNext()){this.givenType = sc.next();}
		sc.close();
		if(t==1)guessedType = "unguessed";
		else{guessedType = "This is from training-set.txt";}
	}
	
	public void printInfo(){
		System.out.println(this.sepalL + " " + this.sepalW + " " + this.petalL + " " + this.petalW +" " + this.givenType + " " + this.guessedType);
	}

	public double getSepalL() {
		return sepalL;
	}

	public double getSepalW() {
		return sepalW;
	}

	public double getPetalL() {
		return petalL;
	}

	public double getPetalW() {
		return petalW;
	}

	public String getGivenType() {
		return givenType;
	}
	
	public String getGuessedType() {
		return guessedType;
	}
	
	public void guessType(String type){
		guessedType = type;
	}
	
	public void printResults(){
		System.out.println("Given: " + givenType + ", Guessed: " + guessedType);
	}
}
