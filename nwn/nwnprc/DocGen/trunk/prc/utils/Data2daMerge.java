package prc.utils;

import prc.autodoc.*;

import java.io.File;

public final class Data2daMerge {
    private Data2daMerge() {
    }

    private static String source = "";
    private static String merge = "";
    private static String output = "";

    /**
     * The main method, as usual.
     *
     * @param args do I really need to explain this?
     * @throws Exception this is a simple tool, just let all failures blow up
     */
    public static void main(String[] args) throws Exception {
        if (args.length < 3 || args[0].equals("--help") || args[0].equals("-?"))
            readMe();

        //check arguments for directories to use
        source = args[0];
        merge = args[1];
        output = args[2];

        //assemble arrays of filenames
        File[] sourceFiles = new File(source).listFiles();
        File[] mergeFiles = new File(merge).listFiles();

        //define some things for speed
        File sourceFile;
        File mergeFile;
        Data_2da sourceData;
        Data_2da mergeData;
        Data_2da outputData;

        for (int i = 0; i < sourceFiles.length; i++) {
            sourceFile = sourceFiles[i];
            //ignore non-2da files
            if (sourceFile.getPath().endsWith(".2da")) {
                String sourceFilename = sourceFile.getName().substring(0, sourceFile.getName().length() - 4);
                //loop over the merge files to find one that matches the source
                boolean matchFound = false;
                for (int j = 0; j < mergeFiles.length; j++) {
                    mergeFile = mergeFiles[j];
                    //ignore non-2da files
                    if (mergeFile.getPath().endsWith(".2da")) {
                        String mergeFilename = mergeFile.getName().substring(0, mergeFile.getName().length() - 4);
                        //its a match
                        if (mergeFilename.equals(sourceFilename)) {
                            matchFound = true;
                            String sourcePath = sourceFile.getAbsolutePath();
                            String mergePath = mergeFile.getAbsolutePath();
                            sourceData = Data_2da.load2da(sourcePath, true);
                            mergeData = Data_2da.load2da(mergePath, true);
                            outputData = Data_2da.load2da(sourcePath, true);
                            //Data_2da outputData = sourceData;
                            //get the smallest number of rows
                            int rowCount = sourceData.getEntryCount();
                            if (rowCount > mergeData.getEntryCount())
                                rowCount = mergeData.getEntryCount();

                            //check the columns match
                            //or at least the number of them
                            int colCount = sourceData.getLabels().length;
                            if (mergeData.getLabels().length != colCount) {
                                System.out.println("Number of columns does not match!");
                            } else {
                                //loop over the overlapping rows
                                for (int row = 0; row < rowCount; row++) {
                                    for (int col = 0; col < colCount; col++) {
                                        String columnName = sourceData.getLabels()[col];
                                        String sourceEntry = sourceData.getEntry(columnName, row);
                                        String mergeEntry = mergeData.getEntry(columnName, row);
                                        if (!mergeEntry.equals("****")
                                                && !mergeEntry.equals(sourceEntry)) {
                                            outputData.setEntry(columnName, row, mergeEntry);
                                            //made a change, log it
                                            System.out.println(sourceFilename + " : " + columnName + "," + row + " " + sourceEntry + " -> " + mergeEntry);
                                        }
                                    }
                                }
                                //check if merge has extra rows
                                if (rowCount < mergeData.getEntryCount()) {
                                    for (int row = rowCount; row < mergeData.getEntryCount(); row++) {
                                        outputData.appendRow();
                                        //copy the extra rows to the output
                                        for (int col = 0; col < colCount; col++) {
                                            String columnName = sourceData.getLabels()[col];
                                            String mergeEntry = mergeData.getEntry(columnName, row);
                                            if (!mergeEntry.equals("****")) {
                                                outputData.setEntry(columnName, row, mergeEntry);
                                                //made a change, log it
                                                System.out.println(sourceFilename + " : " + columnName + "," + row + " null -> " + mergeEntry);
                                            }
                                        }
                                    }
                                }
                            }
                            //finished assembling the output file, write it
                            //this overwrites the target file
                            outputData.save2da(output, true, true);
                        }
                    }
                }
                //end of file loop for
            }
        }
    }

    private static void readMe() {
        System.out.println("Usage:\n" +
                "\tjava 2damerge source merge output\n" +
                "\n" +
                "This application is designed to take all the 2DA\n" +
                "files in the source directory, merge them with the\n" +
                "2DA files in the merge directory, and output the\n" +
                "edited versions to the output directory"
        );

        System.exit(0);
    }
}