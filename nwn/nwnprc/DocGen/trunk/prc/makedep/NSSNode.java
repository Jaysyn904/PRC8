package prc.makedep;

import java.io.*;
import java.util.*;

import static prc.Main.*;

/**
 * A node in an NWScript include tree.
 * 
 * @author Ornedan
 */
public class NSSNode {
	private static enum STATES{
		/**
		 * This node has not been visited yet in the full linking phase.
		 */
		UNSTARTED,
		/**
		 * The depth-first-search has reached this node, but has not returned to it yet.
		 */
		WORKING,
		/**
		 * All the includes for this node have been resolved.
		 */
		DONE};
	
	private STATES state = STATES.UNSTARTED;
	
	/**
	 * While the node is in WORKING state, it's includes have not been resolved yet.
	 * So, if a circular include is found, it is added here so that this node's includes
	 * can be added to it's list once the DFS returns to this node.
	 */
	private HashSet<NSSNode> mergeLater = new HashSet<NSSNode>();
	
	/**
	 * A container for marking files that are already being handled during a merging cascade.
	 */
	private static HashSet<NSSNode> inMerge;
	
	/**
	 * The nodes included directly by this node via #include statements.
	 */
	private HashSet<NSSNode> adjenct = new LinkedHashSet<NSSNode>();
	
	/**
	 * The nodes included by this node either directly or via intermediary steps. Also,
	 * each file is considered to include itself in order to make printing include lists
	 * a bit less complex.
	 */
	private HashSet<NSSNode> includes = new LinkedHashSet<NSSNode>();
	
	/**
	 * The first node to call linkFullyAndGetIncludes() on this node.
	 */
	public NSSNode priCaller;
	
	/**
	 * The path used to reference this file.
	 */
	public String fileName;
	
	/**
	 * Creates a new, unlinked NSSNode
	 * 
	 * @param fileName
	 */
	public NSSNode(String fileName) {
		fileName = fileName.toLowerCase();
		// Make sure the file exists
		if(!new File(fileName).exists()){
			Main.error = true;
			err_pr.println("Error: Missing script file: " + fileName);
			return;
		}
		
		// Each node is dependent on itself
		includes.add(this);
		
		this.fileName = fileName;
	}
	
	/**
	 * Link this script file to those files it directly includes.
	 */
	public void linkDirect(){
		// Load the text for this file
		File file = new File(fileName);
		char[] cArray = new char[(int)file.length()];
		try{
			FileReader fr = new FileReader(fileName);
			fr.read(cArray);
			fr.close();
		}catch(Exception e){
			err_pr.println("Error: Error while reading file: " + fileName);
			Main.error = true;
			return;
		}
		
		/* Debuggage
		if(fileName.indexOf("psi_inc_psifunc") != -1)
			System.currentTimeMillis();
		//*/
			
		
		String[] directIncludes = NWScript.findIncludes(new String(cArray));
		
		for(String name : directIncludes){
			name = name.toLowerCase();
			NSSNode adj = Main.scripts.get(name);
			if(adj != null){
				if(adjenct.contains(adj))
					//System.out.println("Warning: " + getScriptName(fileName) +  " includes " + getScriptName(adj.fileName) + " multiple times");
					System.out.printf("Warning: %-16s includes %-16s multiple times\n",
							getScriptName(fileName),
							getScriptName(adj.fileName)
							);
				adjenct.add(adj);
			}else if(!Main.ignoreMissing){
				System.out.println("Script file not found: " + name);
				Main.error = true;
			}
		}
	}

