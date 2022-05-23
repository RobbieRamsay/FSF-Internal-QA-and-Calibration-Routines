library(stats)
library(readxl)
library(ggplot2)

#Read calibration certificate of secondary source
#HELIOS - 2022-01-31 LabSphere calibration

Helios_Certificate <- read_excel("/home/rramsay/Documents/Programming Work/Internal QA and Calibration Routines/Sphere Intercalibration/2022-04 -- HELIOS USS-1200/Documents and Calibration Certificates/2022-01-31_LabSphere/114022-2-6 1nm data.xls")

Helios_Certificate_Plot <-
  ggplot(Helios_Certificate, aes(Helios_Certificate$`Wavelengh (nm)`, Helios_Certificate$`Spectral Radiance (uW/cm2-sr-nm)`)) + 
  geom_ribbon(aes(ymin = Helios_Certificate$`Spectral Radiance (uW/cm2-sr-nm)` - Helios_Certificate$`Expanded Spectral Radiance Uncertainty k=2 (uW/cm2-sr-nm)`,
                  ymax = Helios_Certificate$`Spectral Radiance (uW/cm2-sr-nm)` + Helios_Certificate$`Expanded Spectral Radiance Uncertainty k=2 (uW/cm2-sr-nm)`),
              fill = "steelblue2") + 
  geom_line(color = "firebrick", size = 1)



#Extrapolation of Helios Data to 2500 nm
Helios_Interpolated <- mapply(Helios_2500_Interpolation_Lambda, Helios_2500_Interpolation_Uncertainity)

Helios_2500_Interpolation_Lambda <- as.data.frame(spline(Helios_Certificate$`Wavelengh (nm)`,
                                                         Helios_Certificate$`Spectral Radiance (uW/cm2-sr-nm)`,
                                                         method = c("natural"),
                                                         xmin = 350, xmax = 2500, n = 2151),
                                                  col.names = c("Wavelength (nm)", "Spectral Radiance (uW/cm2-sr-nm)"), check.names=FALSE)

Helios_2500_Interpolation_Uncertainity <- as.data.frame(spline(Helios_Certificate$`Wavelengh (nm)`,
                                                               Helios_Certificate$`Expanded Spectral Radiance Uncertainty k=2 (uW/cm2-sr-nm)`,
                                                               method = c("natural"),
                                                               xmin = 350, xmax = 2500, n = 2151),
                                                        col.names = c("Wavelength (nm)", "Expanded Spectral Radiance Uncertainty k=2 (uW/cm2-sr-nm)"), check.names=FALSE)

#New dataframe of extrapolated Helios calibration data
Helios_2500_Interpolated <- merge(Helios_2500_Interpolation_Lambda, Helios_2500_Interpolation_Uncertainity)



  


