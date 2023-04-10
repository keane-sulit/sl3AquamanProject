# **A Steganographic Text Encryption and Decryption Application in MATLAB**

## A fully functional MATLAB application that can encrypt and decrypt text using steganography.

- [Overview](#overview)
- [Files](#files)
- [Features](#features)
  * [Main Features](#main-features)
  * [Additional Features](#additional-features)
  * [Error Handling Features](#error-handling-features)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)
# **Overview**
###### ***DISCLAIMER:*** *This project is for educational purposes only. The authors are not responsible for any misuse of the application.*

This project was created as a partial fulfillment of the requirements for the course **LBYEC4A - Signals, Spectra, and Signal Processing Laboratory** at **De La Salle University - Manila**. Every line of code was written by **Team Aquaman**, composed of [**Rocelle Belandres**](), [**Jelo Laca**](), and [**Keane Sulit**](https://www.linkedin.com/in/keane-sulit/). It was supervised by [**Ramon Stephen L. Ruiz**](https://www.linkedin.com/in/r-stephen-ruiz-8302712b/).

The project was created using MATLAB R2022b/R2023a, and is a fully functional application that can encrypt and decrypt text using steganography. The application can be used to hide text messages in images, and can also be used to extract hidden text messages from images. The application is also unique to a specific user, as it uses MD5 hashing to hash the user's credentials as a key to encrypt and decrypt the text.

# **Files**
The project has the following files:
- `main.m` - The main script of the application. It runs the GUI of the login and registration page.

- `steg.m` - The script that allows the user to encrypt and decrypt text using image-based steganography.

- `encrypt.m` - The script that encrypts text using steganography.

- `decrypt.m` - The script that decrypts hidden text using steganography.

- `login.m` - The script that allows the user to login to the application.

- `register.m` - The script that allows the user to register to the application.

- `isusernameexist.m` - The script that checks if the username entered by the user already exists in the application.

- `DataHash.m` - The script that hashes the user's credentials to be used as a key to encrypt and decrypt the text. This script was taken from [here](https://www.mathworks.com/matlabcentral/fileexchange/31272-datahash).

- `lena_std.tiff` - The image used to demonstrate the application.

- `account.txt` - The text file that stores the user's credentials. This file is updated when the user registers to the application.


# **Features**
The application has the following features:

## Main Features
- Encrypts text using steganography
- Decrypts hidden text using steganography

## Additional Features
- Allows the user to register to the application
- Allows the user to login to the application
- Unique to a specific user
- Uses MD5 hashing to hash the user's credentials as a key to encrypt and decrypt the text
- Saves the user's credentials in a text file
## Error Handling Features
- Checks if the username entered by the user already exists in the application
- Checks if the user entered the correct credentials when logging in
- Checks if the user entered the correct credential requiremnents when registering
- Checks if the user has access to decrypt the text in the image

# **Installation**
To install the application, clone the repository or download as a `.zip` file. 

# **Usage**
To use the application, Rrun the `main.m` file in a MATLAB script. It can also be run directly in the MATLAB command window.

# **Documentation**
The full documentation of the project can be found [here]().
A demonstration of the application can be found [here]().

# **Contributing**
If you wish to contribute to the project, fork the repository and create a pull request.

# **License**
This project has no license. 
