package prc.autodoc;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static prc.Main.*;

/**
 * This class forms an interface for accessing 2da files in the
 * PRC automated manual generator.
 */
public class Data_2da implements Cloneable {
    // String matching pattern. Gets a block of non-whitespace (tab is not counted as whitespace here) that does not contain any " OR " followed by any characters until the next "
    private static final Pattern pattern = Pattern.compile("[[\\S&&[^\"]][\t]]+|\"[^\"]+\"");
    // Same as the above, but counts tab as whitespace. Bug-compatibility with BioWare's own violations of 2da spec
    private static final Pattern bugCompatPattern = Pattern.compile("[\\S&&[^\"]]+|\"[^\"]+\"");
    //private static Matcher matcher = pattern.matcher("");

    private LinkedHashMap<String, ArrayList<String>> mainData = new LinkedHashMap<String, ArrayList<String>>();
    private final String name;
    private String defaultValue;

    /**
     * Bugcompatibility feature for a special case where the first line of a 2da has * for line number instead of 0
     */
    private boolean starOnLine0 = false;

    /**
     * Used for storing the original case of the labels. The ones used in the hashmap are lowercase
     */
    private ArrayList<String> realLabels = new ArrayList<String>();

    private final boolean TLKEditCompatible = true;

    /**
     * Creates a new, empty Data_2da with the specified name.
     *
     * @param name The new 2da file's name.
     */
    public Data_2da(String name) {
        this(name, "");
    }

    /**
     * Creates a new, empty Data_2da with the specified name and default value.
     *
     * @param name         the new 2da file's name
     * @param defaultValue the new 2da file's default value
     */
    public Data_2da(String name, String defaultValue) {
        this.name = name;
        this.defaultValue = defaultValue;
    }

    /**
     * Private constructor for use in cloning.
     *
     * @param name         the file name
     * @param defaultValue the default value
     * @param realLabels   the labels with original case
     * @param mainData     the contents
     */
    public Data_2da(String name, String defaultValue, ArrayList<String> realLabels, LinkedHashMap<String, ArrayList<String>> mainData) {
        this.name = name;
        this.defaultValue = defaultValue;
        this.realLabels = realLabels;
        this.mainData = mainData;
    }

    /**
     * Saves the 2da represented by this object to file. Equivalent to calling
     * <code>save2da(path, false, false)</code>.
     *
     * @param path the directory to save the file in. If this is "" or null,
     *             the current directory is used.
     * @throws IOException if <code>true</code> and a file with the same name as this 2da
     *                     exists at <code>path</code>, it is overwritten.
     *                     If <code>false</code> and in the same situation, an IOException is
     *                     thrown.
     */
    public void save2da(String path) throws IOException {
        save2da(path, false, false);
    }

