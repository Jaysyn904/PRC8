package prc.autodoc;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.RandomAccessFile;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.stream.IntStream;
import java.util.HashMap;

import static prc.Main.spinner;
import static prc.Main.verbose;

/**
 * This class forms an interface for accessing TLK files in the
 * PRC automated manual generator.
 */
public class Data_TLK {
    private final HashMap<Integer, String> mainData = new HashMap<Integer, String>();
    private int highestEntry = 0;


    /**
     * Creates a new Data_TLK on the TLK file specified.
     *
     * @param filePath The path of the TLK file to be loaded
     * @throws IllegalArgumentException <code>filePath</code> does not filePath a TLK file
     * @throws TLKReadException         reading the TLK file specified does not succeed
     */
    public Data_TLK(String filePath) {
        // Some paranoia checking for bad parameters
        if (!filePath.toLowerCase().endsWith("tlk"))
            throw new IllegalArgumentException("Non-tlk filename passed to Data_TLK: " + filePath);

        File baseFile = new File(filePath);
        if (!baseFile.exists())
            throw new IllegalArgumentException("Nonexistent file passed to Data_TLK: " + filePath);
        if (!baseFile.isFile())
            throw new IllegalArgumentException("Nonfile passed to Data_TLK: " + filePath);


        // Create a RandomAccessFile for reading the TLK. Read-only
        MappedByteBuffer reader = null;
        RandomAccessFile fileReader;
        try {
            fileReader = new RandomAccessFile(baseFile, "r");
            reader = fileReader.getChannel().map(FileChannel.MapMode.READ_ONLY, 0, fileReader.length());
        } catch (IOException e) {
            throw new TLKReadException("Cannot access TLK file: " + filePath, e);
        }
        byte[] bytes4 = new byte[4],
                bytes8 = new byte[8];

        // Drop the path from the filename
        String fileName = baseFile.getName();

        // Tell the user what we are doing
        if (verbose) System.out.print("Reading TLK file: " + fileName + " ");

        try {
            // Check the header
            reader.get(bytes4);
            if (!new String(bytes4).equals("TLK "))
                throw new TLKReadException("Wrong file type field in: " + fileName);

            // Check the version
            reader.get(bytes4);
            if (!new String(bytes4).equals("V3.0"))
                throw new TLKReadException("Wrong TLK version number in: " + fileName);

            // Skip the language ID
            reader.position(reader.position() + 4);

            // Read the entrycount
            int stringCount = readLittleEndianInt(reader, bytes4);
            int stringOffset = readLittleEndianInt(reader, bytes4);

            // Read the entry lengths
            int[] stringLengths = readStringLengths(reader, stringCount);

            // Read the strings themselves
            readStrings(reader, stringLengths, stringOffset);

            // Store the highest string for writing back later
            highestEntry = stringLengths.length;
        } catch (IOException e) {
            throw new TLKReadException("IOException while reading TLK file: " + fileName, e);
        } finally {
            try {
                fileReader.close();
            } catch (IOException e) {
                // No idea under what conditions closing a file could fail and not cause an Error to be thrown...
                e.printStackTrace();
            }
        }

        if (verbose) System.out.println("- Done");
    }


    /**
     * Get the given TLK entry.
     *
     * @param strRef the number of the entry to get
     * @return the entry string or "Bad StrRef" if the entry wasn't in the TLK
     */
    public String getEntry(int strRef) {
        if (strRef > 0x01000000) strRef -= 0x01000000;
        String toReturn = mainData.get(strRef);
        if (toReturn == null) toReturn = Main.badStrRef;
        return toReturn;
    }


    /**
     * Get the given TLK entry.
     *
     * @param strRef the number of the entry to get as a string
     * @return the entry string or "Bad StrRef" if the entry wasn't in the TLK
     * @throws NumberFormatException if <code>strRef</code> cannot be converted to an integer
     */
    public String getEntry(String strRef) {
        try {
            return getEntry(Integer.parseInt(strRef));
        } catch (NumberFormatException e) {
            return Main.badStrRef;
        }
    }

    /**
     * Set the given TLK entry.
     *
     * @param strRef the number of the entry to set
     * @param value  the value of the entry to set
     */
    public void setEntry(int strRef, String value) {
        if (strRef > 0x01000000) strRef -= 0x01000000;
        mainData.put(strRef, value);
        if (strRef > highestEntry)
            highestEntry = strRef;
    }

