package prc.makedep;

import java.io.*;
import java.util.*;

public class MakedepChecker {
	private static class Node{
		private HashSet<String> deps = new HashSet<String>();
		private String full;
		
		public Node(String full, String sdeps) {
			this.full = full;
			String[] sdepsar = sdeps.split(" ");
			for(String s : sdepsar)
				if(!s.equals(""))
					deps.add(s);
		}
		
		public void compare(Node another){
			if(!(this.deps.containsAll(another.deps) && another.deps.containsAll(this.deps))){
				System.out.println("Differing lines:\n " + this.full + "\n " + another.full);
				if(!this.deps.containsAll(another.deps)){
					System.out.println("  Missing in olds:");
					HashSet<String> temp = another.deps;
					temp.removeAll(this.deps);
					for(String s : temp)
						System.out.println("   " + s);
				}
				if(!another.deps.containsAll(this.deps)){
					System.out.println("  Missing in news:");
					HashSet<String> temp = this.deps;
					temp.removeAll(another.deps);
					for(String s : temp)
						System.out.println("   " + s);
				}
			}
		}
	}
	
	
	public static void main(String[] args) throws Throwable{
		// Load old and new lists
		File odf = new File("oldmakedep.txt");
		File ndf = new File("newmakedep.txt");
		
		HashMap<String, Node> olds = new HashMap<String, Node>();
		HashMap<String, Node> news = new HashMap<String, Node>();
		
		Scanner scan = new Scanner(odf);
		while(scan.hasNextLine()){
			String s = scan.nextLine();
			if(s.equals(""))
				continue;
			String[] ss = s.split(":");
			olds.put(ss[0], new Node(s, ss[1]));
		}
		scan = new Scanner(ndf);
		while(scan.hasNextLine()){
			String s = scan.nextLine();
			if(s.equals(""))
				continue;
			String[] ss = s.split(":");
			news.put(ss[0], new Node(s, ss[1]));
		}
		
		if(!(olds.keySet().containsAll(news.keySet()) &&
			 news.keySet().containsAll(olds.keySet())
			 )){
			System.out.println("Differing line counts!");
			
			Set<String> foo = olds.keySet();
			foo.removeAll(news.keySet());
			System.out.println("Files not defined in news:");
			for(String s : foo)
				System.out.println(s);
			
			
			foo = news.keySet();
			foo.removeAll(olds.keySet());
			System.out.println("Files not defined in olds:");
			for(String s : foo)
				System.out.println(s);
		}
		
		for(String key : olds.keySet()){
			olds.get(key).compare(news.get(key));
		}
	}
}
