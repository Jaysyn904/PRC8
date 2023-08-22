package prc.utils;

import prc.autodoc.*;

import java.io.File;
import java.io.FileWriter;

import static prc.Main.verbose;

public final class ItempropMaker {
    private ItempropMaker() {
    }


    private static Data_2da itempropdef2da;
    private static Data_2da costtable2da;
    private static Data_2da paramtable2da;
    private static Data_2da[] cost2daarray;
    private static Data_2da[] param12daarray;
    private static StringBuilder xml;


    public static void main(String[] args) throws Exception {
        //load the 2das
        itempropdef2da = Data_2da.load2da("2das" + File.separator + "itempropdef.2da", true);
        costtable2da = Data_2da.load2da("2das" + File.separator + "iprp_costtable.2da", true);
        paramtable2da = Data_2da.load2da("2das" + File.separator + "iprp_paramtable.2da", true);
        cost2daarray = new Data_2da[costtable2da.getEntryCount()];
        param12daarray = new Data_2da[paramtable2da.getEntryCount()];
        for (int i = 0; i < cost2daarray.length; i++) {
            cost2daarray[i] = Data_2da.load2da("2das" + File.separator + costtable2da.getBiowareEntry("Name", i) + ".2da", true);
        }
        for (int i = 0; i < param12daarray.length; i++) {
            param12daarray[i] = Data_2da.load2da("2das" + File.separator + paramtable2da.getBiowareEntry("TableResRef", i) + ".2da", true);
        }
        //loop over each row
        for (int itempropdef2darow = 85;
             itempropdef2darow < itempropdef2da.getEntryCount();
             itempropdef2darow++) {
            if (itempropdef2da.getBiowareEntryAsInt("Name", itempropdef2darow) != 0) {
                int type = itempropdef2darow;
                int subtype;
                int cost;
                int param1;
                if (itempropdef2da.getBiowareEntry("SubTypeResRef", type) == "")
                    subtype = 0;
                else
                    subtype = 1;
                if (itempropdef2da.getBiowareEntryAsInt("CostTableResRef", type) == 0)
                    cost = 0;
                else
                    cost = 1;
                if (itempropdef2da.getBiowareEntry("Param1ResRef", type) == "")
                    param1 = 0;
                else
                    param1 = 1;
                //loop over each subtype
                if (subtype != 0) {
                    Data_2da subtype2da = Data_2da.load2da("2das" + File.separator + itempropdef2da.getBiowareEntry("SubTypeResRef", type) + ".2da", true);

                    for (int subtypeID = 0; subtypeID < subtype2da.getEntryCount(); subtypeID++) {
                        //loop over the param1s, if applicable
                        //look if there is a column for it
                        boolean subtypeparam1columnexists = false;
                        String[] columnlabels = subtype2da.getLabels();
                        for (int i = 0; i < columnlabels.length; i++) {
                            if (columnlabels[i] == "Param1ResRef")
                                subtypeparam1columnexists = true;
                        }
                        if (subtypeparam1columnexists
                                && subtype2da.getBiowareEntry("Param1ResRef", subtypeID) == "") {
                            param1 = 1;
                        } else {
                            if (itempropdef2da.getBiowareEntry("Param1ResRef", type) == "")
                                param1 = 0;
                            else
                                param1 = 2;
                        }
                        if (param1 != 0) {
                            int param1tableid = 0;
                            if (param1 == 2)
                                param1tableid = itempropdef2da.getBiowareEntryAsInt("Param1ResRef", type);
                            else if (param1 == 1)
                                param1tableid = subtype2da.getBiowareEntryAsInt("Param1ResRef", subtypeID);
                            Data_2da param12da = param12daarray[param1tableid];
                            for (int param1ID = 0; param1ID < param12da.getEntryCount(); param1ID++) {
                                if (cost != 0) {
                                    int costtable = itempropdef2da.getBiowareEntryAsInt("CostTableResRef", type);
                                    Data_2da cost2da = cost2daarray[costtable];
                                    //has type, subtype, param1, and cost
                                    write(type, subtypeID, param1tableid, param1ID, costtable, cost2da.getEntryCount());
                                } else {
                                    //no cost
                                    //has type, subtype, and param1
                                    write(type, subtypeID, param1tableid, param1ID, -1, -1);
                                }
                            }
                        } else {
                            //no param1
                            if (cost != 0) {
                                int costtable = itempropdef2da.getBiowareEntryAsInt("CostTableResRef", type);
                                Data_2da cost2da = cost2daarray[costtable];
                                //has type, subtype, and cost
                                write(type, subtypeID, -1, -1, costtable, cost2da.getEntryCount());
                            } else {
                                //no cost
                                //has type, and subtype
                                write(type, subtypeID, -1, -1, -1, -1);
                            }
                        }
                    }
                } else {
                    //no subtype
                    if (param1 != 0) {
                        int param1tableid = itempropdef2da.getBiowareEntryAsInt("Param1ResRef", type);
                        Data_2da param12da = param12daarray[param1tableid];
                        for (int param1ID = 0; param1ID < param12da.getEntryCount(); param1ID++) {
                            if (cost != 0) {
                                int costtable = itempropdef2da.getBiowareEntryAsInt("CostTableResRef", type);
                                Data_2da cost2da = cost2daarray[costtable];
                                //has type, param1, and cost
                                write(type, -1, param1tableid, param1ID, costtable, cost2da.getEntryCount());
                            } else {
                                //no cost
                                //has type, and param1
                                write(type, -1, param1tableid, param1ID, -1, -1);
                            }
                        }
                    } else {
                        //no param1
                        if (cost != 0) {
                            int costtable = itempropdef2da.getBiowareEntryAsInt("CostTableResRef", type);
                            Data_2da cost2da = cost2daarray[costtable];
                            //has type, and cost
                            write(type, -1, -1, -1, costtable, cost2da.getEntryCount());
                        } else {
                            //no cost
                            //has type
                            write(type, -1, -1, -1, -1, -1);
                        }
                    }
                }
            }
        }
    }