    /**
     * Saves the 2da represented by this object to file. CRLFs are explicitly used
     * instead of system specific line terminator.
     *
     * @param path           the directory to save the file in. If this is "" or null,
     *                       the current directory is used.
     * @param allowOverWrite if <code>true</code> and a file with the same name as this 2da
     *                       exists at <code>path</code>, it is overwritten.
     *                       If <code>false</code> and in the same situation, an IOException is
     *                       thrown.
     * @param evenColumns    if <code>true</code>, every entry in a column will be padded until they
     *                       start from the same position
     * @throws IOException if cannot overwrite, or the underlying IO throws one
     */
    public void save2da(String path, boolean allowOverWrite, boolean evenColumns) throws IOException {
        String CRLF = "\r\n";
        if (path == null || path.equals(""))
            path = "." + File.separator;
        if (!path.endsWith(File.separator))
            path += File.separator;

        File file = new File(path + name + ".2da");
        if (file.exists() && !allowOverWrite)
            throw new IOException("File exists already: " + file.getAbsolutePath());

        // Inform user
        if (verbose) System.out.print("Saving 2da file: " + name + " ");

        FileWriter fw = new FileWriter(file, false);
        String[] labels = this.getLabels();
        String toWrite;

        // Get the amount of padding used, if any
        int[] widths = new int[labels.length + 1];// All initialised to 0
        if (evenColumns) {
            ArrayList<String> column;
            int pad;
            // Loop over columns
            for (int i = 0; i < labels.length; i++) {
                pad = labels[i].length();
                column = mainData.get(labels[i]);
                // Loop over rows
                for (int j = 0; j < this.getEntryCount(); j++) {
                    toWrite = column.get(j);
                    // If the string contains spaces, it needs to be wrapped in "
                    if (toWrite.indexOf(" ") != -1)
                        toWrite = "\"" + toWrite + "\"";
                    if (toWrite.length() > pad) pad = toWrite.length();
                }
                widths[i] = pad;
            }

            // The last entry in the array is used for the numbers column
            widths[widths.length - 1] = new Integer(this.getEntryCount()).toString().length();
        }

        // Write the header and default lines
        fw.write("2DA V2.0" + CRLF);
        if (!defaultValue.equals(""))
            fw.write("DEFAULT: " + defaultValue + CRLF);
        else
            fw.write(CRLF);

        // Write the labels row using the original case
        for (int i = 0; i < widths[widths.length - 1]; i++) fw.write(" ");
        for (int i = 0; i < realLabels.size(); i++) {
            fw.write(" " + realLabels.get(i));
            for (int j = 0; j < widths[i] - realLabels.get(i).length(); j++) fw.write(" ");
        }
        fw.write((TLKEditCompatible ? " " : "") + CRLF);

        // Write the data
        for (int i = 0; i < this.getEntryCount(); i++) {
            // Write the number row and it's padding
            if (i == 0 && starOnLine0)
                fw.write("*");
            else
                fw.write("" + i);
            for (int j = 0; j < widths[widths.length - 1] - new Integer(i).toString().length(); j++) fw.write(" ");
            // Loop over columns
            for (int j = 0; j < labels.length; j++) {
                toWrite = mainData.get(labels[j]).get(i);
                // If the string contains spaces, it needs to be wrapped in "
                if (toWrite.indexOf(" ") != -1)
                    toWrite = "\"" + toWrite + "\"";
                fw.write(" " + toWrite);
                // Write padding
                for (int k = 0; k < widths[j] - toWrite.length(); k++) fw.write(" ");
            }
            fw.write((TLKEditCompatible ? " " : "") + CRLF);

            if (verbose) spinner.spin();
        }

        fw.flush();
        fw.close();

        if (verbose) System.out.println("- Done");
    }

    /**
     * Creates a new Data_2da on the 2da file specified.
     *
     * @param filePath path to the 2da file to load
     * @return a Data_2da instance containing the read 2da
     * @throws IllegalArgumentException <code>filePath</code> does not specify a 2da file
     * @throws TwoDAReadException       reading the 2da file specified does not succeed,
     *                                  or the file does not contain any data
     */
    public static Data_2da load2da(String filePath) throws IllegalArgumentException, TwoDAReadException {
        return load2da(filePath, false);
    }

    /**
     * Creates a new Data_2da on the 2da file specified.
     *
     * @param filePath  path to the 2da file to load
     * @param bugCompat if this is <code>true</code>, ignores
     *                  departures from the 2da spec present in Bioware 2das
     * @return a Data_2da instance containing the read 2da
     * @throws IllegalArgumentException <code>filePath</code> does not specify a 2da file
     * @throws TwoDAReadException       reading the 2da file specified does not succeed,
     *                                  or the file does not contain any data
     */
    public static Data_2da load2da(String filePath, boolean bugCompat) throws IllegalArgumentException, TwoDAReadException {
        Data_2da toReturn;
        Matcher matcher = bugCompat ? bugCompatPattern.matcher("") : pattern.matcher("");
        String name;

        // Some paranoia checking for bad parameters
        if (!filePath.toLowerCase().endsWith("2da"))
            throw new IllegalArgumentException("Non-2da filename passed to Data_2da: " + filePath);

        // Create the file handle
        File baseFile = new File(filePath);
        // More paraoia
        if (!baseFile.exists())
            throw new IllegalArgumentException("Nonexistent file passed to Data_2da: " + filePath);
        if (!baseFile.isFile())
            throw new IllegalArgumentException("Nonfile passed to Data_2da: " + filePath);


        // Drop the path from the filename
        name = baseFile.getName().substring(0, baseFile.getName().length() - 4);
        //toReturn = new Data_2da(baseFile.getName().substring(0, baseFile.getName().length() - 4));

        // Tell the user what we are doing
        if (verbose) System.out.print("Reading 2da file: " + name + " ");

        // Create a Scanner for reading the 2da
        Scanner reader = null;
        try {
            // Fully read the file into a byte array
            RandomAccessFile raf = new RandomAccessFile(baseFile, "r");
            byte[] bytebuf = new byte[(int) raf.length()];
            raf.readFully(bytebuf);
            raf.close();
            //reader = new Scanner(baseFile);
            reader = new Scanner(new String(bytebuf));
        } catch (Exception e) {
            err_pr.println("Error: File operation failed. Aborting.\nException data:\n" + e);
            System.exit(1);
        }

        try {
            // Check the 2da header
            if (!reader.hasNextLine())
                throw new TwoDAReadException("Empty file: " + name + "!");
            String data = reader.nextLine();

            if (!(bugCompat ? Pattern.matches("2DA[ \t]V2\\.0\\s*", data) : data.contains("2DA V2.0")))
                throw new TwoDAReadException("2da header missing or invalid: " + name);

            // Initialise the return object
            toReturn = new Data_2da(name);

            // Start the actual reading
            try {
                toReturn.createData(reader, matcher, bugCompat);
            } catch (TwoDAReadException e) {
                throw new TwoDAReadException("Exception occurred when reading 2da file: " + toReturn.getName() + "\n" + e.getMessage(), e);
            }
        } finally {
            // Cleanup
            reader.close();
        }

        if (verbose) System.out.println("- Done");
        return toReturn;
    }

