Getting Started
========================

Packages required
*********************************
In order for the GUI to work the user must have the following MATLAB toolboxes,
packages and Arduino libraries installed in his computer:

- MATLAB Toolboxes

  * `Image Acquisition <http://se.mathworks.com/products/imaq/>`_

  * `Image Processing <http://se.mathworks.com/products/image/>`_

- MATLAB Packages

  * `Image Acquisition Adaptors <http://se.mathworks.com/help/imaq/installing-the-support-packages-for-image-acquisition-toolbox-adaptors.html>`_

- Arduino Library

  * `AccelStepper  <http://www.airspayce.com/mikem/arduino/AccelStepper/>`_
    (included in the ArduinoCode folder) 


.. note:: In future versions an exe file will possibly be made as well, so that
 the setup operation is fully automated.

Setup and Execution
*********************************

To download the project navigate to the corresponding `Github repository <https://github.com/bergercookie/ElecMicroscope>`_ and either clone the project or downlaod the zip version.

.. figure:: ../Images/projectDownload.png
   :align: center
   :scale: 50 %

Before running the GUI, the user must have a series of packages and extensions
installed in MATLAB. These are described in the `Packages required`_ section
above. If everything looks OK, the user can then proceed and upload the Arduino
Code to the Arduino, start matlab and and then launch the GUI from its
corresponding folder. 

.. figure:: ../Images/arduinoCode.png
   :align: center
   :scale: 50 %

A summary of the steps is also described below:

- Download the ZIP file/ Clone the Github repository
- Upload the arduino code (ArduinoCode.ino) to the Arduino
- Launch matlab, run the 'microscope' command (make sure you are running it
  from inside its corresponding folder)


.. warning:: Make sure you close MATLAB before trying to upload a different
 version of the arduino code. Otherwise the Arduino IDE will not be able to
 upload the program using the specified port as MATLAB still has
 read/write access to the port.

