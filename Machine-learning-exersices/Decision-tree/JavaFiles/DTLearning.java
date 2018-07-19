package main;

import java.util.ArrayList;
/**
 * This is the class for the learning algorithm.
 * */
public class DTLearning {
	
	private String result1;
	private String result2;
	private ArrayList<Attribute> attributes;
	private ArrayList<Instance> trainingData;
	private ArrayList<Instance> testData;
	private String baseline;					// This is the most common class in the data
	private double baseProb;					// This is the probability of the most common class
	private DT tree;
	public DTLearning (String r1, String r2, ArrayList<Attribute> a, ArrayList<Instance> tr, ArrayList<Instance> te){
		
		this.result1 = r1;
		this.result2 = r2;
		this.attributes = a;
		this.trainingData = tr;
		this.testData = te;
		findBaseline();
		
	}
	/**
	 * This is the method used to start the algorithm as well as:
	 * Print out the final tree
	 * Find and print the accuracy, number guessed wrong, the baseline class and baseline probability
	 * It can also print out all of the given and guessed class labels for each instance.
	 * */
	public void start(){
		
		tree = buildTree(trainingData, attributes);
		tree.report("");
		
		double wrong = 0;

		for(Instance i : testData){
			classify(i, tree);
			//System.out.println("Given: " + i.getResult() + ", Guessed: " + i.getGuessed());	//This line of code is used to print out the given class label and the guessed one
			if( !(i.getResult().equals(i.getGuessed())) ){wrong++;}
		}
		double total = trainingData.size() + testData.size();
		System.out.println("Guessed " + (total-wrong)+"/"+total + " correct");
		System.out.println("Accuracy: " + ( (total-wrong)/total ));
		System.out.println("Baseline Class: " + baseline + ", Baseline Probability: " + baseProb);
	}
	/**
	 * This is the method used to learn the decision tree. 
	 * */
	private DT buildTree(ArrayList<Instance> ints, ArrayList<Attribute> attr){
		
		if(ints.isEmpty()){
			return new Leaf(baseline, baseProb);
		}
		
		if(isPure(ints)){
			return new Leaf(ints.get(0).getResult(), 1.0);
		}
		
		if(attr.isEmpty()){
			return getMaj(ints);
		}
		
		int bestAtt = 100000;
		double bestPur = 10;
		ArrayList<Instance> bestTrueSet = null;
		ArrayList<Instance> bestFalseSet= null;
		
		for(Attribute at : attr){
			
			ArrayList<Instance> trueSet = findTrue(ints, at);
			ArrayList<Instance> falseSet = findFalse(ints, at);
			double truePurity = findPurity(trueSet, ints.size());
			double falsePurity = findPurity(falseSet, ints.size());
			double avPurity = truePurity + falsePurity;
			if(avPurity < bestPur){
				bestAtt = attr.indexOf(at);
				bestPur = avPurity;
				bestTrueSet = trueSet;
				bestFalseSet = falseSet;
			}
			
		}
		ArrayList<Attribute> remaining = slice(attr, attr.get(bestAtt));
		DT left = buildTree(bestTrueSet, remaining);
		DT right = buildTree(bestFalseSet, remaining);
		
		return new Node(attr.get(bestAtt), left, right);
	}
	/**
	 * This method is used to find the base class and its probability
	 * */
	private void findBaseline(){
		double r1 = 0;
		double r2 = 0;
		for(Instance i : trainingData){
			if(i.getResult().equals(result1)){r1++;}
			else{r2++;}
		}
		if(r1>r2){
			baseline = result1;
			baseProb = r1/(r1+r2);
			}
		else{
			baseline = result2;
			baseProb = r2/(r1+r2);
			}
	}
	/**
	 * Checks to see if a given list of instances is pure or not
	 * */
	private boolean isPure(ArrayList<Instance> ints){
		int r1 = 0;
		int r2 = 0;
		
		for(Instance i : ints){
			if(i.getResult().equals(result1)){r1++;}
			else{r2++;}
		}
		
		if((r1==0) || (r2==0)){return true;}
		return false;
		
	}
	/**
	 * Finds a the majority class label in a given list of instances or if they are equal, picks one at random.
	 * */
	private Leaf getMaj(ArrayList<Instance> ints){
		
		int r1 = 0;
		int r2 = 0;
		
		for(Instance i : ints){
			if(i.getResult().equals(result1)){r1++;}
			else{r2++;}
		}
		
		if(r1>r2){return new Leaf(result1, r1/(r1+r2));}
		else if(r2>r1){return new Leaf(result2, r2/(r1+r2));}
		else{
			if(Math.random()>= 0.5){return new Leaf(result1, 0.5);}
			return new Leaf(result2, 0.5);
		}
		
	}
	/**
	 * Takes a list of instances and an attribute and returns a new list which contains all the instances for which the given attribute
	 * is true. 
	 * */
	private ArrayList<Instance> findTrue(ArrayList<Instance> ints, Attribute attr){
		
		ArrayList<Instance> trueSet = new ArrayList<Instance>();
		
		for(Instance intsan : ints){
			for(Attribute a : intsan.getAttributes()){
				if(a.getAttr().equals(attr.getAttr())){
					if(a.getValue()){trueSet.add(intsan);}
				}
			}
		}
		
		return trueSet;
		
	}
	/**
	 * Takes a list of instances and an attribute and returns a new list which contains all the instances for which the given attribute
	 * is false. 
	 * */
	private ArrayList<Instance> findFalse(ArrayList<Instance> ints, Attribute attr){
		
		ArrayList<Instance> falseSet = new ArrayList<Instance>();
		
		for(Instance intsan : ints){
			for(Attribute a : intsan.getAttributes()){
				if(a.getAttr().equals(attr.getAttr())){
					if(!a.getValue()){falseSet.add(intsan);}
				}
			}
		}
		
		return falseSet;
		
	}
	/**
	 * Calculates the impurity measure on a list of instances using the P(A)P(B) measure.
	 * */
	private double findPurity(ArrayList<Instance> set, int t){
	
	double r1 = 0, r2 = 0, total = t, size = set.size();
	
	for(Instance instant : set){
		if(instant.getResult().equals(result1)){r1++;}
		else{r2++;}
	}
	return (size/total)*( (r1/size) * (r2/size) ) ;
	}

	/**
	 * Takes a list of attributes and an attribute and returns a new list which is the old list minus the given attribute
	 * */
	private ArrayList<Attribute> slice(ArrayList<Attribute> attr, Attribute at){
	ArrayList<Attribute> newList = new ArrayList<Attribute>();
	newList.addAll(attr);
	newList.remove(at);
	return newList;
	}

	private void classify(Instance i, DT node){
	
	if(node instanceof Leaf){
		i.setGuessed(((Leaf) node).getResult());
	}
	
	else if(node instanceof Node){
		Attribute at = ((Node) node).getAttribute();
		boolean value = false;
		for(Attribute attr : i.getAttributes()){
			if(attr.getAttr().equals(at.getAttr())){
				value = attr.getValue();
			}
		}
		if(value){classify(i, ((Node) node).getLeft());}
		else{classify(i, ((Node) node).getRight());}
	}

	}

}
