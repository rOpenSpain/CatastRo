\name{get_rc}
\alias{get_rc}

\title{Interface to query Consulta_RCCOOR}

\description{Returns the Cadastral Reference of the state as well as the address (municipality, street and number) being given its coordinates and the reference system. If the SRS is not passed as an argument, then the function will try a get request for each available reference system and it will return all no null responses.}
\usage{
get_rc(lat, lon, SRS)
}
%- maybe also 'usage' for other objects documented here. 
\arguments{
  \item{lat}{Latitude coordinate.}
  \item{lon}{Longitude coortinate.}
  \item{SRS}{The reference system used for the coordinates. A list of all the allowed references system is given in References.}

}

\value{
A list with the the direction of the state and the cadastral reference.
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
