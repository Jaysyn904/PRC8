package prc.makedep;

import java.util.*;
import java.util.regex.*;


/** 
 * A class for parsing NWScript files.
 * 
 * @author Ornedan
 */
public class NWScript {
	private static enum STATES{
		/**
		 * Normal code, can switch to the other modes from here.
		 */
		NORMAL,
		/**
		 * String mode. Exited by an unescaped " (technically should be ended
		 * by a new line as well, but we assume the code is not that badly fubar'd).
		 */
		STRING,
		/**
		 * Singe line comment, started by //. Exited by a newline.
		 */
		SCOMMENT,
		/**
		 * Multi-line comment.
		 */
		MCOMMENT
	};
	
	private static Matcher matcher = Pattern.compile("#include[ \t\u000B\f\r]*\"(.*)\"").matcher("");

	
	/**
	 * Parses the given source text for #include directives and returns the names of
	 * the files included.
	 * 
	 * @param srcText contents of a nwscript source file
	 * @return array of String containing the names of files included by this one
	 */
	public static String[] findIncludes(CharSequence srcText){
		StringBuffer wip = new StringBuffer(srcText);
		ArrayList<String> list = new ArrayList<String>();
		
		removeComments(wip);
		
		// Parse for remaining #include statements
		//#include[ \t\x0B\f\r]*"(.*)"
		matcher.reset(wip);
		//String debug;
		while(matcher.find()){
			//debug = matcher.group(1);
			//list.add(debug);
			list.add(matcher.group(1));
		}
		
		
		return list.toArray(new String[0]);
	}
	
	/**
	 * Replaces the contents of comments with spaces.
	 * 
	 * @param sbuf Stringbuffer containing nwscript to strip comments from
	 */
	private static void removeComments(StringBuffer sbuf){
		STATES state = STATES.NORMAL;
		char prev = '\u0000', cur;
		boolean evenBSlash = true;
		
		for(int i = 0; i < sbuf.length(); i++){
			cur = sbuf.charAt(i);
			switch(state){
			case NORMAL:
				if(prev == '/'){
					if(cur == '/'){
						state = STATES.SCOMMENT;
						sbuf.setCharAt(i - 1, ' ');
						sbuf.setCharAt(i, ' ');
					}
					else if(cur == '*'){
						state = STATES.MCOMMENT;
						sbuf.setCharAt(i - 1, ' ');
						sbuf.setCharAt(i, ' ');
						
						// Null current so that /*/ won't get mistakenly detected as having closed
						cur = ' ';
					}
				}
				else if(cur == '\"')
					state = STATES.STRING;
				break;
			case STRING:
				if(cur == '\"'){
					if(evenBSlash)
						state = STATES.NORMAL;
				}
				else if(cur == '\\')
					evenBSlash = !evenBSlash;
				else
					evenBSlash = true;
				break;
			case SCOMMENT:
				if(cur == '\n')
					state = STATES.NORMAL;
				else
					sbuf.setCharAt(i, ' ');
				break;
			case MCOMMENT:
				if(prev == '*' && cur == '/')
					state = STATES.NORMAL;
				
				sbuf.setCharAt(i, ' ');
				break;
			}
			
			prev = cur;
		}
	}

	
	/**
	 * Test main
	 * @param args
	 */
	public static void main(String[] args) {
		findIncludes(
				"/**\n" +
				" * Mof! \" \"\n" +
				" */\n" +
				"#include \"test\"\n" +
				"#include \"tset\"\n" +
				"/*/  */\n"+
				"\n"+
				"void main()\n"+
				"{// Rar!\n"+
				"    florb(); /* call florb */\n"+
				"    /* another call */ florb();\n"+
				"}\n"
		);
	}
}
