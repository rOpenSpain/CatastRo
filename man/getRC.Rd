\name{getRC}
\alias{getRC}

\title{Interface to query Consulta_RCCOOR}

\description{Returns the Cadastral Reference of the state as well as the address (municipality, street and number) given its coordinates and the reference system.}
\usage{
getRC(lat, lon, SRS)
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

direction <- getRC(-3.45624183836806, 38.6196566583596)
print(direction)    

}
