using System;
using System.Drawing;
using System.Collections;
using System.Collections.Specialized;
using System.ComponentModel;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using HakInstaller;
using HakInstaller.Utilities;

namespace HakInstaller
{
	/// <summary>
	/// This form displays is a comfirmation box asking the user if the
	/// application should continue with replacing the listed files with
	/// files from added hak(s).
	/// </summary>
	public class OverwriteWarningsForm : System.Windows.Forms.Form
	{
		#region public properties/methods
		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="conflicts">The list of file conflicts.</param>
		public OverwriteWarningsForm(OverwriteWarningCollection warnings, 
			bool fatal, OverwriteWarningType type)
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			pictureBox.Image = SystemIcons.Exclamation.ToBitmap();

			// There appears to be a bug in the 1.0 version of the framework.  On my
			// 3.2ghz machine, if listBox.Items.Add(conflict) is placed in the
			// foreach array it hangs, unless you slow it down somehow.  Moving
			// the add outside the loop and changing it to an AddRange() to add all
			// of the conflicts in one shot makes it work correctly, thus the change
			// to the code.

			// Add all of the conflicts to the list box.
			ListViewItem[] items = new ListViewItem[warnings.Count];
			for (int i = 0; i < warnings.Count; i++)
				items[i] = new ListViewItem(new String[] 
					{ warnings[i].Replacer, warnings[i].File, warnings[i].Source });
			listView.Items.AddRange(items);

			// Load the appropriate prompt text.
			labelPrompt.Text = StringResources.GetString(type.ToString());

			// If we have fatal errors then turn off the continue button, the user
			// can only cancel.
			if (fatal) buttonContinue.Enabled = false;
		}
		#endregion

		#region protected fields/properties/methods
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}
		#endregion

		#region functionality for Win32 PlaySound API
		[Flags] private enum SoundFlags
		{
			Sync		= 0x00000000,	/* play synchronously (default) */
			Async		= 0x00000001,	/* play asynchronously */
			NoDefault	= 0x00000002,	/* silence (!default) if sound not found */
			Memory		= 0x00000004,	/* pszSound points to a memory file */
			Loop		= 0x00000008,	/* loop the sound until next sndPlaySound */
			NoStop		= 0x00000010,	/* don't stop any currently playing sound */
			NoWait		= 0x00002000,	/* don't wait if the driver is busy */
			Alias		= 0x00010000,	/* name is a registry alias */
			AliasId		= 0x00110000,	/* alias is a pre d ID */
			Filename	= 0x00020000,	/* name is file name */
			Resource	= 0x00040004,	/* name is resource name or atom */
			Purge		= 0x00000040,	/* purge non-static events for task */
			Application	= 0x00000080	/* look for application specific association */
		}

		public static void PlaySoundEvent(string sound)
		{
			PlaySound(sound, 0, 
				(int) (SoundFlags.Async | SoundFlags.Alias | SoundFlags.NoWait));
		}

		[DllImport("winmm.dll", EntryPoint="PlaySound",CharSet=CharSet.Auto)]
		private static extern int PlaySound(String pszSound, int hmod, int flags);
		#endregion

		#region Windows Form Designer generated code

		private System.Windows.Forms.Button buttonContinue;
		private System.Windows.Forms.Button button2;
		private System.Windows.Forms.PictureBox pictureBox;
		private System.Windows.Forms.Label labelPrompt;
		private System.Windows.Forms.ListView listView;
		private System.Windows.Forms.ColumnHeader columnFile;
		private System.Windows.Forms.ColumnHeader columnReplacer;
		private System.Windows.Forms.ColumnHeader columnSource;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.labelPrompt = new System.Windows.Forms.Label();
			this.buttonContinue = new System.Windows.Forms.Button();
			this.button2 = new System.Windows.Forms.Button();
			this.pictureBox = new System.Windows.Forms.PictureBox();
			this.listView = new System.Windows.Forms.ListView();
			this.columnReplacer = new System.Windows.Forms.ColumnHeader();
			this.columnFile = new System.Windows.Forms.ColumnHeader();
			this.columnSource = new System.Windows.Forms.ColumnHeader();
			this.SuspendLayout();
			// 
			// labelPrompt
			// 
			this.labelPrompt.Location = new System.Drawing.Point(72, 16);
			this.labelPrompt.Name = "labelPrompt";
			this.labelPrompt.Size = new System.Drawing.Size(488, 40);
			this.labelPrompt.TabIndex = 0;
			this.labelPrompt.Text = "Some modules already have some of the content you selected installed.  Do you wis" +
				"h to continue?  The install may not work if you continue.";
			// 
			// buttonContinue
			// 
			this.buttonContinue.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.buttonContinue.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.buttonContinue.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.buttonContinue.Location = new System.Drawing.Point(16, 296);
			this.buttonContinue.Name = "buttonContinue";
			this.buttonContinue.Size = new System.Drawing.Size(80, 26);
			this.buttonContinue.TabIndex = 2;
			this.buttonContinue.Text = "C&ontinue";
			// 
			// button2
			// 
			this.button2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.button2.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.button2.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.button2.Location = new System.Drawing.Point(112, 296);
			this.button2.Name = "button2";
			this.button2.Size = new System.Drawing.Size(80, 26);
			this.button2.TabIndex = 3;
			this.button2.Text = "&Cancel";
			// 
			// pictureBox
			// 
			this.pictureBox.Location = new System.Drawing.Point(24, 16);
			this.pictureBox.Name = "pictureBox";
			this.pictureBox.Size = new System.Drawing.Size(32, 32);
			this.pictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
			this.pictureBox.TabIndex = 3;
			this.pictureBox.TabStop = false;
			// 
			// listView
			// 
			this.listView.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.listView.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
																					   this.columnReplacer,
																					   this.columnFile,
																					   this.columnSource});
			this.listView.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
			this.listView.Location = new System.Drawing.Point(16, 72);
			this.listView.MultiSelect = false;
			this.listView.Name = "listView";
			this.listView.Size = new System.Drawing.Size(568, 208);
			this.listView.Sorting = System.Windows.Forms.SortOrder.Ascending;
			this.listView.TabIndex = 4;
			this.listView.View = System.Windows.Forms.View.Details;
			// 
			// columnReplacer
			// 
			this.columnReplacer.Text = "Overwriter";
			this.columnReplacer.Width = 150;
			// 
			// columnFile
			// 
			this.columnFile.Text = "File";
			this.columnFile.Width = 150;
			// 
			// columnSource
			// 
			this.columnSource.Text = "Source";
			this.columnSource.Width = 240;
			// 
			// OverwriteWarningsForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(600, 334);
			this.ControlBox = false;
			this.Controls.Add(this.listView);
			this.Controls.Add(this.pictureBox);
			this.Controls.Add(this.buttonContinue);
			this.Controls.Add(this.labelPrompt);
			this.Controls.Add(this.button2);
			this.MinimumSize = new System.Drawing.Size(608, 368);
			this.Name = "OverwriteWarningsForm";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Overwriting Existing Content";
			this.Load += new System.EventHandler(this.ReplacingFilesForm_Load);
			this.ResumeLayout(false);

		}
		#endregion

		#region form event handlers
		/// <summary>
		/// Handler for the load event.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void ReplacingFilesForm_Load(object sender, System.EventArgs e)
		{
			PlaySoundEvent("SystemExclamation");
		}
		#endregion

		#region control event handlers
		#endregion
	}
}
