# AU280_AES256
Implementations of AES, including Python and C++ flavors. Primary files are Verilog implemenation of AES256 bit ECB encryption, with potential future upgrades including adding different encryption ciphers and Dynamic Funcion eXchange.

To run the C++ implementation: download the C++ AES folder, and open the directory in your terminal. Use the command "make" to make the executeable, and use the command "./aes256" to run the program.

To run the Python implementation: download the Python AES folder, execute script. Suggested Python version is 3.12.6+.

For both Python and C++ implementations: To swap from the long string to short, find the value variable (C++ VALUE), comment the unwanted string and uncomment the desired plaintext.

Executing the Verilog implementation isn't feasible in this current state; there is a bitstream file, the program does work to solve encryption, but it has no buffer and is only connected via GPIO pins. What this means is that one would need to physically connect the busses to the GPIO pins, all 256 of them (128 for input, 128 for output), and write software to populate each of these pins, which would require interfacing with specialized hardware. However, we can still simulate the encryption process as it swaps every clock cycle whether it shows encrypted or decrypted information, and this is a solid core for the program I wanted to implement.

Some files have entire modules commented out; those are for interacting with the PCI Express interface, but I couldn't get the DMA IP to work with it. Ran into a similar issue with the QSFP ports, which upon further research seems to be due to my XDC file not containing all of the possible pins on the board (translation: the file that defines where all of my input/output ports are doesn't have an accurate list of all of the available ports and what they are for, unlike every other XDC file I've used).

To simulate the Verilog design, open the project in Vivado, and on the flow navigator (i.e. left side of the screen) click "run simulation->run behavorial simulation"
