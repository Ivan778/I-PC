using System;
using System.Linq;
using System.Management;

namespace DeviceManager
{
    public class DeviceInfo
    {
        private ManagementObject Device { get; }
        private ManagementObject Driver { get; }

        public DeviceInfo(ManagementObject device, ManagementObject driver)
        {
            Device = device;
            Driver = driver;
        }

        public string GetName()
        {
            return Device["Name"]?.ToString() ?? "";
        }

        public string GetGuid()
        {
            return Device["ClassGuid"]?.ToString() ?? "";
        }

        public string GetHardware()
        {
            if (Device["HardwareID"] is string[] hardware)
            {
                return hardware.Where(temp => temp != "(null)").Aggregate(string.Empty, (current, temp) => current + (temp + "\t"));
            }
            return "";
        }

        public string GetManufacturer()
        {
            return Device["Manufacturer"]?.ToString() ?? "";
        }

        public string GetDriverDescription()
        {
            return Driver?["Description"]?.ToString() ?? "";
        }

        public string GetDriverPath()
        {
            return Driver?["PathName"]?.ToString() ?? "";
        }

        public bool GetStatus()
        {
            return Convert.ToInt32(Device["ConfigManagerErrorCode"]) == 22;
        }
    }
}
