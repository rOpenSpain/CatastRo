\name{getCOOR}
\alias{getCOOR}

\title{Interface to query Consulta_CPMRC from Sede electrónica del catastro API}

\description{Returns the coordinate of a state in a reference system, given the Province, Municipality and Cadastral Reference of the state.}
\usage{
getCOOR(RC, SRS, Province, Municipality)
}
%- maybe also 'usage' for other objects documented here. 
\arguments{
  \item{RC}{Cadastral reference of the state.}
  \item{SRS}{The reference system desired for the coordinates, if it is missed, the returned coordinates will be given in the system reference in which it was stored. A list of all the possible references system is given in References.}
  \item{Province}{Province of the state. It is not case sensitive.}
  \item{Municipality}{Municipality of the state. It is not case sensitive.}
}

\value{
A list consisting of two  numeric values with the coordinates (lat,lon) and the reference system in which they are expressed.
}
\references{
\url{http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_CPMRC}
}
\author{
Angel Delgado Panadero.
}

\examples{

# using all the arguments
coordinates <- getCOOR('13077A01800039','EPSG:4230','CIUDAD REAL', 'SANTA CRUZ DE MUDELA')
print(coordinates)    

# only the cadastral reference
coordinates <- getCOOR('9872023VH5797S')
print(coordinates) }