    /**
     * Saves the tlk file to the given XML.
     *
     * @param name           the name of the resulting file, without extensions
     * @param path           the path to the directory to save the file to
     * @param allowOverWrite Whether to allow overwriting existing files
     * @throws IOException if cannot overwrite, or the underlying IO throws one
     */
    public void saveAsXML(String name, String path, boolean allowOverWrite) throws IOException {
        if (path == null || path.equals(""))
            path = "." + File.separator;
        if (!path.endsWith(File.separator))
            path += File.separator;

        File file = new File(path + name + ".tlk.xml");
        if (file.exists() && !allowOverWrite)
            throw new IOException("File exists already: " + file.getAbsolutePath());

        // Inform user
        if (verbose) System.out.print("Saving tlk file: " + name + " ");

        PrintWriter writer = new PrintWriter(file);

        //write the header
        writer.println("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>");
        writer.println("<!DOCTYPE tlk SYSTEM \"tlk2xml.dtd\">");
        writer.println("<tlk>");

        //loop over each row and write it
        for (int row = 0; row < highestEntry; row++) {
            String data = mainData.get(row);
            if (data != null) {
                //replace with paired characters
                data = data.replace("&", "&amp;"); //this must be before the others
                data = data.replace("<", "&lt;");
                data = data.replace(">", "&gt;");
                writer.println("  <entry id=\"" + row + "\" lang=\"en\" sex=\"m\">" + data + "</entry>");
            }
            if (verbose) spinner.spin();
        }

        //write the footer
        writer.println("</tlk>");

        writer.flush();
        writer.close();

        if (verbose) System.out.println("- Done");
    }


    /**
     * Reads the string lengths from this TLK's string data elements.
     *
     * @param reader      RandomAccessFile read from
     * @param stringCount number of strings in the TLK
     * @return an array of integers containing the lengths of the strings in this TLK
     * @throws IOException if there is an error while reading from <code>reader</code>
     */
    private int[] readStringLengths(MappedByteBuffer reader, int stringCount) throws IOException {
        int[] toReturn = new int[stringCount];
        byte[] bytes4 = new byte[4];
        int curOffset = 20; // The number of bytes in the TLK header section

        for (int i = 0; i < stringCount; i++) {
            // Skip everything up to the length
            curOffset += 32;
            reader.position(curOffset);
            // Read the value
            toReturn[i] = readLittleEndianInt(reader, bytes4);
            // Skip to the end of the record
            curOffset += 8;

            if (verbose) spinner.spin();
        }
        return toReturn;
    }

    /**
     * Reads the strings from the TLK into the hashmap.
     *
     * @param reader        RandomAccessFile read from
     * @param stringLengths an array of integers containing the lengths of the strings in this TLK
     * @param curOffset     the offset to start reading from in the file
     * @throws IOException if there is an error while reading from <code>reader</code>
     */
    private void readStrings(MappedByteBuffer reader, int[] stringLengths, int curOffset) throws IOException {
        StringBuffer buffer = new StringBuffer(200);
        reader.position(curOffset);

        for (int i = 0; i < stringLengths.length; i++) {
            if (stringLengths[i] > 0) {
                // Read the specified number of bytes, convert them into chars
                // and put them in the buffer
                for (int j = 0; j < stringLengths[i]; j++)
                    buffer.append((char) (reader.get() & 0xff));
                // Store the buffer contents
                mainData.put(i, buffer.toString());
                // Wipe the buffer for next round
                buffer.delete(0, buffer.length());
            }
            if (verbose) spinner.spin();
        }
    }

    /**
     * Reads the next 4 bytes into the given array from the TLK and then
     * writes them into an integer in inverse order.
     *
     * @param reader    RandomAccessFile read from
     * @param readArray array of bytes read to. For efficiency of not having to create a new array every time
     * @return integer read
     * @throws IOException if there is an error while reading from <code>reader</code>
     */
    private int readLittleEndianInt(MappedByteBuffer reader, byte[] readArray) throws IOException {
        int toReturn = 0;
        reader.get(readArray);
        for (int i = readArray.length - 1; i >= 0; i--) {
            // What's missing here is the implicit promotion of readArray[i] to
            // int. A byte is a signed element, and as such, has max value of 0x7f.
            toReturn = (toReturn << 8) | readArray[i] & 0xff;
        }
        return toReturn;
    }

    /**
     * The main method, as usual
     *
     * @param args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {
        Data_TLK test = new Data_TLK(args[0]);
    }
}