	/**
	 * Builds the full list of files included by this script.
	 * 
	 * @param caller the node calling this function recursively passes a reference
	 *                to itself. Used in cases where the target node was already in
	 *                WORKING state.
	 * @return       HashSet containing the fully resolved list of files included by this one
	 */
	public HashSet<NSSNode> linkFullyAndGetIncludes(NSSNode caller) {
		if(state != STATES.UNSTARTED)
			if(state == STATES.DONE)
				return includes;
			else{
				// Add to a list to merge include lists later once this node is done
				NSSNode toMergeLater = caller;
				while(toMergeLater != this){
					mergeLater.add(toMergeLater);
					toMergeLater = toMergeLater.priCaller;
				}
				return null;
			}
		/* Debuggage stuff
		if(//fileName.indexOf("ss_ep_psionicsal") != -1 ||
		   //fileName.indexOf("psi_inc_psifunc")  != -1 ||
		   //fileName.indexOf("prc_alterations")  != -1 ||
		   //fileName.indexOf("bonsum_shapelem")  != -1 ||
		   fileName.indexOf("pnp_shft_poly")  != -1 ||
		   false
		   )
			System.currentTimeMillis();
			//*/	
		// Mark the node as work-in-progress, so it won't be handled again
		state = STATES.WORKING;
		priCaller = caller;
		// Initialize the includes list for this script with the direct includes
		includes.addAll(adjenct);
		
		HashSet<NSSNode> temp;
		for(NSSNode adj : adjenct){
			temp = adj.linkFullyAndGetIncludes(this);
			if(temp != null)
				includes.addAll(temp);
		}
		
		// Do the delayed include list merges
		inMerge = new HashSet<NSSNode>();
		this.doMerge();
		/*for(NSSNode node : mergeLater)
			node.includes.addAll(this.includes);*/
		inMerge = null;
		
		state = STATES.DONE;
		return includes;
	}
	
	/**
	 * Merges the include list of this file with all files that included this one while
	 * it was still being worked on. Recurses to each of these files in order to update
	 * files dependent on them.
	 */
	private void doMerge(){
		for(NSSNode node : mergeLater){
			if(!inMerge.contains(node)){
				inMerge.add(node);
				node.includes.addAll(this.includes);
				node.doMerge();
			}
		}
	}
	
	/**
	 * Gets the name used in include statements for the given filename.
	 * 
	 * @param path the path to parse
	 * @return     string, name used in include statements
	 */
	public static String getScriptName(String path) {
		// Cut out the .nss or .ncs
		try{
		path = path.substring(0, path.indexOf(".nss") != -1 ? path.indexOf(".nss") : path.indexOf(".ncs"));
		}catch(Exception e){
			err_pr.println(path);
		}
		
		// Cut out the directories, if present
		if(path.indexOf(File.separator) != -1)
			path = path.substring(path.lastIndexOf(File.separator) + 1, path.length());
		
		return path;
	}
	
	/**
	 * Prints this node's list of includes to a stream.
	 * 
	 * @param strm   stream to print to
	 * @param append if this is <code>true</code>, the PrintStream's <code>append</code> methods
	 *                are used instead of <code>print</code> methods.
	 * @param target name of the object file to be built from this script
	 */
	public void printSelf(PrintStream strm, boolean append, String target) {
		String lineSeparator = System.getProperty("line.separator");
		if(append){
			//strm.append(fileName.replace(".nss", ".ncs") + ":"/* + fileName*/);
			strm.append(target + ":");
			for(NSSNode include : includes)
				strm.append(" " + include.fileName);
			strm.append(lineSeparator + lineSeparator);
		}else{
			strm.print(target + ":");
			for(NSSNode include : includes)
				strm.print(" " + include.fileName);
			strm.print(lineSeparator + lineSeparator);
		}
	}
	
	/**
	 * A test main.
	 * 
	 * @param args Ye olde parameters. Doesn't accept any
	 */
	public static void main(String[] args){
		System.out.println(getScriptName("C:\\foo\\bar\\meh.nss"));
		System.out.println(getScriptName("boo.nss"));
		System.out.println(getScriptName("lar\\floob.nss"));
	}
	
	/**
	 * An NSSNode's string representation is it's filename.
	 * 
	 * @see java.lang.Object#toString()
	 */
	public String toString(){return fileName;}
}
