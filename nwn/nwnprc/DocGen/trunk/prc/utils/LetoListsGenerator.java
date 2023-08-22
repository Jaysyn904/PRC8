package prc.utils;

import prc.autodoc.*;

import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.util.ArrayList;

import static prc.Main.err_pr;

/**
 * A class for generating Leto XML files from 2da and TLK.
 *
 * @author Ornedan
 */
public final class LetoListsGenerator {
    private final Data_TLK defaultTLK;
    private final Data_TLK userTLK;

    private LetoListsGenerator(Data_TLK defaultTLK, Data_TLK userTLK) {
        this.defaultTLK = defaultTLK;
        this.userTLK = userTLK;
    }

    private String getTLK(int num) {
        return num < 0x01000000 ? defaultTLK.getEntry(num) : userTLK.getEntry(num);
    }

    /**
     * Prints the given 2da into a Leto XML file.
     *
     * @param toPrint    Data_2da containing the 2da to print
     * @param nameColumn The name of the column that defines the name of the entry in TLK
     * @param os         The outputstream to write the xml to
     */
    public void printData2daAsLetoXML(Data_2da toPrint, String nameColumn, OutputStream os) {
        PrintStream ps = new PrintStream(os, true);
        StringBuilder sb;
        // Print header
        ps.println("<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>");
        ps.println("<LetoList comment=\"Created with a Java-based tool\">");

        // Print contents
        for (int i = 0; i < toPrint.getEntryCount(); i++) {
            if (!toPrint.getBiowareEntry(nameColumn, i).equals("")) {
                sb = new StringBuilder("  <item index=\"" + i + "\" ");
                for (String column : toPrint.getLabels()) {
                    sb.append(column.toLowerCase() + "=\"" + toPrint.getBiowareEntry(column, i) + "\" ");
                }

                if (!getTLK(Integer.parseInt(toPrint.getBiowareEntry(nameColumn, i))).equals(""))
                    sb.append(">" + getTLK(Integer.parseInt(toPrint.getBiowareEntry(nameColumn, i))) + "</item>");
                else
                    sb.append("/>");

                ps.println(sb);
            }
        }

        // Print closing tag
        ps.println("</LetoList>");

        ps.flush();
        ps.close();
    }

    /**
     * Ye olde main methode.
     *
     * @param args The parameters
     * @throws Throwable
     */
    public static void main(String[] args) throws Throwable {
        if (args.length == 0) readMe();
        String defaultTLKPath = null;
        String userTLKPath = null;
        ArrayList<String> twoDANames = new ArrayList<String>();
        ArrayList<String> columnNames = new ArrayList<String>();

        for (String param : args) {//[-crmnqs] file... | -
            // Parameter parseage
            if (param.startsWith("-")) {
                if (param.equals("--help")) readMe();
                else {
                    for (char c : param.substring(1).toCharArray()) {
                        switch (c) {

                            default:
                                err_pr.println("Error: Unknown parameter: " + c);
                                readMe();
                        }
                    }
                }
            } else {
                if (defaultTLKPath == null)
                    defaultTLKPath = param;
                else if (userTLKPath == null)
                    userTLKPath = param;
                else {
                    if (twoDANames.size() == columnNames.size())
                        twoDANames.add(param);
                    else
                        columnNames.add(param);
                }
            }
        }

        if (defaultTLKPath == null || userTLKPath == null || twoDANames.size() != columnNames.size()) {
            System.err.println("Error! Missing parameters");
            readMe();
        }

        LetoListsGenerator llg = new LetoListsGenerator(new Data_TLK(defaultTLKPath), new Data_TLK(userTLKPath));
        Data_2da twoDA;
        for (int i = 0; i < twoDANames.size(); i++) {
            twoDA = Data_2da.load2da(twoDANames.get(i));
            llg.printData2daAsLetoXML(twoDA, columnNames.get(i), new FileOutputStream("nwn-" + twoDA.getName().toLowerCase() + ".xml"));
        }
    }

    private static void readMe() {
        System.out.println("Usage:\n" +
                "  pathToDefaultTLK pathToUserTLK [pathTo2da namecolumn]+\n" +
                "\n" +
                "  --help  prints this text\n" +
                "\n" +
                "\n" +
                "\n" +
                "Creates xml files for use with Leto editor based on the given files.\n" +
                "Requires default.tlk, an user tlk and any numbers of 2da and column\n" +
                "name pairs. The column name is used for fetching the name of the line\n" +
                "from TLK.\n"
        );
        System.exit(0);
    }
}
