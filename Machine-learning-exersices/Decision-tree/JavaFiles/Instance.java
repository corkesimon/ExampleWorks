package main;

/**
 * An Instance contains all the data for a given instance. The result field is the class given class label
 * and the guessed field is the one predicted by the decision tree. The attributes list contains all the values for the attributes.
 * */
import java.util.ArrayList;
import java.util.Scanner;

public class Instance {
	
	private String result;
	private ArrayList<Attribute> attributes;
	private String guessed = "Unguessed";
	
	public Instance(String line, ArrayList<Attribute> attr){
		attributes = attr;
		Scanner sc = new Scanner(line);
		result = sc.next();
		int i = 0;
		while(sc.hasNext()){
			attributes.get(i).setValue(sc.nextBoolean());
			i++;
		}
		sc.close();
	}

	public String getResult() {
		return result;
	}
	
	public ArrayList<Attribute> getAttributes(){
		return attributes;
	}
	
	public void print(){
		System.out.print(result + "\t");
		for(Attribute attr : attributes){
			System.out.print(attr.getValue()+ "\t");
		}
		System.out.println();
	}

	public String getGuessed() {
		return guessed;
	}

	public void setGuessed(String guessed) {
		this.guessed = guessed;
	}

}
