using System;
using System.Reflection;
using System.Resources;
using System.Text;

namespace HakInstaller.Utilities
{
	/// <summary>
	/// This class is used to manipulate the assembly's string resources.
	/// </summary>
	public class StringResources
	{
		#region public static properties/methods
		/// <summary>
		/// Gets the specified string from the string resource file.
		/// </summary>
		/// <param name="name">The name of the string to load</param>
		/// <returns>The string value</returns>
		public static string GetString(string name)
		{
			return singleton.rm.GetString(name);
		}

		/// <summary>
		/// Gets the specified format string from the string resource file, formatting
		/// it with the passed string arguments.
		/// </summary>
		/// <param name="name">The name of the format string to load</param>
		/// <param name="args">The string format arguments</param>
		/// <returns>The formatted string value</returns>
		public static string GetString(string name, params object[] args)
		{
			// Get the format string from the resource file and
			// format it with the passed arguments.
			string format = singleton.rm.GetString(name);
			singleton.builder.Length = 0;
			singleton.builder.AppendFormat(format, args);
			return singleton.builder.ToString();
		}
		#endregion

		#region private fields/properties/methods
		/// <summary>
		/// Class constructor made private because class is a singleton.
		/// </summary>
		private StringResources()
		{
			builder = new StringBuilder();
			rm = new ResourceManager("HakInstaller.strings", Assembly.GetExecutingAssembly());
		}

		private static StringResources singleton = new StringResources();

		private StringBuilder builder;
		private ResourceManager rm;
		#endregion
	}
}