    /**
     * Reads the data rows from the 2da into the hashmap and
     * does validity checking on the 2da while doing so.
     *
     * @param reader    Scanner that the method reads from
     * @param matcher   Matcher being used to parse the data read
     * @param bugCompat if this is <code>true</code>, ignores
     *                  departures from the 2da spec present in Bioware 2das
     */
    private void createData(Scanner reader, Matcher matcher, boolean bugCompat) {
        Scanner rowParser;
        String data, bugCompat_data;
        boolean bugCompat_MissingDefaultLine = false;
        int line = 0;

        // Get the default - though it's not used by this implementation, it should not be lost by opening and resaving a file
        if (!reader.hasNextLine())
            throw new TwoDAReadException("No contents after header in 2da file " + name + "!");
        bugCompat_data = data = reader.nextLine();
        matcher.reset(data);
        if (matcher.find()) { // Non-blank default line
            data = matcher.group();
            if (data.trim().equalsIgnoreCase("DEFAULT:")) {
                if (matcher.find())
                    this.defaultValue = matcher.group();
                else
                    throw new TwoDAReadException("Malformed default line in 2da file " + name + "!");
            } else if (!bugCompat)
                throw new TwoDAReadException("Malformed default line in 2da file " + name + "!");
            else
                bugCompat_MissingDefaultLine = true;
        }

        // Find the labels row
        if (bugCompat_MissingDefaultLine) // Handle cases where the labels are on the second line in the file instead of 3rd
            data = bugCompat_data;
        else {
            if (!reader.hasNextLine())
                throw new TwoDAReadException("No labels found in 2da file!");
            data = reader.nextLine();
        }

        // Check for blank lines between the DEFAULT line and labels
        if (data.trim().equals(""))
            if (!bugCompat)
                throw new TwoDAReadException("Labels not present on third line of the file!");
            else
                while (true) {
                    if (reader.hasNextLine()) {
                        data = reader.nextLine();
                        if (!data.trim().equals(""))
                            break;
                    } else
                        throw new TwoDAReadException("No data in 2da file!");
                }

        // Parse the labels
        String[] localrealLabels = data.trim().split("\\p{javaWhitespace}+");
        String[] labels = new String[localrealLabels.length];
        //System.arraycopy(realLabels, 0, labels, 0, localrealLabels.length);

        // Create the row containers and the main store
        for (int i = 0; i < labels.length; i++) {
            realLabels.add(localrealLabels[i]);
            labels[i] = localrealLabels[i].toLowerCase();
            mainData.put(labels[i], new ArrayList<String>());
        }

        // Error if there are empty lines between the header and the data or no lines at all
        if (!reader.hasNextLine())
            if (!bugCompat)
                throw new TwoDAReadException("No data in 2da file!");
            else
                return;
        if ((data = reader.nextLine()).trim().equals(""))
            if (!bugCompat)
                throw new TwoDAReadException("Blank lines following labels row!");
            else
                while (true) {
                    if (reader.hasNextLine()) {
                        data = reader.nextLine();
                        if (!data.trim().equals(""))
                            break;
                    } else
                        return;
                }

        while (true) {
            //rowParser = new Scanner(data);
            matcher.reset(data);
            matcher.find();

            // Check for the presence of the row number
            try {
                // Special case - In bugcompatibility mode, 0 can be replaced with *
                if (bugCompat && line == 0 && matcher.group().trim().equals("*")) {
                    starOnLine0 = true;
                } else
                    line = Integer.parseInt(matcher.group());
            } catch (NumberFormatException e) {
                return;
                // throw new TwoDAReadException("Numberless 2da line: " + (line + 1));
            }

            // Start parsing the row
            for (int i = 0; i < labels.length; i++) {
                // Find the next match and check for too short rows
                if (!matcher.find())
                    throw new TwoDAReadException("Too short 2da line: " + line);

                // Get the next element and add it to the data structure
                data = matcher.group();
                // Remove the surrounding quotes if they are present
                if (data.startsWith("\"")) data = data.substring(1, data.length() - 1);
                mainData.get(labels[i]).add(data);
            }

            // Check for too long rows
            if (matcher.find())
                return;
                // throw new TwoDAReadException("Too long 2da line: " + line);

            // Increment the entry counter
            //entries++;

            /* Get the next line if there is one, or break the loop
             * A bit ugly, but I couldn't figure an easy way of making the loop go right
             * even for 2das with only one row without biggish changes
             */
            if (reader.hasNextLine()) {
                data = reader.nextLine();
                if (data.trim().equals(""))
                    break;
            } else
                break;

            if (verbose) spinner.spin();
        }

        // Some validity checking on the 2da. Empty rows allowed only in the end
        if (getNextNonEmptyRow(reader) != null)
            throw new TwoDAReadException("Empty row in the middle of 2da. After row: " + line);
    }

