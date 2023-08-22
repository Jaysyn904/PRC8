package prc.utils;

import prc.autodoc.*;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Random;

public final class NPCEvolve {
    private NPCEvolve() {
    }

    private static final int countAreas = 5;
    private static final int countClasses = 11;
    private static final int countPackages = 10;
    public static Random rng = new Random();

    /**
     * The main method, as usual.
     *
     * @param args do I really need to explain this?
     * @throws Exception this is a simple tool, just let all failures blow up
     */
    public static void main(String[] args) throws Exception {
        if (args.length < 3 || args[0].equals("--help") || args[0].equals("-?"))
            readMe();

        String logFilePath = args[0];
        String packageFilePath = args[1];
        String outputFilePath = args[2];

        //this is the layout of the data string
        //## id class0pack1 class0pack2 ... class10pack9 class10pack10 ##
        //get the file
        File logFile = new File(logFilePath);
        BufferedReader reader = new BufferedReader(new FileReader(logFile));
        //parse it
        String line = reader.readLine();
        int[][][] dataset = new int[countAreas][countClasses][countPackages];
        int classID = 0;
        int packageID = 0;
        int areaID = 0;
        int score = 0;
        int countArea = 0;
        while (line != null) {
            if (line.matches("## ([0-9]*) [0-9 ]* ##")) {
                areaID = new Integer(line.substring(4, 6));
                //remove the +1 offset
                areaID--;
                //store highest area value
                if (areaID > countArea)
                    countArea = areaID;
                classID = 0;
                packageID = 0;
                line = line.substring(7, line.length() - 3);
                String[] splitline = line.split(" ");
                for (int i = 0; i < splitline.length; i++) {
                    score = new Integer(splitline[i]);
                    dataset[areaID][classID][packageID] = new Integer(splitline[i]);
                    //System.out.println("dataset["+areaID+"]["+classID+"]["+packageID+"] = "+dataset[areaID][classID][packageID]);
                    //move to next slot
                    packageID++;
                    if (packageID >= countPackages) {
                        packageID -= countPackages;
                        classID++;
                        if (classID >= countClasses)
                            classID -= countClasses;
                    }

                }
            }
            line = reader.readLine();
        }
        //At this point, we have a big dataset with the most recent
        //scores for each area for each class/package combination
        //First step is to consolidate this to an average
        int[][] data = new int[countClasses][countPackages];
        for (classID = 0; classID < countClasses; classID++) {
            for (packageID = 0; packageID < countPackages; packageID++) {
                //reset score to zero
                score = 0;
                for (areaID = 0; areaID < countArea; areaID++) {
                    score += dataset[areaID][classID][packageID];
                }
                data[classID][packageID] = score / countArea;
                System.out.println("data[" + classID + "][" + packageID + "] = " + data[classID][packageID]);
            }
        }

        //now we know what each packageset scored, go through each class and cross the best 2 to
        //make the next generation
        for (classID = 0; classID < countClasses; classID++) {
            int packageMother = 0;
            int packageFather = 0;
            int scoreMother = 0;
            int scoreFather = 0;
            for (packageID = 0; packageID < countPackages; packageID++) {
                score = data[classID][packageID];
                if (score > scoreMother) {
                    scoreFather = scoreMother;
                    scoreMother = score;
                    packageFather = packageMother;
                    packageMother = packageID;
                } else if (score > scoreFather) {
                    scoreFather = score;
                    packageFather = packageID;
                }
            }
            //now we have a mother and a father packageset
            //remember, these are sets of packages, not the actual packages themselves
            //load the 2das
            String filename = "";
            filename = "evopset_" + classID + "_";
            //if(packageMother<10)
            //	filename += "0";
            filename += "" + packageMother;
            Data_2da motherpackset2da = Data_2da.load2da(packageFilePath + File.separator + filename + ".2da");
            filename = "evopset_" + classID + "_";
            //if(packageFather<10)
            //	filename += "0";
            filename += "" + packageFather;
            Data_2da fatherpackset2da = Data_2da.load2da(packageFilePath + File.separator + filename + ".2da");
            //create the output 2das
            for (int i = 0; i < countPackages; i++) {
                filename = "evopset_" + classID + "_";
                //if(i<10)
                //	filename += "0";
                filename += i;
                Data_2da offspringpackset2da = new Data_2da(filename);
                offspringpackset2da.addColumn("PackOffset");
                int parentToUse = 1;
                for (int row = 0; row < 40; row++) {
                    offspringpackset2da.appendRow();
                    //1 in 10 chance to flip between parents
                    if (rng.nextInt(10) == 0) {
                        if (parentToUse == 1)
                            parentToUse = 2;
                        else if (parentToUse == 2)
                            parentToUse = 1;
                    }
                    if (parentToUse == 1) {
                        //copy from mother
                        String value = motherpackset2da.getEntry("PackOffset", row);
                        //mutation chance
                        if (rng.nextInt(10) == 0) {
                            value = "" + (rng.nextInt(10) + 1);
                        }
                        offspringpackset2da.setEntry("PackOffset", row, value);
                    } else if (parentToUse == 2) {
                        //copy from father
                        String value = fatherpackset2da.getEntry("PackOffset", row);
                        //mutation chance
                        if (rng.nextInt(10) == 0) {
                            value = "" + (rng.nextInt(10) + 1);
                        }
                        offspringpackset2da.setEntry("PackOffset", row, value);
                    }
                }
                //now write it to the disk
                offspringpackset2da.save2da(outputFilePath);
            }
        }
    }
    //pastebin for later ;)
    //first thing is load the overall packages.2da file
    //Data_2da packages2da = Data_2da.load2da(packageFilePath+File.separator+"packages.2da");
			/*
			//get the real package IDs
			packageMother += (countPackages*classID);
			packageFather += (countPackages*classID);
			//EvoPSP
			//EvoPFTBard01
			//EvoPSP*/

    private static void readMe() {
        System.out.println("Usage:\n" +
                "\tjava npcevol logfile packages\n" +
                "\n" +
                "This application is designed to take a logfile \n" +
                "and parse it to extract relevant data.\n" +
                "Then it will take some package 2da files\n" +
                "and mutate them appropriately"
        );

        System.exit(0);
    }
}