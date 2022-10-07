using System;
using System.Collections;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Globalization;
using System.Reflection;
using System.Threading;
using System.Windows.Forms;
using HakInstaller.Utilities;
using NWN;
using NWN.FileTypes.Tools;

namespace HakInstaller
{
	/// <summary>
	/// Class to contain the application's main method.
	/// </summary>
	public class MainForm
	{
		#region public static properties/methods
		/// <summary>
		/// Gets the single hif to use for the installer, or string.Empty if there is no single hif.
		/// </summary>
		public static string Hif { get { return hif; } }
		#endregion

		#region private static fields/properties/methods
		private static bool installPathGiven = false;
		private static string hif = string.Empty;

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
			MessageBox.Show(b.ToString(), "Error", MessageBoxButtons.OK, 
				MessageBoxIcon.Error);
		}

		/// <summary>
		/// Terminates the application.
		/// </summary>
		private static void Terminate() { Terminate(string.Empty); }

		/// <summary>
		/// Terminates the application, displaying an error message
		/// </summary>
		/// <param name="format">Format string for the error message to display</param>
		/// <param name="args"></param>
		private static void Terminate(string format, params object[] args)
		{
			// Display the error message if one was given.
			if (string.Empty != format) ShowMessage(format, args);

			// Throw an EntryPointNotFoundException to terminate the application.
			throw new EntryPointNotFoundException();
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
								Terminate("The path '{0}' does not exist.", NWNInfo.InstallPath);
                            // the registry values were irrelevant so replace with sensible defaults
                            NWNInfo.Version = "1.69";
                            NWNInfo.IsXP1Installed = true;
                            NWNInfo.IsXP2Installed = true;
							break;
						case 'l':
						case 'L':
							// Turn logging on and set the minimum severity if it was given.
							NWNLogger.Logging = true;
							if (arg.Length > 2) NWNLogger.MinimumLogLevel = Convert.ToInt32(arg.Substring(2));
							break;
						default:
							Terminate("Unknown command line argument {0}", arg);
							break;
					}
				}
				else
				{
					// We can take one HIF on the command line, if this argument is a HIF and we
					// don't have our single HIF yet then save it, otherwise it is an invalid
					// command.
					if (0 == string.Compare(".hif", Path.GetExtension(arg), true, CultureInfo.InvariantCulture) && 
						string.Empty == hif)
						hif = arg;
					else
						Terminate("Unknown command line argument {0}", arg);
				}
			}
		}

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main(string[] args) 
		{
			try
			{
				// Set the log file name to be our application name.
				NWNLogger.LogFile = Application.ProductName + ".txt";

				// Process command line arguments.
				ProcessArguments(args);

				// Make sure NWN is installed before doing anything.  If the user
				// gave an install path on the command line we could be installing on
				// a remote machine, so do not check for an install on this machine.
				if (!installPathGiven && !NWNInfo.IsInstalled)
					Terminate("Neverwinter Nights is not installed");

				// Requires .NET framework 1.1
				// If we are running as the PRC installer or a single HIF OEM reskin, then
				// show our single HIF form, otherwise show the generic form.
				Application.EnableVisualStyles();
				if (string.Empty != hif)
					Application.Run(new SingleHIFInstallForm());
				else
					Application.Run(new InstallForm());
			}
			catch (EntryPointNotFoundException)
			{
				// Dummy exception thrown to terminate the application by Help(),
				// don't display anything just return -1.
			}
			catch (Exception e)
			{
				ShowMessage(e.Message);
			}
			finally
			{
				// Turn off logging in case it was on this will flush the file.
				NWNLogger.Logging = false;
			}
		}
		#endregion
	}
}