    /**
     * Reads rows from a Scanner pointed at a 2da file until it finds a
     * row containing non-whitespace characters.
     *
     * @param reader Scanner that the method reads from
     * @return The row found, or null if none were found.
     */
    private static String getNextNonEmptyRow(Scanner reader) {
        String toReturn = null;
        while (reader.hasNextLine()) {
            toReturn = reader.nextLine();
            if (!toReturn.trim().equals(""))
                break;
        }

        if (toReturn == null || toReturn.trim().equals(""))
            return null;

        return toReturn;
    }

    /**
     * Get the list of column labels in this 2da.
     *
     * @return an array of Strings containing the column labels
     */
    public String[] getLabels() {
        // For some reason, it won't let me cast the keyset directly into a String[]
//		return (String[])(mainData.keySet().toArray());
        Object[] temp = mainData.keySet().toArray();
        String[] toReturn = new String[temp.length];
        for (int i = 0; i < temp.length; i++) toReturn[i] = (String) temp[i];
        /*String[] toReturn = (String[])mainData.keySet().toArray();*/
        return toReturn;
    }

    /**
     * Get the 2da entry on the given row and column
     *
     * @param label the label of the column to get
     * @param row   the number of the row to get, as string
     * @return int represeting the 2da entry or <code>null</code> if the column does not exist
     * if the column is **** then 0 will be returned
     * @throws NumberFormatException if <code>row</code> cannot be converted to an integer
     */
    public int getBiowareEntryAsInt(String label, String row) {
        String returnString = this.getEntry(label, Integer.parseInt(row));
        if (returnString.equals("****"))
            return 0;
        else if (returnString.matches("\\D")) //check its a number
            return 0;
        return Integer.decode(returnString);
    }

    /**
     * Get the 2da entry on the given row and column
     *
     * @param label the label of the column to get
     * @param row   the number of the row to get
     * @return String represeting the 2da entry or <code>null</code> if the column does not exist
     * if the column is **** then a zero length string will be returned
     */
    public int getBiowareEntryAsInt(String label, int row) {
        ArrayList<String> column = mainData.get(label.toLowerCase());
        String returnString = column != null ? column.get(row) : null;
        if (returnString.equals("****"))
            return 0;
        else if (returnString.matches("\\D")) //check its a number
            return 0;
        return Integer.decode(returnString);
    }

    /**
     * Get the 2da entry on the given row and column
     *
     * @param label the label of the column to get
     * @param row   the number of the row to get, as string
     * @return String represeting the 2da entry or <code>null</code> if the column does not exist
     * if the column is **** then a zero length string will be returned
     * @throws NumberFormatException if <code>row</code> cannot be converted to an integer
     */
    public String getBiowareEntry(String label, String row) {
        String returnString = this.getEntry(label, Integer.parseInt(row));
        if (returnString.equals("****"))
            return "";
        return returnString;
    }

