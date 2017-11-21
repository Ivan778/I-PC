using System;
using System.Linq;
using System.Management;

namespace DeviceManager
{
    public class DeviceInfo
    {
        private ManagementObject _device;
        private ManagementObject _driver;

        public DeviceInfo(ManagementObject device, ManagementObject driver)
        {
            _device = device;
            _driver = driver;
        }

        public string GetName()
        {
            if (_device["Name"] != null)
            {
                return _device["Name"].ToString();
            }
            return "";
        }

        public string GetGuid()
        {
            if (_device["ClassGuid"] != null)
            {
                return _device["ClassGuid"].ToString();
            }
            return "";
        }

        public string GetHardware()
        {
            var hardware = _device["HardwareID"] as string[];
            string result = string.Empty;
            foreach (var temp in hardware)
            {
                if (temp != "(null)")
                {
                    result += temp + "    ";
                }
            }
            return result;
        }

        public string GetManufacturer()
        {
            if (_device["Manufacturer"] != null)
            {
                return _device["Manufacturer"].ToString();
            }
            return "";
        }

        public string GetDeviceID()
        {
            if (_device["DeviceID"] != null)
            {
                return _device["DeviceID"].ToString();
            }
            return "";
        }

        public string GetDriverDescription()
        {
            if (_driver != null)
            {
                if (_driver["Description"] != null)
                {
                    return _driver["Description"].ToString();
                }
            }
            return "";
        }

        public string GetDriverPath()
        {
            if (_driver != null)
            {
                if (_driver["PathName"] != null)
                {
                    return _driver["PathName"].ToString();
                }
            }
            return "";
        }

        public bool GetStatus()
        {
            var code = _device["ConfigManagerErrorCode"];
            return Convert.ToInt32(code) == 22;
        }

        public bool DisableDevice()
        {
            try
            {
                _device.InvokeMethod("Disable", null);
            }
            catch (ManagementException)
            {
                return false;
            }
            catch (NullReferenceException e)
            {
                Console.WriteLine(e);
            }
            return true;
        }

        public bool EnableDevice()
        {
            try
            {
                _device.InvokeMethod("Enable", null);
            }
            catch (ManagementException)
            {
                return false;
            }
            catch (NullReferenceException e)
            {
                Console.WriteLine(e);
            }
            return true;
        }
    }
}
