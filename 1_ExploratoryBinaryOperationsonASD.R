#testing binary reading of ASD files

#read ASD binary file
ASD_test = file("Intercal_00000.asd", "rb")


#run both together -- seek defines the start point for readBin
#readBin takes the connnection, asks for type, size and endian
#in combination with seek, returns desired value
#consult ASD file format to expand to include all metadata and spectra

seek(ASD_test, where = 0, origin = "start", rw = "r")
readBin(ASD_test, what = character(), size = 157, endian = "little")

#to get the reference metadata need to determine spectra file size
#spectra file size is byte 485 + integer of number of channels
#number of channels is an integer defined at byte number 204

#channel number
seek(ASD_test, where = 204, origin = "start")
readBin(ASD_test, what = integer(), size = 2, endian = "little")

#that provides a value of 2151 which is correct
#reference channel therefore begins at 485 + 2151, plus 1
#reference channel should begin at byte 2637
#to test that, read the string in the reference file
#offset is 19, so start is 2656
#readchar function better option here

seek(ASD_test, where = 2656, origin = "start")
readChar(ASD_test, nchars = 30)

#Doesn't work due to invalid encoding
#Why do we need this though? Is there reference file header required?
#For putting into an array, we can just read the name of the filename from dir