    /**
     * Get the 2da entry on the given row and column
     *
     * @param label the label of the column to get
     * @param row   the number of the row to get
     * @return String represeting the 2da entry or <code>null</code> if the column does not exist
     * if the column is **** then a zero length string will be returned
     */
    public String getBiowareEntry(String label, int row) {
        ArrayList<String> column = mainData.get(label.toLowerCase());
        String returnString = column != null ? column.get(row) : null;
        if (returnString.equals("****"))
            return "";
        return returnString;
    }

    /**
     * Get the 2da entry on the given row and column
     *
     * @param label the label of the column to get
     * @param row   the number of the row to get, as string
     * @return String represeting the 2da entry or <code>null</code> if the column does not exist
     * @throws NumberFormatException if <code>row</code> cannot be converted to an integer
     */
    public String getEntry(String label, String row) {
        return this.getEntry(label, Integer.parseInt(row));
    }

    /**
     * Get the 2da entry on the given row and column
     *
     * @param label the label of the column to get
     * @param row   the number of the row to get
     * @return String represeting the 2da entry or <code>null</code> if the column does not exist
     */
    public String getEntry(String label, int row) {
        ArrayList<String> column = mainData.get(label.toLowerCase());
        return column != null ? column.get(row) : null;
    }

    /**
     * Get number of entries in this 2da. Works by returning the size of one of the columns in the 2da.
     *
     * @return integer equal to the number of entries in this 2da
     */
    public int getEntryCount() {
        if (mainData.entrySet().size() == 0) {
            return 0;
        }
        return mainData.entrySet().iterator().next().getValue().size();
    }

    /**
     * Get the name of this 2da
     *
     * @return String representing this 2da's name
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the 2da entry on the given row and column
     *
     * @param label the label of the column to get
     * @param row   the number of the row to get, as string
     * @param entry the new contents of the entry. If this is null or empty, it is replaced with ****
     * @throws NumberFormatException if <code>row</code> cannot be converted to an integer
     */
    public void setEntry(String label, String row, String entry) {
        this.setEntry(label, Integer.parseInt(row), entry);
    }

    /**
     * Sets the 2da entry on the given row and column
     *
     * @param label the label of the column to get
     * @param row   the number of the row to get, as string
     * @param entry the new contents of the entry. If this is null or empty, it is replaced with ****
     *              or with the default value if that is set
     */
    public void setEntry(String label, int row, String entry) {
        if (entry == null || entry.equals(""))
            if (defaultValue.equals(""))
                entry = "****";
            else
                entry = defaultValue;
        mainData.get(label.toLowerCase()).set(row, entry);
    }

    /**
     * Returns the contents of the requested row as a string array. The order the columns are
     * taken is the same as the order of labels from getLabels().
     *
     * @param index the index of the row to get
     * @return an array of strings containing the elements in the r
     * @throws NumberFormatException if <code>index</code> cannot be converted to an integer
     */
    public String[] getRow(String index) {
        return getRow(Integer.parseInt(index));
    }


    /**
     * Returns the contents of the requested row as a string array. The order the columns are
     * taken is the same as the order of labels from getLabels().
     *
     * @param index the index of the row to get
     * @return an array of strings containing the elements in the row
     */
    public String[] getRow(int index) {
        String[] labels = this.getLabels();
        String[] toReturn = new String[labels.length];

        for (int i = 0; i < labels.length; i++) {
            toReturn[i] = mainData.get(labels[i]).get(index);
        }

        return toReturn;
    }

    /**
     * Appends a new, empty row to the end of the 2da file, with entries defaulting to the
     * default value or if that is not set, ****
     */
    public void appendRow() {
        String[] labels = this.getLabels();

        for (String label : labels) {
            if (defaultValue.equals(""))
                mainData.get(label).add("****");
            else
                mainData.get(label).add(defaultValue);
        }
    }

    /**
     * Appends a new, empty row to the end of the 2da file. The new row will be filled with the values
     * given as parameter.
     *
     * @param data the strings that will be used to fill the new row
     * @throws IllegalArgumentException if the number of elements in <code>data</code> array is not
     *                                  same as number of columns in the 2da
     */
    public void appendRow(String[] data) {
        String[] labels = this.getLabels();

        // Sanity check
        if (labels.length != data.length)
            throw new IllegalArgumentException("Differing column width when attempting to insert row");

        for (int i = 0; i < labels.length; i++) {
            mainData.get(labels[i]).add(data[i]);
        }
    }

