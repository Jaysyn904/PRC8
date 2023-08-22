package prc.autodoc;

import javax.imageio.ImageIO;
import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.TimerTask;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import static prc.Main.err_pr;
import static prc.autodoc.Main.*;

/**
 * This class handles generating
 *
 * @author Ornedan
 */
public class Icons {

    /**
     * Visible from outside so that Main can wait on it.
     */
    public static ExecutorService executor;
    //private static Timer timer;

    private static boolean init = false;

    private static HashSet<String> existingIcons = null;

    private static HashMap<String, File> rawIcons = null;

    private static void init() {
		/*try{
			reader = Jimi.createTypedJimiReader("image/targa");
			writer = Jimi.createTypedJimiWriter("image/png");
		}catch(JimiException e){
			err_pr.printException(e);
			icons = false;
			return;
		}*/
        init = true;
        existingIcons = new HashSet<String>();
        ImageIO.setUseCache(false);
        //executor = new ThreadPoolExecutor(50, 1000, 60, TimeUnit.SECONDS, bq);
        //timer = new Timer("Checker", true);
        executor = Executors.newCachedThreadPool();

        rawIcons = new HashMap<String, File>();
        File[] tgas = new File("rawicons").listFiles(new FileFilter() {
            public boolean accept(File file) {
                return file.getName().toLowerCase().endsWith(".tga");
            }
        });

        // Ensure the icons directory exists
        if (tgas == null) {
            err_pr.println("Error: Icons directory is missing!");
            if (tolErr) return;
            else System.exit(1);
        }

        for (File tga : tgas)
            rawIcons.put(tga.getName().toLowerCase(), tga);
    }


    /**
     * Builds an &lt;img&gt;-tag pointing at a png-converted version of the
     * given icon.
     * If such an icon does not exist, returns a blank string.
     * The icon will be converted to PNG format if it has not yet been.
     *
     * @param iconName name of the icon to use
     * @return &lt;img&gt;-tag pointing at the image or a blank string
     */
    public static String buildIcon(String iconName) {
        if (!icons) return "";
        else if (!init) init();

        if (iconName.equals("****"))
            return "";

        // Lowercase the name
        iconName = iconName.toLowerCase();

        // Build the html
        String tag = iconTemplate.replace("~~~ImageURL~~~", "../../../images/" + iconName + ".png")
                .replace("~~~ImageName~~~", iconName);

        // Case of already existing and indexed image
        if (existingIcons.contains(iconName))
            return tag;

        File png = new File(imagePath + iconName + ".png");
        // See if the converted image exists already, but just hasn't been indexed yet
        if (png.exists()) {
            existingIcons.add(iconName);
            return tag;
        }

        File tga = rawIcons.get(iconName + ".tga");
        // There is no icon to convert
        if (tga == null) {
            err_pr.println("Error: Missing icon file: " + iconName + ".tga");
            return "";
        }

        // Schedule the conversion for execution
        Convert task = new Convert();
        task.init(tga, png);
        Future fut = executor.submit(task);


        // Schedule timer task
		/*
		Check check = new Check();
		      check.init(fut, iconName);
		timer.schedule(check, System.currentTimeMillis() + 30000);
		*/
		/*
		try{
			reader.setSource(new FileInputStream(new File("rawicons" + fileSeparator + iconName + ".tga")));
			writer.setSource(reader.getImage());
			writer.putImage(imagePath + iconName + ".png");
		}catch(Exception e){
			err_pr.printException(e);
			throw new RuntimeException(e);
		}
		*/
        // Assume eventual success and add the newly created image to the index
        existingIcons.add(iconName);

        return tag;
    }

    private static class Convert implements Runnable {
        private File inFile, outFile;

        /**
         * Initialization method
         *
         * @param inFile  input file, Targa format
         * @param outFile output file, Portable Network Graphics format
         */
        public void init(File inFile, File outFile) {
            this.inFile = inFile;
            this.outFile = outFile;
        }

        /**
         * @see java.lang.Runnable#run()
         */
        public void run() {
            try {
                if (!ImageIO.write(ImageIO.read(inFile), "png", outFile))
                    err_pr.println("Error: Failed to convert image " + inFile);
            } catch (IOException e) {
                err_pr.printException(e);
            }
        }
    }

    private static class Check extends TimerTask {
        private Future toCheck;
        private String iconName;

        /**
         * Initialization method
         *
         * @param toCheck  future representing the image conversion to check on
         * @param iconName name of the icon being converted by the task to check on
         */
        public void init(Future toCheck, String iconName) {
            this.toCheck = toCheck;
            this.iconName = iconName;
        }

        /**
         * @see java.util.TimerTask#run()
         */
        public void run() {
            if (!toCheck.isDone()) {
                toCheck.cancel(true);
                err_pr.println("Error: Failed icon conversion on file " + iconName + ".tga");
            }

            //executor.purge();
        }

    }
	/*
	public static void main(String[] args) throws Exception{
		
		System.out.println("Yar!");
		icons = true;
		iconTemplate = readTemplate("templates" + fileSeparator + "english" + fileSeparator + "icon.html");
		System.out.println(buildImg("test"));
		
		ImageIO.setUseCache(false);
		Iterator<ImageReader> it = ImageIO.getImageReadersByMIMEType("image/targa");
		while(it.hasNext())
			System.out.println(it.next().getFormatName());
		
		java.awt.image.BufferedImage buf = ImageIO.read(new File("isk_x1app.tga"));
		System.out.println("Tar!");
		ImageIO.write(buf, "png", new File("test.png"));
		System.out.println("Far!");
		
	}
	*/
}