    /*
    <!--  This file was generated by the NWNTools GFF to XML writer.
         http://nwntools.sf.net/
         ** Do not hand edit unless you know what you are doing. **

      -->
    - <gff name="master111.uti" type="UTI" version="V3.2">
    - <struct id="-1">
      <element name="TemplateResRef" type="11" value="master111" />
      <element name="BaseItem" type="5" value="111" />
      <element name="LocalizedName" type="12" value="83617" />
      <element name="Description" type="12" value="-1" />
      <element name="DescIdentified" type="12" value="-1" />
      <element name="Tag" type="10" value="master111" />
      <element name="Charges" type="0" value="0" />
      <element name="Cost" type="4" value="2" />
      <element name="Stolen" type="0" value="0" />
      <element name="StackSize" type="2" value="1" />
      <element name="Plot" type="0" value="0" />
      <element name="AddCost" type="4" value="0" />
      <element name="Identified" type="0" value="1" />
      <element name="Cursed" type="0" value="0" />
      <element name="ModelPart1" type="0" value="11" />
      <element name="ModelPart2" type="0" value="11" />
      <element name="ModelPart3" type="0" value="11" />
    - <element name="PropertiesList" type="15">
            <struct id="0" >
                <element name="PropertyName" type="2" value="85" />
                <element name="Subtype" type="2" value="6" />
                <element name="CostTable" type="0" value="28" />
                <element name="CostValue" type="2" value="0" />
                <element name="Param1" type="0" value="0" />
                <element name="Param1Value" type="0" value="0" />
                <element name="ChanceAppear" type="0" value="100" />
            </struct>
    - <struct id="0">
      <element name="PropertyName" type="2" value="12" />
      <element name="Subtype" type="2" value="37" />
      <element name="CostTable" type="0" value="0" />
      <element name="CostValue" type="2" value="0" />
      <element name="Param1" type="0" value="255" />
      <element name="Param1Value" type="0" value="0" />
      <element name="ChanceAppear" type="0" value="100" />
      </struct>
      </element>
      <element name="PaletteID" type="0" value="47" />
      <element name="Comment" type="10" value="" />
      </struct>
  </gff>
  */
    private static void write(int type, int subtype, int param1table, int param1value, int costtable,
                              int costmax) throws Exception {

        xml = new StringBuilder(0xFFFFF);
        //assemble the resref/tag
        String resref = "prc_ip" + type;
        if (subtype != -1)
            resref += "_" + subtype;
        if (param1value != -1)
            resref += "_" + param1value;
        //sanity checks
        if (param1value == -1)
            param1value = 0;
        if (param1table == -1)
            param1table = 255;
        if (subtype == -1)
            subtype = 0;
        if (costtable == -1)
            costtable = 0;
        if (costmax == -1)
            costmax = 0;
        //output stuff
        //header things first
        xml.append("<gff name=\"" + resref + ".uti\" type=\"UTI \" version=\"V3.2\">\n");
        xml.append("    <struct id=\"-1\">\n");
        xml.append("		<element name=\"TemplateResRef\" type=\"11\" value=\"" + resref + "\" />\n");
        xml.append("		<element name=\"BaseItem\" type=\"5\" value=\"78\" />\n");
        xml.append("		<element name=\"LocalizedName\" type=\"12\" value=\"-1\" >\n");
        xml.append("            <localString languageId=\"0\" value=\"0\" />\n");
        xml.append("        </element>\n");
        xml.append("		<element name=\"Description\" type=\"12\" value=\"-1\" />\n");
        xml.append("		<element name=\"DescIdentified\" type=\"12\" value=\"-1\" />\n");
        xml.append("		<element name=\"Tag\" type=\"10\" value=\"" + resref + "\" />\n");
        xml.append("		<element name=\"Charges\" type=\"0\" value=\"0\" />\n");
        xml.append("		<element name=\"Cost\" type=\"4\" value=\"2\" />\n");
        xml.append("		<element name=\"Stolen\" type=\"0\" value=\"0\" />\n");
        xml.append("		<element name=\"StackSize\" type=\"2\" value=\"1\" />\n");
        xml.append("		<element name=\"Plot\" type=\"0\" value=\"0\" />\n");
        xml.append("		<element name=\"AddCost\" type=\"4\" value=\"0\" />\n");
        xml.append("		<element name=\"Identified\" type=\"0\" value=\"1\" />\n");
        xml.append("		<element name=\"Cursed\" type=\"0\" value=\"0\" />\n");
        xml.append("		<element name=\"ModelPart1\" type=\"0\" value=\"1\" />\n");
        xml.append("		<element name=\"PropertiesList\" type=\"15\">\n");
        //loop over the itemproperties
        for (int i = 0; i < costmax; i++) {
            xml.append("			<struct id=\"0\" >\n");
            xml.append("	    		<element name=\"PropertyName\" type=\"2\" value=\"" + type + "\" />\n");
            xml.append("	    	    <element name=\"Subtype\" type=\"2\" value=\"" + subtype + "\" />\n");
            xml.append("	    	    <element name=\"CostTable\" type=\"0\" value=\"" + costtable + "\" />\n");
            xml.append("	    	    <element name=\"CostValue\" type=\"2\" value=\"" + i + "\" />\n");
            xml.append("	    	    <element name=\"Param1\" type=\"0\" value=\"" + param1table + "\" />\n");
            xml.append("	    	    <element name=\"Param1Value\" type=\"0\" value=\"" + param1value + "\" />\n");
            xml.append("	    	    <element name=\"ChanceAppear\" type=\"0\" value=\"100\" />\n");
            xml.append("	    	</struct>\n");
        }
        //footer stuff
        xml.append("		</element>\n");
        //this is set to 99 so it will not appear in the palette :)
        xml.append("		<element name=\"PaletteID\" type=\"0\" value=\"99\" />\n");
        xml.append("		<element name=\"Comment\" type=\"10\" value=\"\" />\n");
        xml.append("    </struct>\n");
        xml.append("</gff>");

        File target = new File("xml_temp" + File.separator + resref + ".uti.xml");
        // Clean up old version if necessary
        if (target.exists()) {
            if (verbose) System.out.println("Deleting previous version of " + target.getName());
            target.delete();
        }
        if (verbose) System.out.println("Writing brand new version of " + target.getName());
        target.createNewFile();

        // Creater the writer and print
        FileWriter writer = new FileWriter(target, true);
        writer.write(xml.toString());
        // Clean up
        writer.flush();
        writer.close();
        // Force garbage collection
        System.gc();
    }
}