    /**
     * Inserts a new row into the given index in the 2da file. The row currently at the index and all
     * subsequent rows have their index increased by one. The new row will be filled with the values
     * given as parameter.
     *
     * @param index the index where the new row will be located
     * @param data  the strings that will be used to fill the new row
     * @throws IllegalArgumentException if the number of elements in <code>data</code> array is not
     *                                  same as number of columns in the 2da
     * @throws NumberFormatException    if <code>index</code> cannot be converted to an integer
     */
    public void insertRow(String index, String[] data) {
        insertRow(Integer.parseInt(index), data);
    }

    /**
     * Inserts a new row into the given index in the 2da file. The row currently at the index and all
     * subsequent rows have their index increased by one. The new row will be filled with the values
     * given as parameter.
     *
     * @param index the index where the new row will be located
     * @param data  the strings that will be used to fill the new row
     * @throws IllegalArgumentException if the number of elements in <code>data</code> array is not
     *                                  same as number of columns in the 2da
     */
    public void insertRow(int index, String[] data) {
        String[] labels = this.getLabels();

        // Sanity check
        if (labels.length != data.length)
            throw new IllegalArgumentException("Differing column width when attempting to insert row");

        for (int i = 0; i < labels.length; i++) {
            mainData.get(labels[i]).add(index, data[i]);
        }
    }


    /**
     * Adds a new, empty row to the given index in the 2da file. The row currently at the index and all
     * subsequent rows have their index increased by one.
     * The entries default to ****.
     *
     * @param index the index where the new row will be located
     * @throws NumberFormatException if <code>index</code> cannot be converted to an integer
     */
    public void insertRow(String index) {
        insertRow(Integer.parseInt(index));
    }

    /**
     * Adds a new, empty row to the given index in the 2da file. The row currently at the index and all
     * subsequent rows have their index increased by one.
     * The entries default to default value or if that is not set, ****.
     *
     * @param index the index where the new row will be located
     */
    public void insertRow(int index) {
        String[] labels = this.getLabels();

        for (String label : labels) {
            if (defaultValue.equals(""))
                mainData.get(label).add(index, "****");
            else
                mainData.get(label).add(index, defaultValue);
        }
    }

    /**
     * Removes the row at the given index. All subsequent rows have their indexed shifted down by one.
     *
     * @param index the index of the row to remove
     * @throws NumberFormatException if <code>index</code> cannot be converted to an integer
     */
    public void removeRow(String index) {
        removeRow(Integer.parseInt(index));
    }

    /**
     * Removes the row at the given index. All subsequent rows have their indexed shifted down by one.
     *
     * @param index the index of the row to remove
     */
    public void removeRow(int index) {
        String[] labels = this.getLabels();

        for (String label : labels) {
            mainData.get(label).remove(index);
        }
    }

    /**
     * Adds a new column to the 2da file. The new column will be the last in the file.
     *
     * @param label the name of the column to add
     */
    public void addColumn(String label) {
        ArrayList<String> column = new ArrayList<String>();
        mainData.put(label.toLowerCase(), column);
        realLabels.add(label);

        if (defaultValue.equals("")) {
            for (int i = 0; i < this.getEntryCount(); i++) {
                column.add("****");
            }
        } else {
            for (int i = 0; i < this.getEntryCount(); i++) {
                column.add(defaultValue);
            }
        }
    }

    /**
     * Removes the column with the given label from the 2da.
     *
     * @param label the name of the column to remove
     */
    public void removeColumn(String label) {
        mainData.remove(label);
        realLabels.remove(label);
    }


