using System;
using System.Collections;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Threading;
using System.Windows.Forms;
using HakInstaller.Utilities;
using NWN;

namespace HakInstaller
{
	/// <summary>
	/// Class to contain the application's main method.
	/// </summary>
	public class MainContainer
	{
		#region private static fields/properties/methods
		private static bool consoleMode = false;
		private static bool installPathGiven = false;
		private static StringCollection hifStrings = new StringCollection();
		private static StringCollection moduleStrings = new StringCollection();

		/// <summary>
		/// Either displays the message in a message box or on the command line,
		/// depending on whether the application is running in console mode or not.
		/// </summary>
		/// <param name="format">The format string</param>
		/// <param name="args">The format arguments</param>
		private static void ShowMessage(string format, params object[] args)
		{
			System.Text.StringBuilder b = new System.Text.StringBuilder();
			b.AppendFormat(format, args);

			if (consoleMode)
				Console.WriteLine(b.ToString());
			else
				MessageBox.Show(b.ToString(), "Error", MessageBoxButtons.OK,
					MessageBoxIcon.Error);
		}

		/// <summary>
		/// Validates all of the files in the collection to make sure that they
		/// exist.
		/// </summary>
		/// <param name="files">The list of files to validate</param>
		/// <returns>True if all files exist</returns>
		private static bool ValidateFiles(StringCollection files)
		{
			// Make sure all of the source files exist.
			foreach (string file in files)
				if (!File.Exists(Path.Combine(NWNInfo.GetPathForFile(file), file)))
				{
					ShowMessage("The file {0} does not exist", file);
					return false;
				}

			return true;
		}

		/// <summary>
		/// Runs the application in console mode, silently adding the haks to
		/// the modules given on the command line.
		/// </summary>
		/// <returns>0 if successful, otherwise -1</returns>
		private static int ConsoleMode()
		{
			// Validate the files, if we fail validation then exit now.
			if (!ValidateFiles(hifStrings) || !ValidateFiles(moduleStrings))
				return -1;

			// Convert the string collections to arrays and install the haks
			// in the modules.
			string[] hifs = new string[hifStrings.Count];
			hifStrings.CopyTo(hifs, 0);
			string[] modules = new string[moduleStrings.Count];
			moduleStrings.CopyTo(modules, 0);

			try
			{
				HakInstaller.InstallHaks(hifs, modules, null);
			}
			catch (Exception e)
			{
				Console.WriteLine(e.Message);
			}
			return 0;
		}

		/// <summary>
		/// Terminates the application.
		/// </summary>
		/// <param name="showHelp">True if help should be displayed.</param>
		private static void Terminate(bool showHelp)
		{
			if (showHelp) Help();
			throw new EntryPointNotFoundException();
		}

		/// <summary>
		/// Displays help
		/// </summary>
		private static void Help()
		{
			Console.WriteLine("HakInstaller: install hak/erf/tlk files in modules");
			Console.WriteLine("Usage: HakInstaller -n<path> file.hif/mod ...");
			Console.WriteLine("    -n<path>:Specifies the NWN install path, if this is not given");
			Console.WriteLine("             then it will be read from the registry.");
			Console.WriteLine("");
			Console.WriteLine("One or more .hif and .mod files may be specified on the command");
			Console.WriteLine("line, if none are given a UI will be displayed allowing you to");
			Console.WriteLine("choose the hif/mod files.  Paths should not be given on the files");
			Console.WriteLine("they will be searched for in the appropriate subdirectories of");
			Console.WriteLine("the NWN install path (as either given on the command line or read");
			Console.WriteLine("from the registry).");
		}

		/// <summary>
		/// Processes command line arguments.
		/// </summary>
		/// <param name="args"></param>
		private static void ProcessArguments(string[] args)
		{
			foreach (string arg in args)
			{
				// Process any command line switches.
				if ('-' == arg[0] || '/' == arg[1])
				{
					switch (arg[1])
					{
						case 'n':
						case 'N':
							// The NWN install path was specified on the command line,
							// save it to override whatever is in the registry.
							installPathGiven = true;
							NWNInfo.InstallPath = arg.Substring(2);

							// Make sure that the directory exists.
							if (!Directory.Exists(NWNInfo.InstallPath))
							{
								ShowMessage("The path '{0}' does not exist.", NWNInfo.InstallPath);
								Terminate(false);
							}
							break;
						default:
							Help();
							break;
					}
				}
				else
				{
					// If we get a hif or module on the command line then we
					// are in console mode.
					consoleMode = true;

					string extension = Path.GetExtension(arg);
					if (0 == string.Compare(".hif", extension, true))
						hifStrings.Add(arg);
					else if (0 == string.Compare(".mod", extension, true))
						moduleStrings.Add(arg);
					else
					{
						Console.WriteLine("Unknown file {0}\n", arg);
						Terminate(true);
					}
				}
			}

			// We must have at least one hif and one mod if we are in console mode.
			if (consoleMode && (0 == hifStrings.Count || 0 == moduleStrings.Count))
			{
				Console.WriteLine("Must specify at least one .mod and one .hif file\n");
				Terminate(true);
			}
		}

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static int Main(string[] args) 
		{
			try
			{
				// Process command line arguments.
				ProcessArguments(args);

				// Make sure NWN is installed before doing anything.  If the user
				// gave an install path on the command line we could be installing on
				// a remote machine, so do not check for an install on this machine.
				if (!installPathGiven && !NWNInfo.IsInstalled)
				{
					ShowMessage("Neverwinter Nights is not installed");
					return -1;
				}

				if (consoleMode)
					return ConsoleMode();
				else
				{
					// Requires .NET framework 1.1
					//Application.EnableVisualStyles();
					Application.Run(new InstallForm());
					return 0;
				}
			}
			catch (EntryPointNotFoundException)
			{
				// Dummy exception thrown to terminate the application by Help(),
				// don't display anything just return -1.
				return -1;
			}
			catch (Exception e)
			{
				ShowMessage(e.Message);
				return -1;
			}
		}
		#endregion
	}
}
