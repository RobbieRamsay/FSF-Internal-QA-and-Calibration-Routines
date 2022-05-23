#testing binary reading of ASD files

#read ASD binary file
ASD_test = file("/home/rramsay/Documents/Programming Work/Internal QA and Calibration Routines/Sphere Intercalibration/2022-04 -- HELIOS USS-1200/Raw Data/Intercal_00000.asd", "rb")


#run both together -- seek defines the start point for readBin
#readBin takes the connnection, asks for type, size and endian
#in combination with seek, returns desired value
#consult ASD file format to expand to include all metadata and spectra

#basis of function
#create function that acquires metadata, arguments being each aspect of metadata

#comments
seek(ASD_test, where = 0, origin = "start", rw = "r")
readBin(ASD_test, what = character(), size = 2, endian = "little")

#when the spectra were acquired
seek(ASD_test, where=160, origin = "start", rw = "r")
tm <- readBin(ASD_test, what = integer(), size = 2, n = 6, endian = "little")
dat_time <- ISOdatetime(tim[6] + 1900, tm[5] + 1, tm[4], tm[3], tm[2], tm[1])

#program version -- really needed...?
seek(ASD_test, where=178, origin = "start", rw = "r")
readBin(ASD_test, what = raw(), size = 1, endian = "little")

#Dark current subtracted? Logical
seek(ASD_test, where=181, origin = "start", rw = "r")
readBin(ASD_test, what = logical(), size = 1, endian = "little")

#data type -- raw DN, reflectance, radiance, no units, irradiance, qi, transmission, unknown, absorption
data_type <- c('raw', 'reflectance', 'radiance', 'no_units', 'irradiance', 'qi', 'transmittance', 'unknown', 'absorbance')
seek(ASD_test, where=186, origin = "start", rw = "r")
rw <- readBin(ASD_test, what = integer(), size = 1, endian = "little")
data_type[rw + 1]

#calibrated starting wavelength
seek(ASD_test, where=191, origin = "start", rw = "r")
readBin(ASD_test, what = numeric() , size = 4, endian = "little")

#calibrated wavelength step
seek(ASD_test, where=195, origin = "start", rw = "r")
readBin(ASD_test, what = numeric() , size = 4, endian = "little")

#data format
formats <- c('numeric', 'integer', 'double', 'unknown')
seek(ASD_test, where = 199, origin = "start", rw = "r")
result <- readBin(ASD_test, what = integer(), size = 1, endian ="little")
format <- formats[result - 1]

#channel number
seek(ASD_test, where = 204, origin = "start")
readBin(ASD_test, what = integer(), size = 2, endian = "little")

#integration time in VNIR
seek(ASD_test, where = 390, origin = "start")
readBin(ASD_test, what = integer(), size = 4, endian = "little")

#foreoptic used, 0 is bare fibre
seek(ASD_test, where = 394, origin = "start")
readBin(ASD_test, what = integer(), size = 2, endian = "little")

#dark current correction
seek(ASD_test, where = 396, origin = "start")
readBin(ASD_test, what = integer(), size = 2, endian = "little")

#instrument number
seek(ASD_test, where = 400, origin = "start")
readBin(ASD_test, what = integer(), size = 2, endian = "little")

#dynamic range
seek(ASD_test, where = 418, origin = "start")
readBin(ASD_test, integer(), size = 2, endian = "little")

#SWIR1_gain
seek(ASD_test, where = 436, origin = "start")
readBin(ASD_test, what = integer(), size = 2, endian = "little")

#SWIR2_gain
seek(ASD_test, where = 438, origin = "start")
readBin(ASD_test, what = integer(), size = 2, endian = "little")

#SWIR1_offset
seek(ASD_test, where = 440, origin = "start")
readBin(ASD_test, what = integer(), size = 2, endian = "little")

#SWIR2_offset
seek(ASD_test, where = 442, origin = "start")
readBin(ASD_test, what = integer(), size = 2, endian = "little")

#VNIR and SWIR1 splice
seek(ASD_test, where = 444, origin = "start")
readBin(ASD_test, what = numeric(), size = 4, endian = "little")

#VNIR and SWIR2 splice
seek(ASD_test, where = 448, origin = "start")
readBin(ASD_test, what = numeric(), size = 4, endian = "little")

#spectra 
seek(ASD_test, where = 484, origin = "start")
spectral_output <- readBin(ASD_test, what = numeric(), n = 2151, endian = "little")

spectral_output_test <- as.data.frame(spectral_output)



     


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