    /**
     * The main method, as usual
     *
     * @param args
     */
    public static void main(String[] args) {
        if (args.length == 0) readMe();
        List<String> fileNames = new ArrayList<String>();
        boolean compare = false;
        boolean resave = false;
        boolean minimal = false;
        boolean ignoreErrors = false;
        boolean readStdin = false;
        boolean bugCompat = false;

        for (String param : args) {//[-bcrmnqs] file... | -
            // Parameter parseage
            if (param.startsWith("-")) {
                if (param.equals("-"))
                    readStdin = true;
                else if (param.equals("--help")) readMe();
                else {
                    for (char c : param.substring(1).toCharArray()) {
                        switch (c) {
                            case 'b':
                                bugCompat = true;
                                break;
                            case 'c':
                                compare = true;
                                if (resave) resave = false;
                                break;
                            case 'r':
                                resave = true;
                                if (compare) compare = false;
                                break;
                            case 'm':
                                minimal = true;
                                break;
                            case 'n':
                                ignoreErrors = true;
                                break;
                            case 'q':
                                verbose = false;
                                break;
                            case 's':
                                spinner.disable();
                                break;
                            default:
                                err_pr.println("Error: Unknown parameter: " + c);
                                readMe();
                        }
                    }
                }
            } else
                // It's a filename
                fileNames.add(param);
        }

        // Read files from stdin if specified
        if (readStdin) {
            Scanner scan = new Scanner(System.in);
            String s;
            while (scan.hasNextLine()) {
                s = scan.nextLine();
                if (s.charAt(0) == '"' && s.charAt(s.length() - 1) == '"')
                    s = s.substring(1, s.length() - 1);
                fileNames.add(s);
            }
        }

        // Run the specified operation
        if (compare) {
            Data_2da file1, file2;
            file1 = load2da(args[1], bugCompat);
            file2 = load2da(args[2], bugCompat);

            doComparison(file1, file2);
        } else if (resave) {
            Data_2da temp;
            for (String fileName : fileNames) {
                try {
                    temp = load2da(fileName, bugCompat);
                    temp.save2da(new File(fileName).getCanonicalFile().getParent() + File.separator, true, !minimal);
                } catch (Exception e) {
                    // Print the error
                    err_pr.printException(e);
                    // If ignoring errors, and this error is of expected type, continue
                    if (e instanceof IllegalArgumentException ||
                            e instanceof TwoDAReadException ||
                            e instanceof IOException)
                        if (ignoreErrors)
                            continue;
                    System.exit(1);
                }
            }
        } else {
            // Validify by loading
            for (String fileName : fileNames) {
                try {
                    load2da(fileName, bugCompat);
                } catch (Exception e) {
                    // Print the error
                    err_pr.printException(e);
                    // If ignoring errors, and this error is of expected type, continue
                    if (e instanceof IllegalArgumentException || e instanceof TwoDAReadException)
                        if (ignoreErrors)
                            continue;
                    System.exit(1);
                }
            }
        }
    }

    private static void readMe() {
        System.out.println("Usage:\n" +
                "  [-bcrmnqs] file... | -\n" +
                "\n" +
                "  -b    bug-compatibility mode. Counts tabs as whitespace instead of data\n" +
                "  -c    prints the differing lines between the 2das given as first two\n" +
                "        parameters. They must have the same label set and entrycount.\n" +
                "        Mutually exclusive with -r\n" +
                "  -r    resaves the 2das given as parameters. Mutually exclusive with -c\n" +
                "  -m    saves the files with minimal spaces. Only relevant when resaving\n" +
                "  -n    ignores errors that occur during validity testing and resaving,\n" +
                "        just skips to the next file\n" +
                "  -q    quiet mode\n" +
                "  -s    no spinner\n" +
                "  -     a line given as a lone parameter means that the list of files is\n" +
                "        read from stdin in addition to the ones passed from command line.\n" +
                "        The list passed in such manner should contain one filename per line\n" +
                "\n" +
                "  --help  prints this text\n" +
                "\n" +
                "\n" +
                "if neither -c or -r is specified, performs validity testing on the given files"
        );
        System.exit(0);
    }

