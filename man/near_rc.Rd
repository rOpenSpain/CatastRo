\name{near_rc}
\alias{near_rc}

\title{Interface to query Consulta_RCCOOR_Distancia}

\description{Returns the Cadastral Reference of the state as well as the address (municipality, street and number) given its coordinates and the spatial reference system. In case that there is not any cadastral reference in the exact point, the function returns all the cadastral references in a square 50 meters long centered in the current point.}
\usage{
near_rc(lat, lon, SRS = NA, sleep_time = NA)
}
%- maybe also 'usage' for other objects documented here. 
\arguments{
  \item{lat}{Latitude coordinate.}
  \item{lon}{Longitude coortinate.}
  \item{SRS}{The reference system used for the coordinates. There is a vector with all the allowed SRSs in the variable from the package called coordinates. If no SRS is given, the function will make a request for every possible SRS.}
  \item{sleep_time}{System sleep time (in seconds) after the API reponse. This may be helpfull to automate an amount of request greater the allowed}
}

\value{
A data.frame with the the addresses of the states and the cadastral references in the nearby area of the location given for every SRS requested.
}
\references{
\url{http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_RCCOOR_Distancia}
}
\author{
Angel Delgado Panadero.
}

\examples{

direction <- near_rc(40.96002, -5.663408)
print(direction)    

}
