\name{getRC}
\alias{getRC}

\title{Interface to query Consulta_RCCOOR from Sede electrónica del catastro API}

\description{Returns the Cadastral Reference of the state as well as the direction (municipality, street and number) given its coordinates and the reference system.}
\usage{
getRC(X, Y, SRS)
}
%- maybe also 'usage' for other objects documented here. 
\arguments{
  \item{X}{Coordinate X.}
  \item{Y}{Coortinate Y.}
  \item{SRS}{The reference system used for the coordinates. A list of all the allowed references system is given in References.}

}

\value{
A string with the direction of the state.
}
\references{
\url{http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_RCCOOR}
}
\author{
Ángel Delgado Panadero.
}

\examples{

direction <- getRC(-3.45624183836806, 38.6196566583596)
print(direction)    

}
