package tools.print.rest;

public class RestEntity 
{
	public static final int ENTITY_KEY 	= 0;
	public static final int ENTITY_INDEX 	= 1;
	public static final int ENTITY_RANGE 	= 2;
	public static final int ENTITY_LIST 	= 3;
	
	private int type = -1;
	private String keyvalue = "";
	private int start = -1;
	private int end = -1;
	private int index = -1;
	private int[] list = null;
	
	public int getEnd() {
		return end;
	}
	public void setEnd(int end) {
		this.end = end;
	}
	public int getIndex() {
		return index;
	}
	public void setIndex(int index) {
		this.index = index;
	}
	public String getKeyvalue() {
		return keyvalue;
	}
	public void setKeyvalue(String keyvalue) {
		this.keyvalue = keyvalue;
	}
	public int[] getList() {
		return list;
	}
	public void setList(int[] list) {
		this.list = list;
	}
	public int getStart() {
		return start;
	}
	public void setStart(int start) {
		this.start = start;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	
	
}
