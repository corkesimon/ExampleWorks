package main;
/**
 * An attribute also contains the true/false value given for it, except in the list of known attribute
 * in which case the value is left null
 * */
public class Attribute {
	
	private String attr;
	private boolean value;
	
	public Attribute(String a){
		attr = a;
	}
	
	public String getAttr(){
		return attr;
	}

	public boolean getValue() {
		return value;
	}

	public void setValue(boolean v) {
		this.value = v;
	}

}
