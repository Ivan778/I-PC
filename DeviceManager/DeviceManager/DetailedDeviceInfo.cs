using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DeviceManager
{
    public partial class DetailedDeviceInfo : Form
    {
        public DetailedDeviceInfo(DeviceInfo device)
        {
            InitializeComponent();

            Hardware.Text = device.GetHardware();
            Guid.Text = device.GetGuid();
            Manufacturer.Text = device.GetManufacturer();
            DrDescription.Text = device.GetDriverDescription();
            DrPath.Text = device.GetDriverPath();
            DevPath.Text = device.GetDeviceID();

            Text = device.GetName();
        }

        public sealed override string Text
        {
            get => base.Text;
            set => base.Text = value;
        }
    }
}
