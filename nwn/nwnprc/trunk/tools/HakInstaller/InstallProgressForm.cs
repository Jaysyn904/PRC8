using System;
using System.Drawing;
using System.Collections;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Windows.Forms;

namespace HakInstaller
{
	/// <summary>
	/// Summary description for InstallProgress.
	/// </summary>
	public class InstallProgressForm : System.Windows.Forms.Form,
		IHakInstallProgress
	{
		#region public properties/methods
		/// <summary>
		/// Class constructor
		/// </summary>
		public InstallProgressForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			cancelled = false;
			builder = new System.Text.StringBuilder();
		}
		#endregion

		#region IHakInstallProgress implementation
		/// <summary>
		/// Gets whether the user cancelled the install.
		/// </summary>
		bool IHakInstallProgress.IsCancelled { get { return cancelled; } }

		/// <summary>
		/// Gets/sets the number of steps for the progress bar.
		/// </summary>
		int IHakInstallProgress.ProgressSteps
		{
			get { return progressBar.Maximum; }
			set
			{
				progressBar.Minimum = 1;
				progressBar.Maximum = value;
				progressBar.Value = 1;
				progressBar.Step = 1;
			}
		}

		/// <summary>
		/// Advances the progress bar 1 step.
		/// </summary>
		void IHakInstallProgress.Step()
		{
			progressBar.PerformStep();
		}

		/// <summary>
		/// Sets the currently displayed progress message.
		/// </summary>
		/// <param name="format">Format string</param>
		/// <param name="args">Message arguments</param>
		void IHakInstallProgress.SetMessage(string format, params object[] args)
		{
			builder.Length = 0;
			builder.AppendFormat(format, args);
			labelMessage.Text = builder.ToString();
		}

		/// <summary>
		/// This methods should ask the user for confirmation of replacing
		/// the listed files in the module with files from sources in the
		/// hif files, as this operation may break the module.
		/// </summary>
		/// <param name="conflicts">The list of file conflicts</param>
		/// <returns>true if the files should be replaced, false if adding
		/// the hak(s) to the module should be aborted</returns>
		bool IHakInstallProgress.ShouldReplaceFiles(FileConflictCollection conflicts)
		{
			// Confirm the file replace operation with the user.
			ReplacingFilesForm form = new ReplacingFilesForm(conflicts);
			return DialogResult.OK == form.ShowDialog((Form) this);
		}

		/// <summary>
		/// This method should ask the user for confirmation of overwriting
		/// the listed files.  If fatal is true then there is no confirmation,
		/// it is just an informational message that the operation must be aborted.
		/// </summary>
		/// <param name="warnings">The list of warnings</param>
		/// <param name="fatal">True if the warnings are fatal</param>
		/// <param name="type">The type of overwrite being confirmed</param>
		/// <returns>True if the operation should proceed</returns>
		bool IHakInstallProgress.ShouldOverwrite(OverwriteWarningCollection warnings, 
			bool fatal, OverwriteWarningType type)
		{
			OverwriteWarningsForm form = new OverwriteWarningsForm(warnings, fatal, type);
			return DialogResult.OK == form.ShowDialog((Form) this);
		}

		/// <summary>
		/// Displays an error message to the user.
		/// </summary>
		/// <param name="error">The error message to display</param>
		void IHakInstallProgress.DisplayErrorMessage(string error)
		{
			MessageBox.Show(this, error, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
		}

		/// <summary>
		/// Displays a message to the user.
		/// </summary>
		/// <param name="error">The message to display</param>
		void IHakInstallProgress.DisplayMessage(string message)
		{
			MessageBox.Show(this, message, "Message", MessageBoxButtons.OK, MessageBoxIcon.Information);
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

		#region Windows Form Designer generated code
		private System.Windows.Forms.ProgressBar progressBar;
		private System.Windows.Forms.Label labelMessage;
		private System.Windows.Forms.Button buttonCancel;
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
			this.progressBar = new System.Windows.Forms.ProgressBar();
			this.labelMessage = new System.Windows.Forms.Label();
			this.buttonCancel = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// progressBar
			// 
			this.progressBar.Location = new System.Drawing.Point(16, 56);
			this.progressBar.Name = "progressBar";
			this.progressBar.Size = new System.Drawing.Size(344, 16);
			this.progressBar.TabIndex = 0;
			// 
			// labelMessage
			// 
			this.labelMessage.Location = new System.Drawing.Point(16, 16);
			this.labelMessage.Name = "labelMessage";
			this.labelMessage.Size = new System.Drawing.Size(344, 32);
			this.labelMessage.TabIndex = 1;
			this.labelMessage.Text = "label1";
			// 
			// buttonCancel
			// 
			this.buttonCancel.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.buttonCancel.Location = new System.Drawing.Point(16, 96);
			this.buttonCancel.Name = "buttonCancel";
			this.buttonCancel.Size = new System.Drawing.Size(72, 24);
			this.buttonCancel.TabIndex = 2;
			this.buttonCancel.Text = "&Cancel";
			this.buttonCancel.Click += new System.EventHandler(this.buttonCancel_Click);
			// 
			// InstallProgressForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(378, 136);
			this.ControlBox = false;
			this.Controls.Add(this.buttonCancel);
			this.Controls.Add(this.labelMessage);
			this.Controls.Add(this.progressBar);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "InstallProgressForm";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Installing Haks";
			this.ResumeLayout(false);

		}
		#endregion

		#region private fields/properties/methods
		private bool cancelled;
		private System.Text.StringBuilder builder;
		#endregion

		#region event handlers
		/// <summary>
		/// Event handler for the cancel button's click event.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void buttonCancel_Click(object sender, System.EventArgs e)
		{
			cancelled = true;
		}
		#endregion
	}
}