    /**
     * Compares the given two 2da files and prints differences it finds
     * Differing number of rows, or row names will cause comparison to abort.
     *
     * @param file1 Data_2da containing one of the files to be compared
     * @param file2 Data_2da containing the other file to be compared
     */
    public static void doComparison(Data_2da file1, Data_2da file2) {
        // Check labels
        String[] labels1 = file1.getLabels(),
                labels2 = file2.getLabels();
        if (labels1.length != labels2.length) {
            System.out.println("Differing amount of row labels\n" +
                    file1.getName() + ": " + labels1.length + "\n" +
                    file2.getName() + ": " + labels2.length);
            return;
        }
        for (int i = 0; i < labels1.length; i++) {
            if (!labels1[i].equals(labels2[i])) {
                System.out.println("Differing labels");
                return;
            }
        }

        // Check lengths
        int shortCount = file1.getEntryCount();
        if (file1.getEntryCount() != file2.getEntryCount()) {
            System.out.println("Differing line counts.\n" +
                    file1.getName() + ": " + file1.getEntryCount() + "\n" +
                    file2.getName() + ": " + file2.getEntryCount());

            shortCount = shortCount > file2.getEntryCount() ? file2.getEntryCount() : shortCount;
        }

        // Check elements
        for (int i = 0; i < shortCount; i++) {
            for (String label : labels1) {
                if (!file1.getEntry(label, i).equals(file2.getEntry(label, i))) {
                    System.out.println("Differing entries on row " + i + ", column " + label + "\n" +
                            file1.getName() + ": " + file1.getEntry(label, i) + "\n" +
                            file2.getName() + ": " + file2.getEntry(label, i));
                }
            }
        }
    }

    public String toString() {
        return this.name + "(" + this.getEntryCount() + " entries)";
    }

    /**
     * @see java.lang.Object#toString()
     */
    public String toOutputString() {
        String CRLF = "\r\n";
        StringBuffer toReturn = new StringBuffer();
        boolean evenColumns = true;
        String[] labels = this.getLabels();
        String toWrite;

        // Get the amount of padding used, if any
        int[] widths = new int[labels.length + 1];// All initialised to 0
        ArrayList<String> column;
        int pad;
        // Loop over columns
        for (int i = 0; i < labels.length; i++) {
            pad = labels[i].length();
            column = mainData.get(labels[i]);
            // Loop over rows
            for (int j = 0; j < this.getEntryCount(); j++) {
                toWrite = column.get(j);
                // If the string contains spaces, it needs to be wrapped in "
                if (toWrite.indexOf(" ") != -1)
                    toWrite = "\"" + toWrite + "\"";
                if (toWrite.length() > pad) pad = toWrite.length();
            }
            widths[i] = pad;
        }

        // The last entry in the array is used for the numbers column
        widths[widths.length - 1] = new Integer(this.getEntryCount()).toString().length();

        // Write the header and default lines
        toReturn.append("2DA V2.0" + CRLF);
        if (!defaultValue.equals(""))
            toReturn.append("DEFAULT: " + defaultValue + CRLF);
        else
            toReturn.append(CRLF);

        // Write the labels row using the original case
        for (int i = 0; i < widths[widths.length - 1]; i++) toReturn.append(" ");
        for (int i = 0; i < realLabels.size(); i++) {
            toReturn.append(" " + realLabels.get(i));
            for (int j = 0; j < widths[i] - realLabels.get(i).length(); j++) toReturn.append(" ");
        }
        toReturn.append((TLKEditCompatible ? " " : "") + CRLF);

        // Write the data
        for (int i = 0; i < this.getEntryCount(); i++) {
            // Write the number row and it's padding
            toReturn.append("" + i);
            for (int j = 0; j < widths[widths.length - 1] - new Integer(i).toString().length(); j++)
                toReturn.append(" ");
            // Loop over columns
            for (int j = 0; j < labels.length; j++) {
                toWrite = mainData.get(labels[j]).get(i);
                // If the string contains spaces, it needs to be wrapped in "
                if (toWrite.indexOf(" ") != -1)
                    toWrite = "\"" + toWrite + "\"";
                toReturn.append(" " + toWrite);
                // Write padding
                for (int k = 0; k < widths[j] - toWrite.length(); k++) toReturn.append(" ");
            }
            toReturn.append((TLKEditCompatible ? " " : "") + CRLF);
        }

        return toReturn.toString();
    }

    /**
     * Makes an independent copy of this 2da.
     *
     * @see java.lang.Object#clone()
     */
    @SuppressWarnings("unchecked")
    public Object clone() {
        // Make a sufficiently deep copy of the main data arrays
        LinkedHashMap<String, ArrayList<String>> cloneData = new LinkedHashMap<String, ArrayList<String>>();
        for (String key : this.getLabels()) // Use real labels to preserve order
            cloneData.put(key, (ArrayList<String>) this.mainData.get(key).clone());


        // Create a new Data_2da. The Strings are immutable, so they can be used as-is and clone()
        // on an array produces a sufficiently deep copy right away
        return new Data_2da(
                this.name,
                this.defaultValue,
                (ArrayList<String>) this.realLabels.clone(),
                cloneData
        );
    }
}