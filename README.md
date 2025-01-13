<p align="center">
  <img src="https://github.com/ZeroEthical/Elevate/blob/main/image.jpeg" alt="ZeroEthical">
</p>

# 🔑 Elevate: A Deep Dive into Windows Privilege Escalation via `fodhelper.exe`

**Elevate** is a meticulously crafted Batch script designed for educational purposes and security assessments. It provides a practical demonstration of a common privilege escalation technique in Windows environments, specifically targeting the `fodhelper.exe` mechanism. This script serves as a valuable tool for **cybersecurity professionals**, **penetration testers**, **system administrators**, and **security researchers** seeking to understand the intricacies of local privilege escalation vulnerabilities.

## 🎯 Purpose and Learning Objectives

This script is not intended for malicious activities. Its primary goals are to:

* **Illustrate the `fodhelper.exe` bypass:**  Provide a clear and functional example of how the `fodhelper.exe` utility can be leveraged to gain elevated privileges.
* **Demystify Windows security mechanisms:** Offer insights into the behavior of User Account Control (UAC) and how specific system components can be exploited.
* **Facilitate hands-on learning:** Allow users to experiment with privilege escalation techniques in a controlled and safe environment.
* **Raise awareness of security vulnerabilities:** Highlight the importance of secure system configurations and patching to mitigate such risks.

## ✨ Core Functionality

Elevate performs the following actions in a systematic manner:

1. **Privilege Check:**  The script begins by verifying its current execution context to determine if it already possesses administrative privileges.
2. **Conditional Execution:** If administrative privileges are not detected, the script proceeds with the elevation attempt. Otherwise, it informs the user that it's already running with sufficient rights.
3. **Temporary File Creation:**  To facilitate the exploitation, the script creates two temporary files within the `%temp%` directory:
    * `help.bat`: A basic batch file that simply calls the original script.
    * `run.vbs`: A VBScript file designed to execute `help.bat` in a potentially elevated context.
4. **Registry Manipulation (The Key):** This is the crucial step. The script modifies specific registry entries under `HKCU\Software\Classes\ms-settings\shell\open\command`. By manipulating the default value and the `DelegateExecute` value, the script intercepts the execution flow of `fodhelper.exe`.
5. **Triggering the Vulnerability:** The script then launches `fodhelper.exe`. Due to the registry modifications, instead of its intended function, `fodhelper.exe` executes the previously created VBScript, effectively running the original script with elevated privileges.
6. **Payload Execution (Placeholder):** A designated section within the script (`REM ADD Your code below`) serves as a placeholder where you can insert commands or scripts that you want to execute with the newly acquired administrative privileges.
7. **Clean-up Operation:**  Crucially, after a brief delay, the script diligently removes the registry entries it created, minimizing its footprint and restoring the system's registry to its previous state (regarding these specific keys).
8. **User Feedback:** Throughout the process, the script provides informative messages to the user, indicating the current stage of execution and the outcome of the privilege escalation attempt.

## 🚀 Getting Started

1. **Download the Script:** Obtain a copy of the `elevate.bat` file.
2. **Save to Your System:** Store the script in a location of your choosing on your Windows machine.
3. **Run the Script:** Double-click the `elevate.bat` file to execute it. You may be prompted by User Account Control (UAC). Observe the script's output in the command prompt window.

```bash
REM Example of running the script from the command line
C:\Users\YourUser\Downloads> elevate.bat
