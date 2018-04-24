\name{get_rc}
\alias{get_rc}

\title{Interface to query Consulta_RCCOOR}

\description{Returns the Cadastral Reference of the state as well as the address (municipality, street and number) being given its coordinates and the reference system. If the SRS is not passed as an argument, then the function will try a get request for each available reference system and it will return all no null responses.}
\usage{
get_rc(lat, lon, SRS = NA, sleep_time = NA)
}
%- maybe also 'usage' for other objects documented here. 
\arguments{
  \item{lat}{Latitude coordinate.}
  \item{lon}{Longitude coortinate.}
  \item{SRS}{The reference system used for the coordinates. There is a vector with all the allowed SRSs in the variable from the package called coordinates. If no SRS is given, the function will make a request for every possible SRS.}
  \item{sleep_time}{System sleep time (in seconds) after the API reponse. This may be helpfull to automate an amount of request greater the allowed}
}

\value{
A data.frame with the the addresses of the states and the cadastral references for every SRS requested.
}
\references{
\url{http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_RCCOOR}
}
\author{
Angel Delgado Panadero.
}

\examples{

direction <- get_rc(38.6196566583596,-3.45624183836806, 'EPSG:4230')
print(direction)    


directions <- get_rc(38.6196566583596,-3.45624183836806)
print(directions) 
}
