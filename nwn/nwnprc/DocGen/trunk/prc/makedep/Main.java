/**
 * A system for calculating nwscript dependencies. Makes some assumptions specific
 * to the PRC setup.
 */
package prc.makedep;

import java.util.*;
import java.io.*;

import static prc.Main.*;


/**
 * Calculates nwscript dependencies.
 * 
 * Usage:   makedep [-aio?] targetlist
 * Options:
 * -a                Append to outputfile. This option must be defined before -o
 * -n                Ignore include file if not found
 * -sPATH[,PATH...]  List of source directories
 * -oFILE            Use FILE as outputfile, stdout assumed
 * -?, --help        This text
 * 
 * 
 * @author Ornedan
 */
public class Main {

	static Map<String, NSSNode> scripts = new LinkedHashMap<String, NSSNode>();
	
	protected static boolean append = false,
	                         ignoreMissing = false,
	                         error = false;
	static PrintStream oStrm = System.out; 
	
	/**
	 * Main method. Entrypoint to the program
	 * 
	 * @param args The arguments. See readMe() for accepted ones
	 */
	public static void main(String[] args) {
		HashMap<String, String> targetList = new LinkedHashMap<String, String>();
		List<String> targetListFileNames = new ArrayList<String>();
		boolean targetsFromStdin = false;
		
		// Parse arguments
		for(int i = 0; i < args.length; i++) {//[-aio?] targetslist+
			// Parameter parseage
			String param = args[i];
			if(param.startsWith("-")) {
				if(param.startsWith("-s")) {
					getFiles(param.substring(2));
				}
				else if(param.startsWith("-o")) {
					setOutput(param.substring(2));
				}
				else {
					if(param.equals("--help")) readMe();
					else if(param.equals("-")) {
						targetsFromStdin = true;
					}
					else {
						for(char c : param.substring(1).toCharArray()){
							switch(c) {
							case 'a':
								append = true;
								break;
							case 'n':
								ignoreMissing = true;
								break;
							
							default:
								System.out.println("Unknown parameter: " + c);
							case '?':
								readMe();
							}
						}
					}
				}
			}
			else {
				// It's a targets list file
				targetListFileNames.add(param);
			}
		}
		
		// Read targets from stdin if so specified
		Scanner scan;
		String targetName;
		if(targetsFromStdin) {
			scan = new Scanner(System.in);
			while(scan.hasNextLine()) {
				targetName = scan.nextLine().toLowerCase();
				// Strip everything after the .ncs from the line
				targetName = targetName.substring(0, targetName.indexOf(".ncs") + 4);
				targetList.put(NSSNode.getScriptName(targetName), targetName);
			}
		}
		
		// Parse the target file list
		File targetListFile;
		for(String fileName : targetListFileNames) {
			targetListFile = new File(fileName);
			// Read the contents
			try {
				scan = new Scanner(targetListFile);
			} catch (FileNotFoundException e) {
				err_pr.println("Error: Could not find file: " + fileName);
				error = true;
				continue;
			}
			
			while(scan.hasNextLine()) {
				targetName = scan.nextLine().toLowerCase();
				// Strip everything after the .ncs from the line
				targetName = targetName.substring(0, targetName.indexOf(".ncs") + 4);
				targetList.put(NSSNode.getScriptName(targetName), targetName);
			}
		}
		
		// Input sanity checks
		if(targetList.size() == 0) {
			err_pr.println("Error: No targets specified.");
			error = true;
		}
		for(String target : targetList.keySet()) {
			if(scripts.get(target.toLowerCase()) == null) {
				err_pr.println("Error: Script file for target " + target + " not found in given source directories.");
				error = true;
			}
		}
		
		// Terminate if errored
		if(error) System.exit(1);
		
		// TODO: Load the files concurrently. I suspect it will give a slight performance boost
		//NSSNode[] debugArr = debugMap.values().toArray(new NSSNode[0]);
		for(NSSNode script: scripts.values())
			script.linkDirect();
		
		// Check for errors again
		if(error) System.exit(1);
		
		
		// Start a depth-first-search to find all the include trees
		for(NSSNode node : scripts.values()){
			node.linkFullyAndGetIncludes(null);
			//node.printSelf(oStrm, append);
		}
		
		// Do the printing
		for(String target : targetList.keySet()) {
			scripts.get(target.toLowerCase()).printSelf(oStrm, append, targetList.get(target));
		}
	}
	
	/**
	 * Prints usage and terminates.
	 */
	private static void readMe() {
		//					0        1         2         3         4         5         6         7         8
		//					12345678901234567890123456789012345678901234567890123456789012345678901234567890
		System.out.println("Usage:   makedep [-aio?] targetslist+\n" +
				           "Options:\n" +
				           "-a                Append to outputfile. This option must be defined before -o\n"+
				           "-n                Ignore include file if not found\n"+
				           "-sPATH[,PATH...]  List of source directories\n"+
				           "-oFILE            Use FILE as outputfile, stdout assumed\n" +
				           "-                 Read targets from stdin. Same format as targets list files\n"+
				           "-?, --help        This text\n"+
				           "\n"+
				           "targetslist       Name of a file containing a list of object (.ncs) files to\n"+
				           "                  generate a make targets for.\n" +
				           "                  File format is one path-to-target per line."
				           );
		System.exit(0);
	}
	
	/**
	 * Looks in the directories specified by the given list for .nss
	 * files and adds them to the sources list.
	 * 
	 * @param pathList comma-separated list of directories to look in
	 */
	private static void getFiles(String pathList){
		String[] paths = pathList.split(",");
		File[] files;
		String temp;
		for(String path : paths){
			files = new File(path).listFiles(new FileFilter(){
				public boolean accept(File file){
					return file.getName().endsWith(".nss");
				}
			});
			for(File file: files){
				temp = NSSNode.getScriptName(file.getName()).toLowerCase();
				if(!scripts.containsKey(temp))
					scripts.put(temp, new NSSNode(file.getPath()));
				else{
					err_pr.println("Error: Duplicate script file: " + temp);
					error = true;
				}
			}
		}
	}
	
	/**
	 * Sets the output to write the results to to a file specified by the
	 * given filename.
	 * If the file is not found, the program terminates.
	 * 
	 * @param outFileName Name of the file to print results to
	 */
	private static void setOutput(String outFileName){
		try{
			oStrm = new PrintStream(new FileOutputStream(outFileName, append), true);
		}catch(FileNotFoundException e){
			err_pr.println("Error: Missing output file " + outFileName + "\nTerminating!");
			System.exit(1);
		}
	}
}
