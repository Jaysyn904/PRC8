package prc.utils;

import prc.autodoc.Data_2da;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;

import static prc.Main.err_pr;
import static prc.Main.spinner;


/**
 * This class is meant for updating the class feat lists with the entries common to all
 * base classes.
 *
 * @author Ornedan
 */
public class AllClassFeatUpdater {

    private static boolean cropduplicates = false;

    /**
     * Ye olde main method.
     * Takes as parameters the path of the 2da to use as update template and
     *
     * @param args [--help] | [-c] pathtoupdate2da targetpath+
     */
    public static void main(String[] args) {
        if (args.length == 0) readMe();
        String cfabcPath = null;
        List<String> paths = new ArrayList<String>();

        // parse args
        for (String param : args) {//[--help] | pathtoupdate2da targetpath+
            // Parameter parseage
            if (param.startsWith("-")) {
                if (param.equals("--help")) readMe();
                else {
                    for (char c : param.substring(1).toCharArray()) {
                        switch (c) {
                            case 'c':
                                cropduplicates = true;
                                break;
                            default:
                                System.out.println("Unknown parameter: " + c);
                                readMe();
                        }
                    }
                }
            } else {
                // It's a pathname
                if (cfabcPath == null)
                    cfabcPath = param;
                else
                    paths.add(param);
            }
        }

        if (cfabcPath == null) {
            err_pr.println("Error: You did not specify the location of cls_feat_allBaseClasses.2da\n");
            readMe();
        }
        if (paths.size() == 0) {
            err_pr.println("Error: You did not specify targets!\n");
            readMe();
        }
        spinner.disable();

        // Load and crop the template 2da
        Data_2da source = Data_2da.load2da(cfabcPath);
        int i = source.getEntryCount();
        boolean passedEnd = false, passedBegin = false;
        while (--i >= 0) {
            //###cls_feat_allBaseClasses_BEGIN###
            //###cls_feat_allBaseClasses_END###
            if (!passedEnd) {
                if (source.getEntry("FeatLabel", i).equals("###cls_feat_allBaseClasses_END###")) {
                    passedEnd = true;
                    continue;
                } else
                    source.removeRow(i);
            } else if (!passedBegin) {
                if (source.getEntry("FeatLabel", i).equals("###cls_feat_allBaseClasses_BEGIN###"))
                    passedBegin = true;
            } else {
                source.removeRow(i);
            }
        }

        // Parse the targets and update all files found
        for (String path : paths) {
            File target = new File(path);
            File[] cls_feat2da;

            if (target.isDirectory()) {
                cls_feat2da = target.listFiles(new FileFilter() {
                    public boolean accept(File file) {
                        return file.getName().toLowerCase().startsWith("cls_feat_") &&
                                file.getName().toLowerCase().endsWith(".2da");
                    }
                });
            } else if (target.getName().toLowerCase().startsWith("cls_feat_") &&
                    target.getName().toLowerCase().endsWith(".2da"))
                cls_feat2da = new File[]{target};
            else {
                err_pr.println("Error: Parameter \"" + path + "\" is not a valid target!");
                continue;
            }

            Arrays.sort(cls_feat2da);

            for (File file : cls_feat2da) {
                try {
                    update2da(source, Data_2da.load2da(file.getCanonicalPath()), file.getParentFile().getCanonicalPath());
                } catch (Exception e) {
                    err_pr.printException(e);
                }
            }
        }
    }

    private static void update2da(Data_2da updateSource, Data_2da target, String path) throws IOException {
        // Find the beginning of replaceable area
        int beginRow = -1, i = 0;
        while (beginRow == -1 && i < target.getEntryCount()) {
            if (target.getEntry("FeatLabel", i).equals("###cls_feat_allBaseClasses_BEGIN###"))
                beginRow = i;
            i++;
        }

        if (beginRow != -1) {
            // Strip the lines to be replaced
            while (beginRow < target.getEntryCount()) {
                if (target.getEntry("FeatLabel", beginRow).equals("###cls_feat_allBaseClasses_END###")) {
                    target.removeRow(beginRow);
                    break;
                } else
                    target.removeRow(beginRow);
            }

            // Handle cropping, if it is enabled
            if (cropduplicates) {
                // Make a copy of the update source, which can then be cropped
                updateSource = (Data_2da) updateSource.clone();
                cropDuplicates(updateSource, target);
            }

            for (i = 0; i < updateSource.getEntryCount(); i++) {
                target.insertRow(beginRow + i, updateSource.getRow(i));
            }

            //System.out.println(target); System.exit(0);
            target.save2da(path, true, true);
        }
    }

    private static void cropDuplicates(Data_2da toCrop, Data_2da source) {
        // Load the featIDs from source to a hashset
        HashSet<Integer> featIDs = new HashSet<Integer>();

        for (int i = 0; i < source.getEntryCount(); i++) {
            try {
                featIDs.add(Integer.parseInt(source.getEntry("FeatIndex", i)));
            } catch (NumberFormatException nfe) {/* Ignore empty rows */}
        }

        // Loop over the crop target, removing rows whose FeatIndex is present in the source
        for (int i = toCrop.getEntryCount() - 1; i >= 0; i--) {
            try {
                if (featIDs.contains(Integer.parseInt(toCrop.getEntry("FeatIndex", i))))
                    toCrop.removeRow(i);
            } catch (NumberFormatException nfe) {/* Ignore empty rows */}
        }

    }

    private static void readMe() {
        System.out.println("Usage:\n" +
                "  [--help] | [-c] pathtoupdate2da targetpath+\n" +
                "\n" +
                " pathtoupdate2da  path of the cls_feat_allBaseClasses.2da\n" +
                " targetpath       the path of a directory containing the cls_feat_*.2das to update\n" +
                "                  or directly the path of a cls_feat_*.2da\n" +
                "\n" +
                "  -c      crop rows from the update source that contain featIDs present elsewhere\n" +
                "          in the target than in the updateable area\n" +
                "\n" +
                "  --help  prints this text\n"
        );
        System.exit(0);
    }
}
